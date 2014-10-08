/** This header provides protocols and facilities to implement Coda text-based,
 syntax validator and sidebar plug-in.
 Version 7
*/

#ifndef HEADER_ENVELOPE_CODA_PLUGIN
#define HEADER_ENVELOPE_CODA_PLUGIN

#import <Cocoa/Cocoa.h>

@class CodaTextView;
@protocol CodaValidator, CodaValidatorDelegate;

/** `CodaPlugInsController` is the principal way of communicating with Coda.

 You must register your available functionality with one of the methods
 implemented by the plug-in controller.

 @availability Coda 1.6 and later.
 */

@interface CodaPlugInsController : NSObject

///-------------------------
/// @name  Determining Versions
///-------------------------

/**
 The version of Coda that is hosting the plug-in.

 @return A string such as "2.5.1".
 */
- (NSString*)codaVersion;

/**
The current API version of Coda.

The versions are as follows:

Coda Version | API Version 
----- | ---
1.6   | 2 
1.6.1 | 3
1.6.3 | 4
1.6.8 | 5
2.0   | 5
2.0.1 | 6
2.5   | 7

@return 7 as of Coda 2.5.
*/
- (NSUInteger)apiVersion;


///-------------------------
/// @name  Creating Menu Items
///-------------------------

/** Registering new menu items with Coda.

Exposes to the user a plug-in action (a menu item) with the given title, that
will perform the given selector on the target.

@param title Title of the menu item.
@param target The object to send the selector message.
@param selector Action of the menu item.

*/

- (void)registerActionWithTitle:(NSString*)title target:(id)target selector:(SEL)selector;

/** Registering new menu items with Coda with advanced options.

 Allows further customization of the registered menu items, including submenu title,
 represented object, keyEquivalent and custom plug-in name.

 @see registerActionWithTitle:target:selector:

 @param title Title of the menu item.
 @param submenuTitle Parent menu to add menu item.
 @param target The object to send the selector message.
 @param selector Action of the menu item.
 @param repOb An object to be assocated with the menu item.
 @param keyEquivalent Sets the key equivalent character of the receiver to the given character. Can include modifier characters as follows: $ = shift, ~ = option, @ = cmd, ^ = ctrl
 @param aName The display name of the plug-in.

 */

- (void)registerActionWithTitle:(NSString*)title
		  underSubmenuWithTitle:(NSString*)submenuTitle
						 target:(id)target
					   selector:(SEL)selector
			  representedObject:(id)repOb
				  keyEquivalent:(NSString*)keyEquivalent
					 pluginName:(NSString*)aName;

///-------------------------
/// @name  Text Editor
///-------------------------

/** Returns the receiver's current focused text view.

 An abstract object representing the text view in Coda which currently has focus.

 @return The receiver's text view.
 */

- (CodaTextView*)focusedTextView;


///-------------------------
/// @name  Actions
///-------------------------

/**
 Displays an html formatted string in a new tab.

 @param html The html formatted string to be shown.
 */

- (void)displayHTMLString:(NSString*)html;


/**
 Create a new text document.

 Creates a new unsaved document in the frontmost Coda window and returns the text view associated with it.
 The text view provided is autoreleased; the caller should not explicitly release it.

 @return A CodaTextView object associated with the new document.

*/

- (CodaTextView*)makeUntitledDocument;


/** 
 Saves all files.

 Causes the frontmost Coda window to save all documents that have unsaved changes.
*/

- (void)saveAll;

/**
 Displays an html formatted string in a new tab.
 
 Displays an html formatted string in a new tab with a specific base URL.

 @param html The html formatted string to be shown.
 @param baseURL The base URL to be used when showing the html string.

 @availability Coda 2.0 and later.

*/

- (void)displayHTMLString:(NSString*)html baseURL:(NSURL*)baseURL;


/**
 Open a File.
 
 Opens text file at path, returning CodaTextView if successful.

 @param path The file path to open.
 @param error If non-nil, result is a filled error if an error occurred while opening the file at path.

 @return
 A CodaTextView of the resulting open file's text.

 @availability Coda 2.0 and later.

*/

- (CodaTextView*)openFileAtPath:(NSString*)path error:(NSError**)error;


///-------------------------
/// @name  Site Settings
///-------------------------


/**
 Returns the root local path of the current site.
 
 @return
 The Local path of the site in the frontmost window, may be nil if unspecified or a site is not loaded.

 @availability Coda 2.5 and later.
 */

- (NSString*)siteLocalPath;


/**
 Returns the URL of the current site.
 @return
 The URL of the site in the frontmost window, may be nil if unspecified or a site is not loaded.
 
 @availability Coda 2.5 and later.
 */

- (NSString*)siteURL;


/**
 Returns the local URL of the current site.
 @return
 The local URL of the site in the frontmost window, may be nil if unspecified or a site is not loaded.
 
 @availability Coda 2.5 and later.
 */

- (NSString*)siteLocalURL;


/**
 Returns the root remote path of the the current site.
 @return
 The root remote path of the site in the frontmost window, may be nil if unspecified or a site is not loaded.
 
 @availability Coda 2.5 and later.
 */

- (NSString*)siteRemotePath;


/**
 Returns the nickname of the current site.
 @return
 The nickname of the site in the frontmost window, may be nil if a site is not loaded.
 
 @availability Coda 2.5 and later.
 */

- (NSString*)siteNickname;


/**
 Returns the current site UUID.
 
 
 The site UUID will not change during the lifetime of the site.
 This value may be used for tracking specific preferences for the site.
 
 @return
 The UUID of the current site, may be nil if no site is loaded.
 
 @availability Coda 2.5 and later.
 */

- (NSString*)siteUUID;


@end


@class CodaPlainTextEditor;

/**
 This is an opaque object representing the text view in Coda.

 This is your hook to a text view in Coda. You can use this to provide
 manipulation of files.

*/
@interface CodaTextView : NSObject
{
	CodaPlainTextEditor* editor;
}

/**
 Inserts into the receiver the inText at the current insertion point.

 @param inText The string to insert, must be non-nil.
 */

- (void)insertText:(NSString*)inText;


/**
 Replaces the characters from aRange with those in aString.
 
 Replaces characters in the given range with the given string.

 @param aRange The range of characters to replace. aRange must not exceed the bounds of the receiver.
 @param aString The string with which to replace the characters in aRange. aString must not be nil.
 */

- (void)replaceCharactersInRange:(NSRange)aRange withString:(NSString *)aString;


/**
 @return Returns the range of selected characters.
*/

- (NSRange)selectedRange;


/**
 @return The currently selected text, or nil if none.
 */

- (NSString*)selectedText;


/**
 Selects the given character range.

 @param range The range of characters to select. range must not exceed the bounds of the receiver.
 */

- (void)setSelectedRange:(NSRange)range;

/**
 Returns a string containing the entire content of the line that the insertion point is on.
 */

- (NSString*)currentLine;


/**
 The line number corresponding to the location of the insertion point.
 */

- (NSUInteger)currentLineNumber;


/**
 Deletes the characters in the current selected range.
 */

- (void)deleteSelection;


/**
 The current line ending of the file.
 */

- (NSString*)lineEnding;


/**
 The character range of the entire line the insertion point is on.
 */

- (NSRange)rangeOfCurrentLine;


/**
 Returns the starting character index of the current line.
 
 The character index (relative to the beginning of the document) of the start of the line the insertion point is on.

 @return
 a character index.
 */

- (NSUInteger)startOfLine;


/**
 The entire document as plain text.
 */

- (NSString*)string;


/**
 Returns a substring in range of the entire text string.

 @param range The range of characters in the substring; range must not exceed the bounds of the receiver.

 @return
 The specified substring.
 */

- (NSString*)stringWithRange:(NSRange)range;


/**
 Returns the width of tabs as spaces.
 */

- (NSInteger)tabWidth;


/**
 Returns the range of the word previous to the insertion point.
 
 If there is no previous word range, it may return {NSNotFound, 0} range.
 
 @return
 The range of the previous word.
 */

- (NSRange)previousWordRange;


/**
 Returns if the editor is currently uses tabs instead of spaces for indentation.
 
 @return
 YES if is currently using tabs, NO otherwise.
 */

- (BOOL)usesTabs;


/**
 Saves the current focused document.
 */

- (void)save;

/**
 Saves the current focused document to a specific location.

 @param aPath A complete local path to save the file to.

 @return
 YES if successful, NO if not.
 */

- (BOOL)saveToPath:(NSString*)aPath;


/**
 Begins a text undo group.

 Allows for multiple text manipulations to be considered one "undo/redo" operation.
 */

- (void)beginUndoGrouping;


/**
 Ends a text undo group.

 Allows for multiple text manipulations to be considered one "undo/redo" operation.
 */

- (void)endUndoGrouping;


/**
 Returns the window the editor is located in (useful for showing sheets).
 */

- (NSWindow*)window;


/**
 The path to the text view's file.

 @return
 A file path, may be nil if the file is unsaved.
 */

- (NSString*)path;


/**
 Returns the range of the word containing the insertion point.
 
 @availability Coda 1.6.1 and later.
 */

- (NSRange)currentWordRange;


/**
 Moves insertion point to specified line and column.

Line and column must be within the bounds of the receiver.  The text view will scroll if needed.

 @param line The line to move the insertion point.

 @param column The column to move the insertion point.

 @availability Coda 2.0 and later.
 */

- (void)goToLine:(NSInteger)line column:(NSInteger)column;


/**
 Returns the text encoding of the text view.

 @availability Coda 2.0 and later.
 */

- (NSStringEncoding)encoding;


/**
 Returns the mode identifier of of the current text view syntax.

This value is the CFBundleIdentifier for a mode.  For example, the HTML mode returns "SEEMode.HTML".

 @availability Coda 2.5 and later.
 */

- (NSString*)modeIdentifier;


/**
 Returns the current line and column at the insertion point by reference.

 @param line NSInteger pointer to insert line value.

 @param column NSInteger pointer to insert the column value.

 @availability Coda 2.5 and later.
 */

- (void)getLine:(NSInteger*)line column:(NSInteger*)column;


/**
 Returns the text view file name, even if unsaved.

 @availability Coda 2.5 and later.
 */

- (NSString*)filename;


/**
 Replaces the characters from aRange with a named placeholder with the value name.
 
 @param aRange The character range to be replaced by the placeholder; aRange must not exceed the bounds of the receiver.

 @param name The name of the placeholder to insert, must contain at least one character.
 
 @availability Coda 2.5 and later.
 */

- (void)replaceCharactersInRange:(NSRange)aRange withPlaceholderNamed:(NSString*)name;


/**
 Returns the remote URL of the focused editor document based on the site remote URL.
 @return
 The remote URL, may be nil if unspecified or a site is not loaded.
 
 @availability Coda 2.0 and later.
 */

- (NSString*)remoteURL;


/**
 Sets the editors line ending string
 
 @param ending A string represending the line ending string
 
 @discussion
 Valid options are:
 U+000A (\n or LF)
 U+000D (\r or CR)
 U+2028 (Unicode line separator)
 U+2029 (Unicode paragraph separator)
 \r\n, in that order (also known as CRLF)
 
 @availability Coda 2.5 and later.
 */

- (void)setLineEnding:(NSString*)ending;


/**
 Sets the editor to use tabs instead of spaces for indentation.
 
 @param useTabs whether to use tabs instead of spaces.
 
 @availability Coda 2.5 and later.
 */

- (void)setUsesTabs:(BOOL)useTabs;


/**
 Sets the editor tab width when using spaces.
 
 @param width value of the number of spaces inserted per tab press.
 
 @availability Coda 2.5 and later.
 */

- (void)setTabWidth:(NSInteger)width;


/**
 Returns the root local path of the current site.
 
 @deprecated in 2.5, use CodaPluginsController siteLocalPath.
 
 @return
 The local path of the current site, may be nil if unspecified or a site is not loaded.
 */

- (NSString*)siteLocalPath DEPRECATED_ATTRIBUTE;


/**
 Returns the URL of the current site.
 
 @deprecated in 2.5, use CodaPluginsController siteURL.
 
 @return
 The URL of the current site, may be nil if unspecified or a site is not loaded.
 
 @availability Coda 1.6.3 and later.
 */

- (NSString*)siteURL DEPRECATED_ATTRIBUTE;


/**
 Returns the local URL of the current site.
 
 @deprecated in 2.5, use CodaPluginsController siteLocalPath.
 
 @return
 The local URL of the current site, may be nil if unspecified or a site is not loaded.
 
 @availability Coda 1.6.3 and later.
 */

- (NSString*)siteLocalURL DEPRECATED_ATTRIBUTE;


/**
 Returns the root remote path of the the current site.
 
 @deprecated in 2.5, use CodaPluginsController siteRemotePath.

 @return
 The root remote path of the current site, may be nil if unspecified or a site is not loaded.
 
 @availability Coda 1.6.3 and later.
 */

- (NSString*)siteRemotePath DEPRECATED_ATTRIBUTE;


/**
 Returns the nickname of the current site.
 
 @deprecated in 2.5, use CodaPluginsController siteNickname.
 
 @return
 The nickname of the current site, may be nil if a site is not loaded.
 
 @availability Coda 1.6.3 and later.
 */

- (NSString*)siteNickname DEPRECATED_ATTRIBUTE;


@end


/**
 An opaque object which represents the plug-in bundle.

 Similar to NSBundle, CodaPlugInBundle is an object which represents your plug-in on disk.
 @availability Coda 2.0.1 and later.
 */

@protocol CodaPlugInBundle <NSObject>

@required

/** The unique identifier for the bundle */
@property (copy, readonly) NSString *bundleIdentifier;

/** The URL of the bundle on disk */
@property (copy, readonly) NSURL *bundleURL;

/** The path of the bundle on disk */
@property (copy, readonly) NSString *bundlePath;


/** The principal class of the bundle */
@property (readonly) Class principalClass;


/** The (unlocalized) info dictionary */
@property (copy, readonly) NSDictionary *infoDictionary;

/** The localized info dictionary */
@property (copy, readonly) NSDictionary *localizedInfoDictionary;

/** Gets the (localized, when possible) value of an info dictionary key 
 
 @param key info dictionary key
 */

- (id)objectForInfoDictionaryKey:(NSString *)key;


/** The URL of the bundle's executable file */
@property (copy, readonly) NSURL *executableURL;

/** The path of the bundle's executable file */
@property (copy, readonly) NSString *executablePath;

/** An array of numbers indicating the architecture types supported by the bundle’s executable */
@property (copy, readonly) NSArray *executableArchitectures;

/** Gets the URL for an auxiliary executable in the bundle 
 
 @param executableName The filename of the executable
 */

- (NSURL *)URLForAuxiliaryExecutable:(NSString *)executableName;

/** Gets the path for an auxiliary executable in the bundle 
 
 @param executableName The filename of the executable
 */

- (NSString *)pathForAuxiliaryExecutable:(NSString *)executableName;


/** The URL of the bundle's resource directory */
@property (copy, readonly) NSURL *resourceURL;

/** The path of the bundle's resource directory */
@property (copy, readonly) NSString *resourcePath;

/** Gets the URL for a bundle resource 
 
 @param name The name of the resource
 @param extension The extension of the resource

 */

- (NSURL *)URLForResource:(NSString *)name withExtension:(NSString *)extension;

/** Gets the URL for a bundle resource located within a bundle subdirectory 
 
 @param name The name of the resource
 @param extension The extension of the resource
 @param subpath The subpath
 */

- (NSURL *)URLForResource:(NSString *)name withExtension:(NSString *)extension subdirectory:(NSString *)subpath;

/** Gets the URL for a bundle resource located within a bundle subdirectory and localization 
 
 @param name The name of the resource
 @param extension The extension of the resource
 @param subpath The subpath
 @param localizationName The localization name

 */

- (NSURL *)URLForResource:(NSString *)name withExtension:(NSString *)extension subdirectory:(NSString *)subpath localization:(NSString *)localizationName;

/** Gets the URL for a bundle resource 
 @param name The name of the resource
 @param extension The extension of the resource
*/

- (NSString *)pathForResource:(NSString *)name ofType:(NSString *)extension;

/** Gets the URL for a bundle resource located within a bundle subdirectory  
 
 @param name The name of the resource
 @param extension The extension of the resource
 @param subpath The subpath

 */

- (NSString *)pathForResource:(NSString *)name ofType:(NSString *)extension inDirectory:(NSString *)subpath;

/** Gets the URL for a bundle resource located within a bundle subdirectory and localization 
 
 @param name The name of the resource
 @param extension The extension of the resource
 @param subpath The subpath
 @param localizationName The localization name

 */

- (NSString *)pathForResource:(NSString *)name ofType:(NSString *)extension inDirectory:(NSString *)subpath forLocalization:(NSString *)localizationName;


/** A list of all the localizations contained within the receiver's bundle */
@property (copy, readonly) NSArray *localizations;

/** A list of the preferred localizations contained within the receiver's bundle */
@property (copy, readonly) NSArray *preferredLocalizations;

/** The localization used to create the bundle */
@property (copy, readonly) NSArray *developmentLocalization;

/** Gets the localized string for a given key, value and table 
 
 @param key a key
 @param value a value
 @param tableName The table name

 */

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName;

@end


/**
 CodaPlugIn
 The principal plug-in object protocol.

The plug-in's principal class must conform to this protocol to be loaded.

 @availability Coda 1.6 and later
 */

@protocol CodaPlugIn <NSObject>

@required

/**
 Gets the name of your plug-in.

@return name the human-readable name of your plug-in.
 If your plug-in has menu items, this name will be shown as the top-level menu item.
 */

- (NSString*)name;


@optional

/**
 The default initalization method for your plug-in's principal class.

 @param aController The singleton instance of the CodaPlugInsController.

 @param plugInBundle A reference to your plug-in bundle.

 @warning The initializer can (and most likely will) be called from a secondary thread. If your plugin utilizes a
 shared language bridge that requires initialization on the main thread (like PyObjC), then add the
 CodaPlugInRequiresInitOnMainThread key to your Info.plist with a value of YES.

 @availability Coda 2.0.1 and later.

 @note CodaPlugInSupportedAPIVersion and/or CodaPlugInMinimumAPIVersion info.plist key must be set to 6 or higher.

 @return a new plug-in instance.
 */

- (id)initWithPlugInController:(CodaPlugInsController*)aController plugInBundle:(id <CodaPlugInBundle>)plugInBundle;


/**

Default initalization method for your plug-in's principal class.

 @param aController The singleton instance of the CodaPlugInsController.

 @param plugInBundle A reference to your plug-in bundle.

 @note Deprecated in Coda API v6 (2.0.1) and later in favor of initWithPlugInController:pluginBundle:

 @return a new plug-in instance.

 */

- (id)initWithPlugInController:(CodaPlugInsController*)aController bundle:(NSBundle*)plugInBundle DEPRECATED_ATTRIBUTE;


/**
 A callback to be notified when the text view will save.

This method will be called before a text view's contents will be saved to disk.
 This allows processing of the text at save time.

 @param textView The text view which is in the process of being saved to disk.
 */

- (void)textViewWillSave:(CodaTextView*)textView;


/**
 A callback to be notified when the text view did save.
 
 This method will be called after a text view's contents are saved to disk.
 This allows processing of the text after save time.
 
 @param textView The text view whose contents where saved to disk.
 */

- (void)textViewDidSave:(CodaTextView*)textView;


/**
 A callback when a text view is focused/opened.

 @param textView The text view which now focused.

 @warning This method is time sensitive and should return quickly.
 */

- (void)textViewDidFocus:(CodaTextView*)textView;


/**
 A callback when a file at a specific path will be published.

This callback allows the plug-in a chance to modify files
 just before publishing.  The result is the new path to the actual file to publish.
 This is useful for minifying or otherwise processing files before uploading them to a server.

 @important This method will be called on a non-main thread.

 @param inputPath The file path which is being saved.

 @warning This method is time sensitive and should return quickly.

 @return The file path in which to publish in place of the original file.
 */

- (NSString*)willPublishFileAtPath:(NSString*)inputPath;


/**
 A callback when a site is loaded

This callback allows a plug-in to be notified when a site is loaded.
 Name may be nil if a site has just been unloaded.

 @param name The name of the site which was opened, may be nil.

 @availability Coda 2.5 and later.

 */

- (void)didLoadSiteNamed:(NSString*)name;


@end


/**
 @const CodaPluginKeyLoopDidChangeNotification
 Notify Coda when the user interface of the plug-in changes.

Post this notification if the top/bottom most views in the plugin user interface change,
 so tabbing through the UI will traverse through the plugin correctly.
 */
static NSString* const CodaPluginKeyLoopDidChangeNotification =	@"CodaPluginKeyLoopDidChangeNotification";

/**
 @const CodaPluginErrorDomain
 Domain for generating errors from plug-ins.
 */

static NSString* const CodaPluginErrorDomain =	@"CodaPluginErrorDomain";


/**
 CodaSidebarViewController
 Protocol for Sidebar Plug-in View Controllers.

 A protocol the plug-in view controller must implement to be a sidebar plug-in.
 
 @availability Coda 2.5 and later.
 */

@protocol CodaSidebarViewController <NSObject>

@optional

/**
 A callback when the plug-in should unload the sidebar view.

 A sidebar should do whatever clean up is necessary when this method is called.
 */

- (void)unloadView;

@end


/**
 CodaSidebarPlugIn
 Protocol for Sidebar Plug-in.

 A protocol the principal plug-in class must implement to be a sidebar plug-in.
 
 @availability Coda 2.5 and later.
 */

@protocol CodaSidebarPlugIn <CodaPlugIn>

@required

/**
 Return a new sidebar view controller.

 Return a new autoreleased view controller to be inserted into the sidebar, will be called once per window.

 @return A view controller which conforms to the CodaSidebarViewController protocol.
 */

- (NSViewController <CodaSidebarViewController> *)viewController;

@optional

@end

/**
 
 */
@interface CodaSidebarButton : NSButton
@end

/**
 
 */
@interface CodaSidebarButtonCell : NSButtonCell
@end

/**
 
 */
@interface CodaSidebarBox : NSView
@end

/**
 @const kValidatorMessageStringKey
 The key in a validator result dictionary whose value is a human-readable message string.
 
 @availability Coda 2.5 and later.

 */

static NSString* const kValidatorMessageStringKey = @"ValidatorMessage";

/**
 @const kValidatorExplanationStringKey
 The key in a validator result dictionary whose value is a human-readable explanation string.

 @availability Coda 2.5 and later.

 */

static NSString* const kValidatorExplanationStringKey = @"ValidatorExplanation";

/**
 @const kValidatorLineKey
 The key in a validator result dictionary whose value is a line number.
 
 @availability Coda 2.5 and later.

 */

static NSString* const kValidatorLineKey = @"ValidatorLine";

/**
 @const kValidatorColumnKey
 The key in a validator result dictionary whose value is a column number.

 @availability Coda 2.5 and later.

 */

static NSString* const kValidatorColumnKey = @"ValidatorColumn";

/**
 @const kValidatorErrorTypeKey
 The key in a validator result dictionary whose value is a ValidatorType string.
 @see kValidatorErrorTypeKey
 @see kValidatorTypeError
 
 @availability Coda 2.5 and later.

 */

static NSString* const kValidatorErrorTypeKey = @"ValidatorErrorType";

/**
 @const kValidatorTypeWarning
 A type of validator result.

 Validator warning type for use with the key kValidatorErrorTypeKey.
 @see kValidatorErrorTypeKey
 
 @availability Coda 2.5 and later.

 */

static NSString* const kValidatorTypeWarning = @"Warning";

/**
 @const kValidatorTypeError
 A type of validator result.

 Validator error type for use with the key kValidatorErrorTypeKey.
 @see kValidatorErrorTypeKey
 
 @availability Coda 2.5 and later.

 */

static NSString* const kValidatorTypeError = @"Error";



/**
 @protocol CodaValidatorPlugIn
 Protocol for a syntax validator host plug-in.

 A protocol the validator host plug-in object must implement to be used as a Coda validator.
 
 @availability Coda 2.5 and later.
 */

@protocol CodaValidatorPlugIn <CodaPlugIn>

@required

/**
 Returns an array of Syntax Mode identifiers the validator plug-in supports.
 */

- (NSArray*)supportedModeIdentifiers;

/**
 Returns a new validator object.

 Return a new autoreleased object which conforms to the CodaValidator protocol to be used for validating the provided text.

 @param modeIdentifier The mode to be validated.

 @param text The string to be validated.

 @param encoding The text string encoding.

 @param aDelegate An object which conforms to the CodaValidatorDelegate protocol to message when validation is complete.

 @return a new autoreleased validator object.

 */

- (id<CodaValidator>)validatorForModeIdentifier:(NSString*)modeIdentifier text:(NSString*)text encoding:(NSStringEncoding)encoding delegate:(id<CodaValidatorDelegate>)aDelegate;

@end



/**
 CodaValidator
 Protocol for a Coda syntax validator.

 A validator object must conform to this protocol to be used as a syntax validator.
 
 @warning A validator object must be designed to be run on multiple threads synchronously.
 
 @availability Coda 2.5 and later.

 */

@protocol CodaValidator <NSObject>

@required


/**
 Starts validation.

This is the primary validation method, it will be called on a secondary thread.
 */

- (void)validate;


/**
 Cancels validation.

The validator should end validation and do whatever clean-up is necessary.
 */

- (void)cancel;


/**
 Returns a human-readable name of the syntax being validated.
 */

- (NSString*)name;


/**
 Sets the validator delegate.
 @param delegate Opaque object which conforms to the CodaValidatorDelegate protocol, may be nil.
 */

- (void)setDelegate:(id<CodaValidatorDelegate>)delegate;


/**
 Return the validator delegate object.
 */

- (id<CodaValidatorDelegate>)delegate;

@end


/**
 CodaValidatorDelegate
 An object to message when validation is complete.

 An opaque object which conforms to the validator delegate protocol is set on your validator plug-in using setDelegate and is what your plug-in messages when validation is complete.
 
 @availability Coda 2.5 and later.

 */

@protocol CodaValidatorDelegate <NSObject>

/**
 Informs the validator delegate syntax validation is complete.

 This callback is the way Coda knows text validation is complete.
 The results are an NSArray of NSDicationaries with kValidator keyed objects.

 @param validator The validator which completed validation.

 @param results An array of NSDicationary objects containing error information.

 @param error If an unknown error occurred during validation, return it to the delegate.
 */

- (void)validator:(id<CodaValidator>)validator didComplete:(NSArray*)results error:(NSError*)error;

@end

#endif