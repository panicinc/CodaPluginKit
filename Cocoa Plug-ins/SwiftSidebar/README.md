#Swift Sidebar Coda Plugin

##Introduction
SwiftSidebar is an Coda2 Sidebar to demonstrate using Apple's Swift language to
create a sidebar.

*Note: This  project should be considered as **Experimental** as at this point 
Swift is still having problems dealing with the realities of a Plug-in Bundle.  Look
for Notes on the areas where I worked around the problems*

##Contact Information
> Bill Heaton  
  [http://winkwinknodnod.net/about](http://winkwinknodnod.net/about)  

##Development Environment

* The Coda Plugin was generated using Xcode Version 6.2 available from the
      Apple App Store: [https://itunes.apple.com/us/app/xcode/id49779983](https://itunes.apple.com/us/app/xcode/id49779983)
* The plugin uses the Coda Plugin Source code Version 7 available from
  [https://github.com/panicinc/CodaPluginKit](https://github.com/panicinc/CodaPluginKit)

## Creating A Sidebar Plugin Project

This is how I created the project in Xcode6:

* File/New/Project...
* Select OS X "Framework & Library", "Bundle" Then "Next"
* Bundle Extension = codasidebar
* Edit your Info.plist 
* Add the Coda2 Information and "Principal Class" information

> 
| Name                            | Type     |  Description            |  
| ------------------------------- | -------- | ----------------------- |  
| CodaAuthorString                | [String] | The Authors name        |  
| CodaDescriptionString           | [String] | Sidebar Description     |  
| CodaIconHighlightHexColor       | [String] | #9100FF                 |  
| CodaIconMaskFile                | [String] | Your Sidebar Icon File  |   
| CodaPlugInSupportedAPIVersion   | [Number] | 7                       |  
| Principal Class                 | [String] | YourStartingClass       |

* Create a pdf of your icon for the home view.  200px x 200px black and white image 
  for best results with the name you have in the "CodaIconMaskFile" entry.
* Create your principal class where the class name is what your set in your info.plist: 
  "File" / "File.." / "OS X" / "Source" / "Swift File" / Save as YourStartingClass
* When it asks you to create a bridging Header, Agree.
* Here's a starter for your Starting Class:

    ```        
    import Foundation    
    import Cocoa    
    
    class YourStartingClass {  
    }  
    ```  
* Here a Starter for your bridging Header:
    
    ```        
    #import "CodaPluginsController.h"
     ```        

## Swift Dynalib Workaround

Currently xcode doesn't know to copy the libswift* files to the bundle.  The workaround is
to copy the dylibs from the xcode.app directory to the our source tree and then add a copy
files phase.  

*The means that anytime you update xcode you'll need to snag a copy until
Apple fixes the problem.*

If you missing one of the librarys you'll get a: "Library not loaded: @rpath/libswiftXXXXX.dylib"
in your debug output.  

Here's a list of the ones that I added for this project:

 * @rpath/libswiftAppKit.dylib
 * @rpath/libswiftCore.dylib
 * @rpath/libswiftCoreGraphics.dylib
 * @rpath/libswiftDarwin.dylib
 * @rpath/libswiftDispatch.dylib
 * @rpath/libswiftFoundation.dylib
 * @rpath/libswiftObjectiveC.dylib 
 * @rpath/libswiftQuartzCore.dylib
 * @rpath/libswiftSecurity.dylib

### Create The Swift Dynalibs directory
 * mkdir SwiftLibs
 * cd Swiftlibs
 * Copy/Paste:

    ```        
    cp /applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx/libswift* .   
    ```        
    
### Add the Dynalibs to your project
 * Select your plugin target
 * Select "Build Phases" tab
 * Click "+" and select "New Copy Files Phase"
 * Click the "Copy Files" line
 * Set "Destinaton" to "Frameworks"
 * For each file missing; Click "+" and browse for the dylib needed in the SwiftLibs directory.

## Swift PrincipalClass Workaround
Swift will override the PrincipalClass item in info.plist using the class name found in 
the first file compiled.  You'll need to make sure that the class is always the first file 
compiled.  Here's how:

 * Select your plugin target
 * Select "Build Phases" tab
 * Click "Compile Sources" line to open it up
 * If your PrincipalClass isn't the first file compiled drag it to the top line.
 
## Debugging the Project
To Setup Debugging &mdash; [Thank-you to http://ngs.io](http://ngs.io/2012/05/25/debugging-coda-plug-in-with-lldb/)

 * Project -> Scheme -> Edit Scheme...
 * Select Run Debug from sidebar.
 * Select "Other" from the "Executable" drop down
 * Browse to your Coda2 application
 * Click "Choose" button then "Close" button
 * Select your your plug-in target.
 * Select Build Settings tab, click Add Build Setting, select Add User-Defined Setting and 
   set name as INSTALL_BUNDLE, and value as 1 for Debug configuration.
 * Switch to Build Phase tab, click Add Build Phase button and select Add Run Script, Copy
   and paste the script below:

    ```
    if [ $INSTALL_BUNDLE == 1 ]; then
      DEST="$USER_LIBRARY_DIR/Application Support/Coda 2/Plug-ins/$FULL_PRODUCT_NAME"
      ORG="$TARGET_BUILD_DIR/$FULL_PRODUCT_NAME"
      rm -rf "$DEST"
      cp -R "$ORG" "$DEST"
    fi    
    ```
*Note: Original script used "mv" which caused xcode not to create/copy the nib File
"cp" works around the problem.*
    
## License Terms
&copy;2015 by William J. Heaton &mdash; All Rights Reserved.  

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


