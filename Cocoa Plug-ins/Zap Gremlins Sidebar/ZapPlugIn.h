//
//  ZapPlugIn.h
//  Zap Gremlins
//
//  Created by Wade Cosgrove on 6/6/13.
//
//

#import <Foundation/Foundation.h>
#import "CodaPlugInsController.h"

@interface ZapPlugIn : NSObject <CodaSidebarPlugIn>
{
	CodaPlugInsController *_pluginController;
	id <CodaPlugInBundle> _plugInBundle;
}

- (id)initWithPlugInController:(CodaPlugInsController*)aController plugInBundle:(id <CodaPlugInBundle>)plugInBundle;

- (NSViewController*)viewController;

@end
