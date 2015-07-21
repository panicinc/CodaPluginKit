#import "ZapPlugIn.h"
#import "CodaPlugInsController.h"

@interface ZapPlugIn ()

- (id)initWithController:(CodaPlugInsController*)aController;
- (void)loadInterface;

@end

@implementation ZapPlugIn

@synthesize zapControl;
@synthesize zapNonAscii;
@synthesize zapNull;
@synthesize zapIllegal;
@synthesize replaceZapTag;


#pragma mark Required Coda Plugin Methods


// Support for Coda 2.0 and lower

- (id)initWithPlugInController:(CodaPlugInsController*)aController bundle:(NSBundle*)yourBundle
{
    return [self initWithController:aController];
}

// Support for Coda 2.0.1 and higher
// NOTE: must set the CodaPlugInSupportedAPIVersion key to 6 or above to use this init method

- (id)initWithPlugInController:(CodaPlugInsController*)aController plugInBundle:(NSObject <CodaPlugInBundle> *)plugInBundle
{
   return [self initWithController:aController];
}


- (id)initWithController:(CodaPlugInsController*)aController
{
    if ( (self = [super init]) != nil )
    {
        //store controller pointer
        controller = aController;
    
        //add menu item in Coda
        [controller registerActionWithTitle:NSLocalizedString(@"Zap Gremlins...", @"") target:self selector:@selector(showDialog)];
    }

    return self;
}


- (NSString*)name
{
	return @"Zap Gremlins";
}

- (void)loadInterface
{
    [NSBundle loadNibNamed:@"ZapDialog" owner:self];

    //set default zapper values that are bound in UI
       
    self.zapControl = YES;
    self.zapNonAscii = NO;
    self.zapNull = YES;
    self.zapIllegal = YES;
    self.replaceZapTag = 1;
}

#pragma mark Show and Close Sheet

- (void)showDialog
{	
	if ( zapDialog == nil )
    {
        //lazy load nib to avoid making Coda slow to launch
        [self loadInterface];
    }
    
    CodaTextView	*textView = [controller focusedTextView];
	NSWindow		*window = [textView window];
	
	[zapDialog makeFirstResponder:illegalCheckbox];
	
	if ( window && ![window attachedSheet] )
		[NSApp beginSheet:zapDialog modalForWindow:window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];	
	else
		NSBeep();
}


- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	//process zap gremlins after sheet closes
	
	if ( returnCode == NSOKButton )
	{	
		CodaTextView	*textView = [controller focusedTextView];
		NSString		*text = nil;
		BOOL			replacingSelection = YES;
		NSMutableString *resultText = nil;
	
		if ( textView )
		{
			//check to see if there is a selection and zap only that, else zap entire document
			text = [textView selectedText];
			
			if ( [text isEqualToString:@""] )
			{
				text = [textView string];
				replacingSelection = NO;
			}
			
			if ( text != nil )
			{
				resultText = [NSMutableString stringWithString:text];
				NSString		*replacementText = nil;
				
				switch ( replaceZapTag )
				{
					case 1:
						replacementText = @""; //delete characters
						break;
					case 2:
						replacementText = nil; //replace with hex code
						break;
					default:
						replacementText = [replaceField stringValue]; //replace with specific string
				}
				
				if ( zapControl )
				{
					if ( replacementText )
						[resultText replaceCharactersInSet:[NSCharacterSet controlCharacterSet] withString:replacementText];
					else
						[resultText replaceCharactersInSetWithHexCodes:[NSCharacterSet controlCharacterSet]];
				}
					
				if ( zapNonAscii )
				{
					NSCharacterSet			*ascii = [NSCharacterSet characterSetWithRange:NSMakeRange(0, 128)];
					NSCharacterSet			*nonAscii = [ascii invertedSet];
					
					if ( replacementText )
						[resultText replaceCharactersInSet:nonAscii withString:replacementText];
					else
						[resultText replaceCharactersInSetWithHexCodes:nonAscii];
				}
				
				if ( zapNull )
				{
					NSCharacterSet *nullCharSet = [NSCharacterSet characterSetWithRange:NSMakeRange(0, 1)];
					
					if ( replacementText )
						[resultText replaceCharactersInSet:nullCharSet withString:replacementText];
					else
						[resultText replaceCharactersInSetWithHexCodes:nullCharSet];
				}
				
				if ( zapIllegal )
				{
					if ( replacementText )
						[resultText replaceCharactersInSet:[NSCharacterSet illegalCharacterSet] withString:replacementText];
					else
						[resultText replaceCharactersInSetWithHexCodes:[NSCharacterSet illegalCharacterSet]];
				}
			
				if ( replacingSelection )
				{
					//replaces the selected text
					[textView insertText:resultText];
				}
				else
				{
					//replace the entire text buffer
					[textView replaceCharactersInRange:NSMakeRange(0, [text length]) withString:resultText];
				}				
			}
		}
	}

	[sheet close];
}


#pragma mark Actions

- (IBAction)cancelAction:(id)sender
{
	[NSApp endSheet:zapDialog returnCode:NSCancelButton];
}


- (IBAction)zapAction:(id)sender
{
	[NSApp endSheet:zapDialog returnCode:NSOKButton];
}


#pragma mark Menu Validation

- (BOOL)validateMenuItem:(NSMenuItem*)aMenuItem
{
	BOOL	result = YES;
	SEL		action = [aMenuItem action];
	
	if ( action == @selector(showDialog) )
	{
		CodaTextView	*textView = [controller focusedTextView];
		
		// if a text view is not visible, we can't zap gremlins
		if ( textView == nil )
			result = NO;
	}
	
	return result;
}


#pragma mark Clean-up

- (void)dealloc
{
	[zapDialog release];
	
	[super dealloc];
}

@end

					
@implementation NSMutableString (NSCharacterSetReplacement)

- (void)replaceCharactersInSet:(NSCharacterSet*)charSet withString:(NSString*)aString
{
	NSRange	range = NSMakeRange(0, [self length]);
	
	if ( aString == nil )
		aString = @"";
	
	while( range.location != NSNotFound ) 
	{		
		range = [self rangeOfCharacterFromSet:charSet options:0 range:range];
		
		if ( range.location != NSNotFound )
		{
			[self replaceCharactersInRange:range withString:aString];
			
			//adjust remaining length
			NSRange remainingRange;
						
			remainingRange.length = [self length] - (range.location + [aString length]);
			remainingRange.location = range.location + [aString length];
			
			range = remainingRange;
		}
	}	
}


- (void)replaceCharactersInSetWithHexCodes:(NSCharacterSet *)charSet
{
	NSRange		range = NSMakeRange(0, [self length]);
	unichar		curChar;
	NSString	*formattedChar = @"\\0x%X";
	NSString	*hexString = nil;
	
	while( range.location != NSNotFound ) 
	{		
		range = [self rangeOfCharacterFromSet:charSet options:0 range:range];
		
		if ( range.location != NSNotFound )
		{
			//convert found char to hex character code
			curChar = [self characterAtIndex:range.location];
			hexString = [NSString stringWithFormat:formattedChar, curChar];						
						
			[self replaceCharactersInRange:range withString:hexString];
			
			//adjust remaining length
			NSRange remainingRange;
			
			remainingRange.length = [self length] - (range.location + [hexString length]);
			remainingRange.location = range.location + [hexString length];
			
			range = remainingRange;
		}
	}
}

@end
