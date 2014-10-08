//
//  ZapPlugInViewController.h
//  Zap Gremlins
//
//  Created by Wade Cosgrove on 5/20/13.
//
//

#import <Cocoa/Cocoa.h>
#import "CodaPluginsController.h"


@interface ZapPlugInViewController : NSViewController <CodaSidebarViewController>
{
	CodaPlugInsController	*pluginController;

	IBOutlet NSButton		*illegalCheckbox;
	IBOutlet NSTextField	*replaceField;
	
	BOOL					zapControl;
	BOOL					zapNonAscii;
	BOOL					zapNull;
	BOOL					zapIllegal;
	NSInteger               replaceZapTag;
}

- (id)initWithNibName:(NSString*)nibName plugInBundle:(id <CodaPlugInBundle>)plugInBundle plugInController:(CodaPlugInsController*)aController;

@property (assign) CodaPlugInsController *pluginController;
@property (assign) BOOL zapControl;
@property (assign) BOOL zapNonAscii;
@property (assign) BOOL zapNull;
@property (assign) BOOL zapIllegal;
@property (assign) NSInteger replaceZapTag;

- (IBAction)zapAction:(id)sender;

@end


@interface NSMutableString (NSCharacterSetReplacement)

- (void)replaceCharactersInSet:(NSCharacterSet *)charSet withString:(NSString*)aString;
- (void)replaceCharactersInSetWithHexCodes:(NSCharacterSet *)charSet;

@end