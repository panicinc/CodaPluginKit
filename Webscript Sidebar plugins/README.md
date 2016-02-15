#### What are Webscript plugins:
Webscript plugins allow web developers to create plugins using HTML and Javascript that load within Coda and are able to present a user interface with access to the current file editor. These plugins live alongside the built-in sidebar tools and give the user quick access to their funtionality. Webscript plugins are file bundles, which is simply a folder with a custom Info.plist file contained within. The Info.plist file contains important information about the plugin, such as: name, description, author, version and more.

#### Installation:
Once you have created a Webscript plugin it should be installed in: /Users/home/Library/Application Support/Coda 2/Plug-ins/
Restart Coda to load the plug-in. Once the plugin is loaded, you may reload your plugin and its source by right-clicking anywhere in its interface and choosing the "Reload" option. The Web Inspector is also available for debugging sidebar plugins, just like a web page.

#### Optional Javascript callbacks:
Implementing a function with one or more of the following signatures will cause Coda to call into the plugin when the event occurs.

- textViewWillSave(CodaTextView) -- A document is going to be saved, the document is represented by a CodaTextView
- textViewDidFocus(CodaTextView) -- A document became focused for editing
- (string) willPublishFileAtPath(string) -- Original file path input, modified file path is returned. The file at the input path is about to be published. This is an appropriate place for doing pre-processing (EG: minifying) before uploading the file to a production server.
- didLoadSiteNamed(string) -- The name of the Site being opened is passed to the plugin.

#### CodaTextView functions:
The text view represents a text document being editing in Coda and is the main interface for text manipulation.

- (string) string -- the entire document contents
- (string) path -- the path of the document if saved
- save -- saves the current document
- (bool) saveToPath(string) -- saves the document to the specified path

- insertText(string) -- inserts text into the document
- deleteSelection -- deletes the current selection
- replaceCharactersInRangeWithString(range, string) -- Replaces characters in the specified range with the replacement string

- (string) selectedText -- returns the current document selection as string
- (string) currentLine -- the string on the line being edited
- (int) currentLineNumber -- the line number of the insertion point
- (range) selectedRange -- The range of the current selection
- setSelectedRange(range) -- Modifies the selection to be range
- (string) stringWithRange(range) -- The string contained within range
- (range) rangeOfCurrentLine -- The range of the line being edited
- (range) previousWordRange -- The word before the insertion point
- (range) currentWordRange -- The word being edited

- (int) getColumn -- the column of the insertion point on the current line
- (int) getLine -- the line of the insertion point
- (int) startOfLine -- the index of the character that starts the current line
- goToLineAndColumn(int, int) -- move the insertion point to the specified line and column

- (int) encoding -- The string encoding for the document, use NSStringEncoding defined values
- (string) modeIdentifier -- The current editing syntax mode's identifier, useful for determining the current language in use
- (string) lineEnding -- the line ending string of the document
- (bool) usesTabs -- flag indicating if the document uses spaces or tabs
- (int) tabWidth -- the number of spaces in which to insert when using tabs

- beginUndoGrouping -- starts an undo group to allow for grouped edits
- endUndoGrouping -- ends an undo group to allow for grouped edits

- (string) siteURL -- the local URL for the open Site
- (string) siteLocalURL -- the open Site local URL, useful for local environment testing
- (string) siteRemotePath -- the root path of the Site on the server
- (string) siteLocalPath -- the root path for the Site on the local machine
- (string) siteNickname -- name used for the Site
- (string) remoteURL -- the remote URL for the open Site
- (string) siteUUID -- The unique identifier for the open site

#### Range type example:

```Javascript
var range= {length:10, location:1};
CodaTextView.setSelectedRange(range);
```

#### CodaPlugInsController:
The plugins controller allows plugins to communicate with Coda. The following commands are available:

- (string) codaVersion - The version of Coda hosting the plugin.
- (int) apiVersion - The plugin API version Coda is currently using.
- (CodaTextView) makeUntitledDocument - Creates a new document.
- (CodaTextView) openFileAtPath(string) -- Opens the document at path in a new tab.
- saveAll - Saves all open documents.
- displayHTMLString(string) - Renders the given HTML in a new preview tab.
- displayHTMLStringWithBaseURL(string, string) -- Renders the given HTML in a new preview tab using the base URL for any embedded links or resources.
- (int) runCommand(string, array) - Runs the command line tool at the specified path. Accepts an array of string arguments to pass to the tool.


#### CodaPlugInPreferences:
The plugin preferences interface allows plugins store and retrieve values.

- (string)preferenceForKey(string) -- Returns the previously saved value for the specified key.
- setPreferenceForKey(string, string) -- Saves the specified string for a key. The value is saved by Coda and persists accross application restarts.


#### Info.plist keys:
The Info.plist file defines metadata about the plugin and its functionality.

- CodaIconMaskFile -- a black and white mask image which is used for the sidebar icon
- CFBundleIdentifier -- the unique identifier for your plugin, usually in the form of com.companyname.plugin
- CFBundleName -- the plugin name
- CFBundleShortVersionString -- the plugin version
- CodaPlugInSupportedAPIVersion -- the Coda API version the plugin conforms to
- CodaDescriptionString -- a short description of the plugin for use on the webpage and within Coda
- CodaIconMaskTintString -- an optional hex color used to tint the icon mask in the preferences window
- CodaAuthorString -- the author or company name
