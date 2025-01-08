#let zine(
  zine_page_margin: 8pt,
  draw_border: true,
  digital: false,
  content
) = {
  // each of the zine pages share the margin with their neighbors
  // this height/width is without margins
  let zine_page_height = (8.5in-3*zine_page_margin)/2;
  let zine_page_width = (11in-5*zine_page_margin)/4;
  if digital {
    // assign half the zine margin to each digital page
    set page(
      height: zine_page_height+zine_page_margin/2,
      width: zine_page_width+zine_page_margin/2,
      margin: zine_page_margin/2
    )
    content
  } else {
    // set printer page size (typst's page) and a zine page size (pages in the zine)
    set page("us-letter", margin: zine_page_margin, flipped: true)

    let contents = ()
    let current_content = []
    for child in content.at("children") {
      if child.func() == pagebreak {
        contents.push(current_content)
        current_content = []
      } else {
        current_content = current_content + child
      }
    }

    if current_content != [] {
      contents.push(current_content)
    }

    assert.eq(
      contents.len(), 8,
      message: "Document content does not have exactly 8 pages (7 pagebreaks)."
    )
    
    let contents = (
      // reorder the pages so the order in the grid aligns with a zine template
      contents.slice(1,5).rev()+contents.slice(5,8)+contents.slice(0,1)
    ).map(
      // wrap the contents in blocks the size of the zine pages so that we can
      // maneuver them at will
      elem => block(
        width: zine_page_width,
        height: zine_page_height,
        spacing: 0em,
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
  
    let zine_grid = grid.with(
      columns: 4 * (zine_page_width, ),
      rows: zine_page_height,
      gutter: zine_page_margin,
    )
    if draw_border {
      zine_grid = zine_grid.with(
        stroke: luma(0)
      )
    }
    zine_grid(..contents)
  }
}
