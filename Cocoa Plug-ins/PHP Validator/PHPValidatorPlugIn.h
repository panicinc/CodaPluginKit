#import <Cocoa/Cocoa.h>
#import "CodaPluginsController.h"

@class PHPValidator;

@interface PHPValidatorPlugIn : NSObject <CodaValidatorPlugIn>
{
}

@end


@interface PHPValidator : NSObject <CodaValidator>
{
	NSTask			*iTask;
	NSMutableArray	*iErrors;
	NSString		*iFilePath;
	NSString		*iSource;
	NSStringEncoding iEncoding;
	id <CodaValidatorDelegate> iDelegate;
	BOOL			iCancelled;
}

@property (retain) NSTask *task;
@property (retain) NSString* filePath;
@property (retain) NSString* source;
@property (assign) NSStringEncoding encoding;
@property (assign) BOOL cancelled;
@property (assign) id <CodaValidatorDelegate> delegate;

- (id)initWithText:(NSString*)text encoding:(NSStringEncoding)encoding delegate:(id<CodaValidatorDelegate>)aDelegate;


@end