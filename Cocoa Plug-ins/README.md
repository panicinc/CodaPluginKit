## Using the Cocoa plug-in API

If you can program Cocoa, you can write plug-ins that work directly and natively within Coda. They execute a bit faster, and can offer additional functionality such as opening windows or presenting a user interface.

Coda plug-ins are Cocoa bundles with a `.codaplugin` filename extension.

Coda looks for plug-ins recursively in the **Home > Library > Application Support > Coda > Plug-ins** folder. Any plug-ins found will be loaded, and one instance of the plug-in's principal class created.

If your plug-in's Info.plist contains the `CodaPlugInSupportedAPIVersion` key with a value of 7 or higher, your instance will be sent the following message:

```objective-c
- (id)initWithPlugInController:(CodaPlugInsController*)aController plugInBundle:(NSObject *)plugInBundle;
```

> Note: this may be called on a secondary thread. Please ensure this method is thread-safe.

This allows Coda to load your plug-in more quickly on versions 2.0.1 and higher.

Otherwise, it will be sent the following message (which is deprecated as of API version 6):

```objective-c
- (id)initWithPlugInController:(CodaPlugInsController*)inController bundle:(NSBundle*)yourBundle;
```

CodaPlugInsController provides the means for the plug-in to communicate with Coda itself. You must also implement the following method in your plug-in:

```objective-c
- (NSString*)name;
```

This method should simply return the desired display name of your plug-in. Keep it short, because this may be used to generate user interface elements, such as menu items.

**Please refer to CodaPluginController.h for the complete API reference.**

### Info.plist values for Coda plug-ins

To specify that your plug-in requires a certain minimum version of the Coda plug-in API, add the `CodaPlugInMinimumAPIVersion` key to your plug-in's Info.plist. The value of this key is an integer corresponding to the values returned by the `-apiVersion` method.

If you do not specify a minimum version, Coda will assume your plug-in is compliant with the API in the running version of Coda. If you call API that doesn't exist in the running version of Coda, an exception will be thrown.

This key is supported by Coda 1.6.1 and later.

The `CodaPlugInSupportedAPIVersion` key tells Coda which version of the API your plug-in is aware of. This affects which messages your plug-in will receive.

This key is recognized by Coda 2.0.1 and later. If set to 6 or higher, and you implement the API 6 init method, your plug-in will be loaded more quickly by Coda 2.0.1 and later.

