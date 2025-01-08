#import "@preview/zen-zine:0.2.0": zine

#set document(author: "Tom", title: "Zen Zine Example")
#set text(font: "Libertinus Serif", lang: "en")

// update heading rule to show that style is preserved
#show heading.where(level: 1): hd => {
  pad(top: 2em, text(10em, align(center, hd.body)))
}

#show: zine.with(
  // digital: true // output PDF pages are the zine pages
  // zine_page_margin: 0.25in // margin of zine pages
  // draw_border: true // draw border boxes in printing mode
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

