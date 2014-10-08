//
//  ZapPlugIn.m
//  Zap Gremlins
//
//  Created by Wade Cosgrove on 6/6/13.
//
//

#import "ZapPlugIn.h"
#import "ZapPlugInViewController.h"

@implementation ZapPlugIn


- (id)initWithPlugInController:(CodaPlugInsController*)aController plugInBundle:(id <CodaPlugInBundle>)plugInBundle
{
	self = [super init];
	
	if ( self )
	{
		_pluginController = [aController retain];
		_plugInBundle = [plugInBundle retain];
	}

	return self;
}


- (void)dealloc
{
	[_plugInBundle release];
	[_pluginController release];
	
	[super dealloc];
}


- (NSString*)name
{
	return @"Gremlins";
}


- (NSViewController*)viewController
{
	return [[[ZapPlugInViewController alloc] initWithNibName:@"ZapDialog" plugInBundle:_plugInBundle plugInController:_pluginController] autorelease];
}


@end
