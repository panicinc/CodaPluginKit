#import "CapitalizePlugIn.h"
#import "CodaPlugInsController.h"

@interface CapitalizePlugIn ()

- (id)initWithController:(CodaPlugInsController*)inController;

@end


@implementation CapitalizePlugIn

//2.0 and lower
- (id)initWithPlugInController:(CodaPlugInsController*)aController bundle:(NSBundle*)aBundle
{
    return [self initWithController:aController];
}


//2.0.1 and higher
- (id)initWithPlugInController:(CodaPlugInsController*)aController plugInBundle:(NSObject <CodaPlugInBundle> *)plugInBundle
{
    return [self initWithController:aController];
}


- (id)initWithController:(CodaPlugInsController*)inController
{
	if ( (self = [super init]) != nil )
	{
		controller = inController;
		[controller registerActionWithTitle:NSLocalizedString(@"Capitalize", @"Capitalize") target:self selector:@selector(capitalize:)];
		[controller registerActionWithTitle:NSLocalizedString(@"Uncapitalize", @"Uncapitalize") target:self selector:@selector(uncapitalize:)];
	}
    
	return self;
}


- (NSString*)name
{
	return @"Capitalize";
}


- (void)capitalize:(id)sender
{
	CodaTextView* tv = [controller focusedTextView];
	if ( tv )
	{
		NSString* selectedText = [tv selectedText];
		
		if ( selectedText )
		{
			NSRange savedRange = [tv selectedRange];		
			[tv insertText:[selectedText uppercaseString]];
			[tv setSelectedRange:savedRange];
		}
	}
}


- (void)uncapitalize:(id)sender
{
	CodaTextView* tv = [controller focusedTextView];
	if ( tv )
	{
		NSString* selectedText = [tv selectedText];
		
		if ( selectedText )
		{
			NSRange savedRange = [tv selectedRange];		
			[tv insertText:[selectedText lowercaseString]];
			[tv setSelectedRange:savedRange];
		}
	}
}

@end
