#let zine-page(
  width: 100%,
  height: 100%,
  margin: ("bottom": 0.5in, "rest": 0.25in),
  header: none,
  header-ascent: 30% + 0pt,
  footer: none,
  footer-descent: 30% + 0pt,
  page-number: none,
  numbering: "1",
  number-align: center+bottom,
  body
) = {
  let numbering = if numbering == auto {
    "1"
  } else {
    numbering
  }
  block(
    width: width,
    height: height,
  )[
    #block(inset: margin, body)

    #if numbering != none {
      if number-align.y == horizon {
        error("horizon number-align is forbidden")
      } else if number-align.y == bottom {
        footer = if footer == none {
          align(number-align.x + top, std.numbering(numbering, page-number))
        } else {
          footer
        }
      } else if number-align.y == top {
        header = if header == none {
          align(number-align.x + bottom, std.numbering(numbering, page-number))
        } else {
          header
        }
      }
    }

    #place(
      top,
      block(
        width: 100%,
        height: if type(margin) == length { margin } else { margin.at("top", default: margin.at("rest")) },
        inset: (bottom: header-ascent),
        header
      )
    )
    #place(
      bottom,
      block(
        width: 100%,
        height: if type(margin) == length { margin } else { margin.at("bottom", default: margin.at("rest")) },
        inset: (top: footer-descent),
        footer
      )
    )
  ]
}

#set page(flipped: true, margin: 0pt)

#context {
  let contents = range(8).map(
    i => block(
      height: 100%,
      width: 100%,
      fill: gray,
      align(center+top, text(size: 18pt, fill: aqua)[#i])
    ) 
  ).enumerate().map(
    // wrap the contents in blocks the size of the zine pages so that we can
    // maneuver them at will
    ((i, elem)) => zine-page(
      height: page.width/2,
      width: page.height/4,
      page-number: i+1,
      elem
    )
  )

  let contents = (
    // reorder the pages so the order in the grid aligns with a zine template
    contents.slice(1,5).rev()+contents.slice(5,8)+contents.slice(0,1)
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
