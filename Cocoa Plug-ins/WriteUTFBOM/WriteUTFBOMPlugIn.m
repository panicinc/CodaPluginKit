#import "WriteUTFBOMPlugIn.h"
#import "CodaPlugInsController.h"

@interface WriteUTFBOMPlugIn ()

- (id)initWithController:(CodaPlugInsController*)inController;

@end

@interface NSData (BOM)

+ (NSData*)pc_dataWithContentsOfFileAtPath:(NSString*)path numberOfBytes:(size_t)numberOfBytes;
+ (NSData*)pc_UTF8BOM;
- (BOOL)pc_hasUTF8BOM;
- (BOOL)pc_hasUTF16BOM;

@end

@implementation NSData (BOM)

+ (NSData*)pc_dataWithContentsOfFileAtPath:(NSString*)path numberOfBytes:(size_t)numberOfBytes
{
	NSData* data = nil;
	int descriptor = open([path fileSystemRepresentation], O_RDONLY, 0);
	
	if ( descriptor != 0 )
	{
		char* bytes = malloc(numberOfBytes);
		
		if ( bytes != NULL )
		{
			size_t sizeRead = 0;
			
			do
			{
				sizeRead = read(descriptor + sizeRead, bytes, numberOfBytes - sizeRead);
			} while ( sizeRead > 0 && sizeRead < numberOfBytes );
			
			close(descriptor);
			
			if ( sizeRead == numberOfBytes )
			{
				data = [NSData dataWithBytesNoCopy:bytes length:numberOfBytes];
			}
			
			if ( data == nil )
			{
				free(bytes);
			}			
		}
	}
	
	return data;
}

static const char kUTF8BOM[] = {0xEF, 0xBB, 0xBF};

+ (NSData*)pc_UTF8BOM
{
	return [[[NSData alloc] initWithBytes:kUTF8BOM length:sizeof(kUTF8BOM)] autorelease];
}

- (BOOL)pc_hasUTF8BOM
{
	BOOL hasBOM = NO;
	
	if ( [self length] >= sizeof(kUTF8BOM) )
	{
		char prefix[sizeof(kUTF8BOM)];
		
		[self getBytes:&prefix range:NSMakeRange(0, sizeof(kUTF8BOM))];
		
		hasBOM = (memcmp(kUTF8BOM, prefix, sizeof(kUTF8BOM)) == 0);
	}
	
	return hasBOM;
}

static const uint16_t kUTF16LEBOM = 0xFFFE;
static const uint16_t kUTF16BEBOM = 0xFEFF;

+ (NSData*)pc_UTF16BOM
{
#if defined(__BIG_ENDIAN__)
	return [[[NSData alloc] initWithBytes:&kUTF16BEBOM length:sizeof(kUTF16BEBOM)] autorelease];
#else
	return [[[NSData alloc] initWithBytes:&kUTF16LEBOM length:sizeof(kUTF16LEBOM)] autorelease];
#endif
}

- (BOOL)pc_hasUTF16BOM
{
	BOOL hasBOM = NO;
	
	if ( [self length] >= sizeof(uint16_t) )
	{
		uint16_t prefix = 0;
		[self getBytes:&prefix range:NSMakeRange(0, sizeof(uint16_t))];
		
		hasBOM = (prefix == kUTF16LEBOM || prefix == kUTF16BEBOM);
	}
	
	return hasBOM;
}

@end

@implementation WriteUTFBOMPlugIn


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
		
		[controller registerActionWithTitle:NSLocalizedString(@"Save with UTF BOM", @"Save with UTF BOM") target:self selector:@selector(writeUTFBOM:)];
		[controller registerActionWithTitle:NSLocalizedString(@"Save without UTF BOM", @"Save without UTF BOM") target:self selector:@selector(writeWithoutUTFBOM:)];
	}
	return self;
}


- (NSString*)name
{
	return @"UTF BOMs";
}


- (void)writeUTFBOM:(id)sender
{
	CodaTextView* textView = [controller focusedTextView:self];
	
	if ( [textView path] != nil && [[NSFileManager defaultManager] fileExistsAtPath:[textView path]] )
	{
		NSData* data = [[textView string] dataUsingEncoding:[textView encoding] allowLossyConversion:NO];

		if ( data != nil )
		{
			if ( [textView encoding] == NSUTF8StringEncoding )
			{
				if ( ![data pc_hasUTF8BOM] )
				{
					NSMutableData* tmp = [NSMutableData dataWithData:[NSData pc_UTF8BOM]];
					[tmp appendData:data];
					data = tmp;
				}
				
				[textView save];
				[data writeToFile:[textView path] atomically:NO];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"CodaPlugInNotificationDidPerformAction" object:self userInfo:[NSDictionary dictionaryWithObject:NSStringFromSelector(_cmd) forKey:@"Action"]];
			}
			else if ( [textView encoding] == NSUnicodeStringEncoding || [textView encoding] == NSUTF16BigEndianStringEncoding || [textView encoding] == NSUTF16LittleEndianStringEncoding )
			{
				[textView save];
				[data writeToFile:[textView path] atomically:NO];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"CodaPlugInNotificationDidPerformAction" object:self userInfo:[NSDictionary dictionaryWithObject:NSStringFromSelector(_cmd) forKey:@"Action"]];
			}
		}
	}
}

- (void)writeWithoutUTFBOM:(id)sender
{
	CodaTextView* textView = [controller focusedTextView:self];
	
	if ( [textView path] != nil && [[NSFileManager defaultManager] fileExistsAtPath:[textView path]] )
	{
		if ( [textView encoding] == NSUTF8StringEncoding )
		{
			NSData* data = [[textView string] dataUsingEncoding:[textView encoding] allowLossyConversion:NO];

			if ( [data pc_hasUTF8BOM] )
			{
				data = [data subdataWithRange:NSMakeRange([[NSData pc_UTF8BOM] length], [data length] - [[NSData pc_UTF8BOM] length])];
			}
			
			[textView save];
			[data writeToFile:[textView path] atomically:NO];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"CodaPlugInNotificationDidPerformAction" object:self userInfo:[NSDictionary dictionaryWithObject:NSStringFromSelector(_cmd) forKey:@"Action"]];
		}
	}	
}

- (BOOL)validateMenuItem:(NSMenuItem*)menuItem
{
	BOOL menuItemIsValid = NO;
	
	if ( [menuItem action] == @selector(writeUTFBOM:) )
	{
		CodaTextView* textView = [controller focusedTextView:self];
		
		if ( [textView path] != nil )
		{
			if ( [textView encoding] == NSUTF8StringEncoding )
			{
				NSData* fileData = [NSData pc_dataWithContentsOfFileAtPath:[textView path] numberOfBytes:[[NSData pc_UTF8BOM] length]];
				menuItemIsValid = ![fileData pc_hasUTF8BOM];
			}
			else if ( [textView encoding] == NSUnicodeStringEncoding || [textView encoding] == NSUTF16BigEndianStringEncoding || [textView encoding] == NSUTF16LittleEndianStringEncoding )
			{
				NSData* fileData = [NSData pc_dataWithContentsOfFileAtPath:[textView path] numberOfBytes:[[NSData pc_UTF16BOM] length]];
				menuItemIsValid = ![fileData pc_hasUTF16BOM];
			}
		}
	}
	else if ( [menuItem action] == @selector(writeWithoutUTFBOM:) )
	{
		CodaTextView* textView = [controller focusedTextView:self];
		
		if ( [textView path] != nil )
		{
			if ( [textView encoding] == NSUTF8StringEncoding )
			{
				NSData* fileData = [NSData pc_dataWithContentsOfFileAtPath:[textView path] numberOfBytes:[[NSData pc_UTF8BOM] length]];
				menuItemIsValid = [fileData pc_hasUTF8BOM];
			}
		}
	}
	
	return menuItemIsValid;
}

@end
