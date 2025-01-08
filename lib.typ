/// construct an eight-page zine for the current printer page size
/// 
/// Each of the zine's pages should be separated by the `pagebreak()` function.
/// This function will fail if there are not exactly seven `pagebreak()` calls
/// within the document (implying eight pages are defined).
///
/// *Note* Unfortunately, we cannot render an example since zen-zine requires
/// access to the page information to be able to deduce the size of the zine
/// pages.
///
/// -> content
#let zine(
  /// size of margin around each zine page
  /// -> length
  zine_page_margin: 0.25in,
  /// whether to draw the border of the zine pages in printer mode
  /// -> boolean
  draw_border: true,
  /// whether to be in printer mode (false) or digital (true)
  /// -> boolean
  digital: false,
  /// input content of zine
  content
) = context {
  // we need to be in context so we can get the full page's height and width
  // in order to deduce the zine page height and width
  // each of the zine pages share the margin with their neighbors
  // this height/width is without margins
  let zine_page_height = (page.width - 3*zine_page_margin)/2;
  let zine_page_width = (page.height - 5*zine_page_margin)/4;
  if digital {
    // assign half the zine margin to each digital page
    // resize pages and then provide content since it has pagebreaks already
    set page(
      height: zine_page_height+zine_page_margin/2,
      width: zine_page_width+zine_page_margin/2,
      margin: zine_page_margin/2
    )
    content
  } else {
    // make sure page has the correct margin and it is flipped
    set page(margin: zine_page_margin, flipped: true)
    // break content into the array of pages using the pagebreak
    // function and then place those pages into the grid
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
