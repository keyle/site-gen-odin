### Site generator

This is a static website generator, that includes support for a blog, with vanity urls, keyword tags, RSS, sitemap.xml.

Like pretty much everything made in odin, it was built to learn odin...

Note, you'll find the same repository `site-gen` written in Swift, `site-gen-rust` and `site-gen-ocaml`, ...

### How it works

it takes a .settings.json of this format...

```
{
    "workdir": "/Users/name/Documents/Code/website/public",
    "webroot": "https://website.org",
    "template": "./template/template.html",
    "templateindex": "./template/template-index.html",
    "contenttag": "{{%%content%%}}",
    "titletag": "{{%%title%%}}",
    "descriptiontag" : "{{%%description%%}}",
    "keywordstag": "{{%%keywords%%}}"
}
```

The site generator will then 

- walk recursively the `workdir` looking for `.md` (markdown) files, 
- converts them to HTML
- insert them in `template`
- replacing the `contenttag` with the HTML
- update `descriptiontag` with the contents of `<x-desc>` (custom valid HTML5 tag in the markdown)
- same with the `keywordstag` with the contents of `<x-tags>` (hidden)
- same with the `titletag` with the contents of `<x-title>`
- it will do the same with the templateindex if the markdown contains <x-index/> (as an indicator of being the index)

This custom HTML5 tag gymnastic is to avoid having metadata json files around, or breaking the valid markdown format (like Hugo does). In retrospect, I have mixed feelings about it.
  
NOTE: the content will be placed in situe. So if the website places a markdown in `/folder` it will be `/folder/index.html` so that you're in control of the whole website structure and vanity urls.
  
### Blogging
  
The blogging system works pretty much the same, except I use `<x-blog-title>` instead of `<x-title>` to tell the generator that this is a blog post. 

Blog posts will automatically have a `blog` class on the `<body>` to style the blog differently, as needed.

Additionally we parse `sub` for the RSS `pubDate` and to be sorted on the index page.

It will be included in the RSS and linked from the homepage. Note that this last part is pretty much custom to suit my own needs, but could be abstracted out further.

### Running

```
odin run .
```

Also see the `makefile` and the `.vscode/launch.json`

NOTE: I've added the `.vscode` folder on purpose this time as it's quite hard for first timers to work out how to get debugging going in VSCode properly. Hopefully this helps.

This is a WIP and isn't feature complete...

### Status

Postponed Indefinitely.

There are a few issues with this implementation. I managed the convert the markdown content to HTML but using commonmark, which excludes all table contents and does silly things such as removing existing html code in the markdown (although legal). I need a Github flavoured markdown conversion library of sorts.

I like Odin. Debugging works nicely and the compiler makes sense. I'm toroughly excited for its future.

I will revisit when some of the cruft has been cleared, and maybe when they'll have a package management system of any kind and a decent markdown implementation. If I get bored, I might write a github flavoured (GLFM) parser/converter. It could be a fun nightmare.
