/**
 * SwithSidebar.swift - Principal Class for Swift Sidebar
 *
 * (c) 2015 by William J. Heaton, LLC - All Rights Reserved.
 * See license terms in README.md
 */

import Foundation
import Cocoa

/**
 * Swift Sidebar
 *
 * This class provides the principal interface that Coda 2 uses to communicate with the our
 * plugin.  The name of the class should match the NSPrincipalClass item in info.plist or 
 * you'll get an obnoxious error message that diffcult to trace down.
 */
@objc class SwiftSidebar : NSObject, CodaSidebarPlugIn, CodaPlugIn  {

    /// The plugin controller pointer we received so that we can talk to Coda.
    var plugInController:AnyObject! = nil

    /// The Plugin Bundle pointer we received so that we can access our bundle.
    var plugInBundle:CodaPlugInBundle! = nil

    /**
     *  The equivalent of "- (NSString*)name;" A Required function to return 
     *  the name of the plugin.
     *
     *  :returns: String with our name
     */
    func name() -> String    {
        return "Swift Sidebar"
    }

    /**
     *  The equivalent of "-(id)initWithPlugInController:(CodaPlugInsController*)aController"
     *  plugInBundle:(id <CodaPlugInBundle>)plugInBundle;The default initalization method for
     *  your plug-in's principal class.
     *
     *  :param: plugInController    A pointer to the plugin controller
     *  :param: plugInBundle        A pointer the bundle we were loaded from
     */
    required init(plugInController:CodaPlugInsController!, plugInBundle:CodaPlugInBundle!)
    {
        self.plugInController = plugInController;
        self.plugInBundle = plugInBundle;
        super.init()
    }

   /// Workaround Swift wanting this init
   required init(plugInController: CodaPlugInsController!, bundle: NSBundle!)
    {
        fatalError("Sorry, The Swift Plugin requires Coda 2.0.1 or later.")
    }

    /**
     * Return a new sidebar view controller for our sidebar.  Return a new autoreleased view
     * controller to be inserted into the sidebar, will be called once per window.
     *
     * :returns: A view controller which conforms to the CodaSidebarViewController protocol.
     */
    func viewController() -> NSViewController! {
        return SwiftSidebarView(nibName:"SwiftSidebarView",
            plugInController:self.plugInController,
            plugInBundle:self.plugInBundle )
    }
}