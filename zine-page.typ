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

#set page(flipped: true, margin: 0pt)

#context {
  let contents = range(8).map(
    i => align(center+top, text(size: 18pt, fill: aqua)[#i])
  )

  let contents = (
    // reorder the pages so the order in the grid aligns with a zine template
    contents.slice(1,5).rev()+contents.slice(5,8)+contents.slice(0,1)
  ).map(
    // wrap the contents in blocks the size of the zine pages so that we can
    // maneuver them at will
    elem => zine-page(
      height: page.width/2,
      width: page.height/4,
      elem
    )
  ).enumerate().map(
    // flip if on top row
    elem => {
      if elem.at(0) < 4 {
        rotate(
          180deg,
          origin: center,
          elem.at(1)
        )
      } else {
        elem.at(1)
      }
    }
  )
  
  let zine-grid = grid.with(
    columns: 4 * (auto, ),
    stroke: black
  )
  zine-grid(..contents)
}
