//
//  ZapPlugInViewController.m
//  Zap Gremlins
//
//  Created by Wade Cosgrove on 5/20/13.
//
//

#import "ZapPlugInViewController.h"
#import "CodaPlugInsController.h"
#import <objc/runtime.h>

@implementation ZapPlugInViewController

@synthesize pluginController;
@synthesize zapControl;
@synthesize zapNonAscii;
@synthesize zapNull;
@synthesize zapIllegal;
@synthesize replaceZapTag;


- (id)initWithNibName:(NSString*)nibName plugInBundle:(id <CodaPlugInBundle>)plugInBundle plugInController:(CodaPlugInsController*)aController
{
    self = [super initWithNibName:nibName bundle:plugInBundle];
    if (self)
	{
		self.pluginController = aController;
		
	    //set default zapper values that are bound in UI
       
		self.zapControl = YES;
		self.zapNonAscii = NO;
		self.zapNull = YES;
		self.zapIllegal = YES;
		self.replaceZapTag = 1;
    }
    
    return self;
}


- (IBAction)zapAction:(id)sender
{
	CodaTextView	*textView = [self.pluginController focusedTextView:self];
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

