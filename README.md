# zen-zine
Excellently type-set a cute little zine about your favorite topic!

Providing your eight pages in order will produce a printer page with
the content in a layout ready to be folded into a zine! The content is
wrapped before movement so that padding and alignment are respected.

Here is the template and its preview:

```typst
#import "@preview/zen-zine:0.2.0": zine

#set document(author: "Tom", title: "Zen Zine Example")
#set text(font: "Libertinus Serif", lang: "en")

// this page size is what the printer page size is
// if building a digitial zine, the page will be re-set
// so that the PDF pages align with the zine page size
// and not the printer page size
#set page("us-letter")

// update heading rule to show that style is preserved
#show heading.where(level: 1): hd => {
  pad(top: 2em, text(10em, align(center, hd.body)))
}

#show: zine.with(
  // whether to make output PDF pages align with zine pages (true)
  // or have the zine pages located onto a printer page (false)
  // with this code, you can provide which kind you want on the command line
  //   typst compile input.typ output.pdf --input digital=(true|false)
  digital: json.decode(sys.inputs.at("digital", default: "false")),
  // zine-page-margin: 0.25in // margin of zine pages
  // draw-border: true // draw border boxes in printing mode
)

// provide your content pages in order and they
// are placed into the zine template positions.
// the content is wrapped before movement so that
// padding and alignment are respected.

= 1

#pagebreak()

= 2

#pagebreak()

== 3
#lorem(50)

#pagebreak()

== 4

#pagebreak()

= 5
#v(1fr)
five

#pagebreak()

six

#pagebreak()

= 7
seven

#pagebreak()

$ 8 $

```

![Image of Template](template/preview.png)

## Development
Using [just](https://just.systems/man/en/) and [showman](https://github.com/ntjess/showman/tree/main) to help aid development.

After installing `just`, the additional initialization recipes are in the justfile.
```
just init-showman # create a python3 venv and install showman for packaging
just install # symlink local clone to local package area for testing
```
