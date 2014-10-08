#import <Cocoa/Cocoa.h>
#import "CodaPluginsController.h"

@class CodaPlugInsController;

@interface WriteUTFBOMPlugIn : NSObject <CodaPlugIn>
{
	CodaPlugInsController* controller;
}


@end
