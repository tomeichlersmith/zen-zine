#let zine-page-counter = counter("zine-page")
#let zine-page(
  width: 100%,
  height: 100%,
  margin: 0.25in,
  header: none,
  header-ascent: 30% + 0pt,
  footer: none,
  footer-descent: 30% + 0pt,
  numbering: auto,
  number-align: center+bottom,
  body
) = {
  block(
    width: width,
    height: height,
  )[
    #block(inset: margin, body)
    #context { counter("zine-page").step() }

    #if number-align.y == horizon {
      error("horizon number-align is forbidden")
    } else if number-align.y == bottom {
      footer = if footer == none {
        context { align(number-align.x + top, counter("zine-page").display(numbering)) }
      } else {
        footer
      }
    } else if number-align.y == top {
      header = if header == none {
        context { align(number-align.x + bottom, counter("zin-page").display(numbering)) }
      } else {
        header
      }
    }

    #place(
      top,
      block(
        width: 100%,
        height: if type(margin) == length { margin } else { margin.at("top") },
        inset: (bottom: header-ascent),
        header
      )
    )
    #place(
      bottom,
      block(
        width: 100%,
        height: if type(margin) == length { margin } else { margin.at("top") },
        inset: (top: footer-descent),
        footer
      )
    )
  ]
}

#set page(height: 5in, width: 3in, margin: 0pt)
#zine-page(
  margin: (top: 0.5in, bottom: 0.5in, left: 0.25in, right: 0.25in),
  //footer: rect(width: 100%, height: 100%, fill: aqua.lighten(50%)),
  rect(width: 100%, height: 100%)
)

#zine-page(
  header: rect(width: 100%, height: 100%, fill: aqua),
  //footer: rect(width: 100%, height: 100%, fill: aqua.lighten(50%)),
  rect(width: 100%, height: 100%)
)
