/**
* SwiftViewController.swift - Interface to the sidebar view
*
* (c) 2015 by William J. Heaton - All Rights Reserved.
* See license terms in README.md
*/

import Foundation
import Cocoa

/**
 * Swift Sidebar View
 *
 * This is the view controller for out sidebar. We load our nib from the bundle that passed to use.
 *
 */

class SwiftSidebarView: NSViewController, CodaSidebarViewController {

    /// The plugin controller pointer we received so that we can talk to Coda.
    var plugInController:AnyObject! = nil

    /// Label for Coda Version
    @IBOutlet weak var labelVersion: NSTextField!

   /**
    * This is the equvalence of: "- (id)initWithNibName:(NSString*)nibName
    *                                   plugInBundle:(id <CodaPlugInBundle>)plugInBundle
    *                                   plugInController:(CodaPlugInsController*)aController
    *
    *  :param: plugInController    A pointer to the plugin controller
    *  :param: plugInBundle        A pointer the bundle we were loaded from
    */
    required init?( nibName: String, plugInController:AnyObject!, plugInBundle:AnyObject! )
    {
        self.plugInController = plugInController
        super.init( nibName: nibName, bundle: plugInBundle as? NSBundle)
    }

    /// Workaround for Swift wanting this init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   /**
    * Action Routine for the Button. Proves that we can hear button pushes and that we 
    * can effect view elements.  A side effect is that we prove that we can call the Coda API
    *
    * :param: sender    The ID of the sending button
    */
    @IBAction func actioniButton(sender: AnyObject) {
        labelVersion.stringValue = "Coda Version " + self.plugInController.codaVersion()
    }

}