#### Optional Javascript callbacks:

- textViewWillSave(CodaTextView)
- textViewDidFocus(CodaTextView)
- (string) willPublishFileAtPath(string) --path input, modified path return value
- didLoadSiteNamed(string) --site name input

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

```
var range= {length:10, location:1};
CodaTextView.setSelectedRange(range);
```

#### CodaPluginsController:

- (string) codaVersion
- (int) apiVersion
- (CodaTextView) makeUntitledDocument
- saveAll
- displayHTMLString(string)
- displayHTMLStringWithBaseURL(string, string) --html string and string representing URL
- (CodaTextView) openFileAtPath(string)
- (int) runCommand(string, array) - path to command line tool to execute, array of string arguments to pass 


#### CodaPlugInPreferences:

- (string)preferenceForKey(string)
- setPreferenceForKey(string, string) -- value and key pair to store in preferences
