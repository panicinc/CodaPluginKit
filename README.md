# Coda Plug-in Kit

If you've ever wished Coda could do even more than it does already, you're at the right place.

Coda 1.6 and later support Coda Plug-ins, which allow you to further extend its text editing functionality — even if you can't program Cocoa.

Plug-ins have access to the text of the current document and can perform modifications on it as desired. For example, you could write a plug-in to insert the current date and time into your document, change the case of selected text, run code through a custom validator, or even wrap code with a special tag.

Plug-ins appear in Coda's plug-in menu or sidebar when installed.

There are three ways to write a plug-in. The first way is to write a script in any common scripting language, then use the separate [Coda Plug-In Creator](http://download.panic.com/coda/Coda%20Plug-in%20Creator.zip) application to bundle your script into a Coda plug-in. The second (more complex) way is to write directly to the Cocoa Plug-In API. You may create sidebar, text, and validation plugins using Cocoa. Lastly sidebar plugins can be written using the new HTML/Scripting interface in 2.5.

Coda also allows further customization through the additional add-ons: Syntax Modes, Mode Completion Additions, and Themes. Sytax Modes allow Coda to understand and highlight languages that aren't included in the default application installation. Mode Completions extend the auto-complete system to include custom lanaguage additions for libraries and frameworks. Color Themes provide customized colors to be used for sytax higlighting source code.

If you'd like to submit a plugin to us please create an account at our [plugin site](https://panic.com/users/) and follow the instructions.
