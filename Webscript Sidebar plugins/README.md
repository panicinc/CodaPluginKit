#### What are Webscript plugins:
Webscript plugins allow web developers to create plugins using HTML and Javascript that load within Coda and are able to present a user interface with access to the current file editor. These plugins live alongside the built-in sidebar tools and give the user quick access to their funtionality. Webscript plugins are file bundles, which is simply a folder with a custom Info.plist file contained within. The Info.plist file contains important information about the plugin, such as: name, description, author, version and more.

#### Installation:
Once you have created a Webscript plugin it should be installed in: /Users/home/Library/Application Support/Coda 2/Plug-ins/
Restart Coda to load the plug-in. Once the plugin is loaded, you may reload your plugin and its source by right-clicking anywhere in its interface and choosing the "Reload" option. The Web Inspector is also available for debugging sidebar plugins, just like a web page.

#### Optional Javascript callbacks:
Implementing a function with one or more of the following signatures will cause Coda to call into the plugin when the event occurs.

- textViewWillSave(CodaTextView) <br>*a document is going to be saved, the document is represented by a CodaTextView*
- textViewDidFocus(CodaTextView) <br>*a document became focused for editing*
- (string) willPublishFileAtPath(string) <br>*original file path input, modified file path is returned. The file at the input path is about to be published. This is an appropriate place for doing pre-processing (EG: minifying) before uploading the file to a production server.*
- didLoadSiteNamed(string) <br>*site name input. A site with the passed-in name was just opened.*

#### CodaTextView functions:

- insertText(string)
- (string) selectedText
- (string) currentLine
- (int) currentLineNumber
- deleteSelection
- (string) lineEnding
- (int) startOfLine
- (string) string
- (bool) usesTabs
- (int) tabWidth
- save
- (bool) saveToPath(string) --path
- beginUndoGrouping
- endUndoGrouping
- (string) path
- (string) siteURL
- (string) siteLocalURL
- (string) siteRemotePath
- (string) siteLocalPath
- (string) siteNickname
- goToLineAndColumn(int, int)
- (string) remoteURL
- (int) getColumn
- (int) getLine
- (int) encoding -- NSStringEncoding
- (string) modeIdentifier
- (range) selectedRange
- replaceCharactersInRangeWithString(range, string)
- setSelectedRange(range)
- (range) rangeOfCurrentLine
- (string) stringWithRange(range)
- (range) previousWordRange
- (range) currentWordRange
- (string) siteUUID

#### Range type example:

```Javascript
var range= {length:10, location:1};
CodaTextView.setSelectedRange(range);
```

#### CodaPlugInsController:

- (string) codaVersion
- (int) apiVersion
- (CodaTextView) makeUntitledDocument
- saveAll
- displayHTMLString(string)
- displayHTMLStringWithBaseURL(string, string) -- html string and string representing URL
- (CodaTextView) openFileAtPath(string)
- (int) runCommand(string, array) - path to command line tool to execute, array of string arguments to pass 


#### CodaPlugInPreferences:

- (string)preferenceForKey(string)
- setPreferenceForKey(string, string) -- value and key pair to store in preferences


#### Info.plist keys:

- CodaIconMaskFile -- a black and white mask which is used for the sidebar icon.
- CFBundleIdentifier -- a unique identifier for your plugin, usually in the form of com.companyname.plugin
- CFBundleName -- the plugin name
- CFBundleShortVersionString -- the plugin version
- CodaPlugInSupportedAPIVersion -- the Coda API version the plugin conforms to
- CodaDescriptionString -- a short description of the plugin for use on the webpage and within Coda
- CodaIconMaskTintString -- an optional hex color used to tint the icon mask in the preferences window
- CodaAuthorString -- the author or company name
