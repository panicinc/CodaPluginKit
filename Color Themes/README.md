In Coda 2 syntax highlighting is done with a combination of a syntax mode and a color theme.

Justin Hileman wrote [an article](http://justinhileman.info/article/coda-2-modes-scopes-and-you/) describing a bit how syntax highlighting interacts with modes.

The format for the color themes is *very* similar to CSS in how to attach text attributes to scopes. Some things to consider about the theme are:

* Scope matching is done using simple prefix matching. E.g.: if a style is defined in a theme, then `style.value.numeric` will use this style unless a more specific scope (e.g. `style.value`) is defined
* If a Style does not specify all attributes, it inherits from the next less specific style. In the end all Styles inherit from meta.default
* Themes should represent a complete color scheme, providing at least all high level scopes

We're including a sample color theme to get you started.

### Scopes
* `meta.coda` - Info about the theme
* `meta.default` - Default fallback scope. All scopes fall back on the defaults of this scope. The meta.default scope of the top-level Language Context also defines the base background and foreground color of the document.
* `meta.block.interpolation`
* `meta.highlight.currentline` - Style information that can be used to highlight the current line
* `meta.important`
* `meta.invalid`
* `meta.invalid.ampersand`
* `meta.invalid.sgmlcomment`	
* `meta.invisible.character` - Style for inivisble characters if shown (currently only the foreground color is used)
* `meta.link`
* `meta.link.email`
* `meta.folding`
* `meta.invalid`

---

* `comment`
* `comment.block`
* `comment.block.documentation`
* `comment.block.documentation.tags`
* `comment.line`

---

* `constant`
* `constant.numeric`
* `constant.numeric.character`
* `constant.numeric.keyword`

---

* `keyword`
* `keyword.class`	
* `keyword.control`	
* `keyword.directive`	
* `keyword.function`	
* `keyword.type`	

---

* `language`
* `language.function`
* `language.variable`
* `language.variable.instance`
* `language.variable.class`
* `language.variable.global.builtin`
* `language.variable.string`

---

* `markup.comment`	
* `markup.constant.entity`
* `markup.declaration`	
* `markup.declaration.string.double`	
* `markup.declaration.string.single`	
* `markup.inline.cdata`	
* `markup.processing`	
* `markup.processing.attribute.value.string`	
* `markup.processing.languageswitch`	
* `markup.tag`	
* `markup.tag.attribute.name`	
* `markup.tag.attribute.value`	
* `markup.tag.attribute.value.string`	

---

* `string`
* `string.double`	
* `string.double.nsstring`
* `string.exec`	
* `string.single`	
* `string.here-doc`	
* `string.here-doc.indented`	
* `string.regex`	
* `string.symbol`	

---

* `style.at-rule`	
* `style.comment`	
* `style.comment.block`	
* `style.comment.block.documentation`	
* `style.property.name`	
* `style.value`	
* `style.value.color.rgb-value`	
* `style.value.keyword`	
* `style.value.numeric`	
* `style.value.string`	
* `style.value.string.double`	
* `style.value.string.single`	

---

* `support`
* `support.accessor`
* `support.class.standard`
* `support.function`
* `support.method.special`
