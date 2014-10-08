#import <Cocoa/Cocoa.h>
#import "CodaPluginsController.h"

@class CodaPlugInsController;

@interface ZapPlugIn : NSObject <CodaPlugIn>
{
	CodaPlugInsController	*controller;
	IBOutlet NSWindow		*zapDialog;
	IBOutlet NSButton		*illegalCheckbox;
	
	BOOL					zapControl;
	BOOL					zapNonAscii;
	BOOL					zapNull;
	BOOL					zapIllegal;
	NSInteger               replaceZapTag;
	
	IBOutlet NSTextField	*replaceField;
	
}

@property (assign) BOOL zapControl;
@property (assign) BOOL zapNonAscii;
@property (assign) BOOL zapNull;
@property (assign) BOOL zapIllegal;
@property (assign) NSInteger replaceZapTag;

/* required coda plugin methods */

//for Coda 2.0.1 and higher
- (id)initWithPlugInController:(CodaPlugInsController *)aController plugInBundle:(NSObject <CodaPlugInBundle> *)plugInBundle;

//for Coda 2.0 and lower
- (id)initWithPlugInController:(CodaPlugInsController*)aController bundle:(NSBundle*)yourBundle;

- (NSString*)name;

/* actions */
- (IBAction)cancelAction:(id)sender;
- (IBAction)zapAction:(id)sender;

@end


@interface NSMutableString (NSCharacterSetReplacement)

- (void)replaceCharactersInSet:(NSCharacterSet *)charSet withString:(NSString*)aString;
- (void)replaceCharactersInSetWithHexCodes:(NSCharacterSet *)charSet;

@end