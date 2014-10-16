In Coda 2 syntax highlighting is done with a combination of a syntax mode and a color theme.

Justin Hileman wrote [an article](http://justinhileman.info/article/coda-2-modes-scopes-and-you/) describing a bit how syntax highlighting interacts with modes.

The format for the color themes is *very* similar to CSS in how to attach text attributes to scopes. Some things to consider about the theme are

* Scope matching is done using simple prefix matching. E.g.: if a style is defined in a theme, then `style.value.numeric` will use this style unless a more specific scope (e.g. `style.value`) is defined
* If a Style does not specify all attributes, it inherits from the next less specific style. In the end all Styles inherit from meta.default
* Themes should represent a complete color scheme, providing at least all high level scopes

We're including a sample color theme to get you started.

### Scopes
* `meta.default` - Default fallback scope. All scopes fallback on the defaults of this scope. The meta.default scope of the top-level Language Context also defines the base background and foreground color of the document.
* `meta.block.interpolation`
* `meta.highlight.currentline` - style information that can be used to highlight the current line
* `meta.invisible.character` - Style for inivisble characters if shown (currently only the foreground color is used)
* `meta.link`
* `meta.link.email`
* `meta.folding`
* `meta.invalid`

---

* `comment`
* `comment.line`
* `comment.block`
* `comment.block.documentation`
* `comment.block.documentation.tags`

---

* `keyword`
* `keyword.function`	
* `keyword.class`	
* `keyword.control`	
* `keyword.type`	
* `keyword.directive`	

---

* `language`
* `language.function`
* `language.variable`
* `language.variable.instance`
* `language.variable.class`
* `language.variable.global.builtin`

---

* `constant`
* `constant.numeric`
* `constant.numeric.character`
* `constant.numeric.keyword`

---

* `string`
* `string.single`	
* `string.double`	
* `string.here-doc`	
* `string.here-doc.indented`	
* `string.regex`	
* `string.exec`	
* `string.symbol`	
* `string.here-doc`	
* `string.double.nsstring`

---

* `support`
* `support.accessor`
* `support.function`
* `support.method.special`
* `support.class.standard`

---

* `meta.important`	
* `style.comment`	
* `style.comment.block`	
* `style.comment.block.documentation`	
* `style.property.name`	
* `style.value`	
* `style.value.string`	
* `style.value.string.single`	
* `style.value.string.double`	
* `style.value.color.rgb-value`	
* `style.value.numeric`	
* `style.value.keyword`	
* `style.at-rule`	

---

* `markup.constant.entity`

---

* `meta.invalid`	
* `meta.invalid.sgmlcomment`	
* `meta.invalid.ampersand`

---

* `markup.comment`	
* `markup.inline.cdata`	
* `markup.processing`	
* `markup.processing.languageswitch`	
* `markup.tag`	
* `markup.tag.attribute.name`	
* `markup.tag.attribute.value`	
* `markup.tag.attribute.value.string`	
* `markup.declaration`	
* `markup.declaration.string.double`	
* `markup.declaration.string.single`	
* `markup.processing.attribute.value.string`	
