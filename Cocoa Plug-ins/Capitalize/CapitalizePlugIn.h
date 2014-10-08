#import <Cocoa/Cocoa.h>
#import "CodaPluginsController.h"

@class CodaPlugInsController;

@interface CapitalizePlugIn : NSObject <CodaPlugIn>
{
	CodaPlugInsController* controller;
}

@end
