#import "PHPValidatorPlugIn.h"
#import "CodaPlugInsController.h"

@implementation PHPValidatorPlugIn

- (id)initWithPlugInController:(CodaPlugInsController*)aController plugInBundle:(NSObject <CodaPlugInBundle> *)plugInBundle
{
	if ( (self = [super init]) != nil )
	{
	}
	
	return self;
}

- (NSString*)name
{
	return @"PHP Validator";
}


- (id<CodaValidator>)validatorForModeIdentifier:(NSString*)modeIdentifier text:(NSString*)text encoding:(NSStringEncoding)encoding delegate:(id<CodaValidatorDelegate>)aDelegate
{
	PHPValidator *validator = [[[PHPValidator alloc] initWithText:text encoding:encoding delegate:aDelegate] autorelease];
	
	return validator;
}


- (NSArray*)supportedModeIdentifiers
{
	return [NSArray arrayWithObject:@"SEEMode.PHP-HTML"];
}


@end


@implementation PHPValidator

@synthesize filePath = iFilePath;
@synthesize task = iTask;
@synthesize delegate = iDelegate;
@synthesize source = iSource;
@synthesize encoding = iEncoding;
@synthesize cancelled = iCancelled;

- (id)initWithText:(NSString*)text encoding:(NSStringEncoding)encoding delegate:(id<CodaValidatorDelegate>)aDelegate
{
	if ( (self = [super init]) != nil )
	{
		CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorSystemDefault);
		CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorSystemDefault, uuid);
		NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:(NSString*)uuidString];
		
		self.filePath = [path stringByAppendingString:@"###.php"];
		self.delegate = aDelegate;
		self.source = text;
		self.encoding = encoding;
		
		if ( uuid != NULL ) CFRelease(uuid);
		if ( uuidString != NULL ) CFRelease(uuidString);
	}
	
	return self;
}


- (void)validate
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	if ( [self.source writeToFile:self.filePath atomically:NO encoding:self.encoding error:NULL] )
	{
		NSArray *args = [NSArray arrayWithObjects:@"-l", self.filePath, @"-d", @"display_errors=On", @"d", @"log_errors=Off", nil];
		self.task = [[[NSTask alloc] init] autorelease];
		[self.task setLaunchPath:@"/usr/bin/php"];
		[self.task setArguments:args];
		[self.task setStandardOutput:[NSPipe pipe]];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(taskDidEnd:)
													 name:NSTaskDidTerminateNotification
												   object:self.task];
	
		@try
		{
			[self.task launch];
			
			while ( !self.cancelled && [self.task isRunning] )
			{
				[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
			}
		}
		@catch (NSException *exception)
		{
			NSLog(@"Error staring validator:%@", [exception description]);
			[self.delegate validator:self didComplete:nil error:[NSError errorWithDomain:CodaPluginErrorDomain code:-2 userInfo:nil]];
		}
	}
	else
	{
		NSLog(@"Could not write file to path:%@", self.filePath);
		[self.delegate validator:self didComplete:nil error:[NSError errorWithDomain:CodaPluginErrorDomain code:-1 userInfo:nil]];
	}
		
	[pool drain];
}


- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	//clean up our temp file
	NSFileManager *mgr = [[[NSFileManager alloc] init] autorelease];
	[mgr removeItemAtPath:self.filePath error:NULL];
	
	[iFilePath release];
	[iTask release];
	[iSource release];
	
	[super dealloc];
}


- (void)cancel
{
	self.cancelled = YES;
	
	if ( [self.task isRunning] )
		[self.task terminate];
}


- (NSString*)name
{
	return @"PHP";
}


BOOL ContainsString(NSString *string1, NSString *string2)
{
	return ([string1 rangeOfString:string2 options:0].location != NSNotFound);
}


- (void)taskDidEnd:(NSNotification*)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSTaskDidTerminateNotification object:self.task];

	if ( !self.cancelled )
	{
		NSData *data = [[[self.task	standardOutput] fileHandleForReading] availableData];
		NSString *dataString = nil;
		
		if ( data )
			dataString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
		
		//this linter only supports one error at a time, parse & return it
		NSArray *results = nil;
		
		if ( ContainsString(dataString, @"No syntax errors detected") )
		{
			results = [NSArray array];
		}
		else
		{
			//parse error output
			NSScanner *scanner = [NSScanner scannerWithString:dataString];
			[scanner setCharactersToBeSkipped:nil];
			
			NSString *lineNumber = nil;
			NSString *message = nil;

			[scanner scanUpToString:@"\nParse error: " intoString:NULL];
			[scanner scanString:@"\nParse error: " intoString:NULL];
			[scanner scanString:@"parse error, " intoString:NULL];
			[scanner scanUpToString:[NSString stringWithFormat:@" in %@", self.filePath] intoString:&message];

			[scanner scanUpToString:@" on line " intoString:NULL];
			[scanner scanString:@" on line " intoString:NULL];
			[scanner scanUpToString:@"\n" intoString:&lineNumber];
			
			if ( lineNumber == nil )
				lineNumber = @"1";
			
			if ( message == nil )
				message = @"";
			
			NSDictionary *error = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:[lineNumber integerValue]], kValidatorLineKey,
								   message, kValidatorMessageStringKey, kValidatorTypeError, kValidatorErrorTypeKey, nil];
			results = [NSArray arrayWithObject:error];
		}
	
		[self.delegate validator:self didComplete:results error:nil];
	}
}

@end
