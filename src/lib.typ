/// the base container for a single page in the final (folded or digital) zine
///
/// This is an attempt to replicate the behavior of a `page` container including
/// allowing the user to define the height, width, margins, header, footer, and
/// page numbering. The one caveat to this replication is that since the zine-pages
/// in a printer zine are rendered in their grid order (and not their final folded
/// order), we need to manually specify the page number for a zine page.
///
/// -> content
#let zine-page(
  /// width of a page in the zine
  /// -> length
  width: 100%,
  /// height of a page in the zine
  /// -> length
  height: 100%,
  /// margin of each page in the zine
  ///
  /// Since 0.25in is a common minimum margin for printers,
  /// this is a reasonable default. The "bottom" margin is
  /// increased to make room for the page number.
  ///
  /// -> length
  margin: ("bottom": 0.5in, "rest": 0.25in),
  /// content to put on the header of each page
  ///
  /// overrides the page numbers. Pass a function
  /// to `numbering` and use `number-align: top`
  /// if you wish to style the page numbers in
  /// the header in a custom way.
  ///
  /// -> content
  header: none,
  /// distance between top of page and bottom of header content
  /// -> length
  header-ascent: 30% + 0pt,
  /// content to put on the footer of each page
  ///
  /// overrides the page numbers. Pass a function
  /// to `numbering` and use `number-align: bottom`
  /// if you wish to style the page numbers in
  /// the footer in a custom way.
  ///
  /// -> content
  footer: none,
  /// distance between bottom of page and top of footer content
  /// -> length
  footer-descent: 30% + 0pt,
  /// number for this zine-page
  ///
  /// if none, then the page number is not rendered
  /// -> int
  page-number: none,
  /// how the page numbers should be displayed
  ///
  /// Passed into the Typst `numbering` function.
  /// -> str, function
  numbering: "1",
  /// how to align the page numbers relative to the page
  /// -> align
  number-align: center+bottom,
  /// content to put into page
  /// -> content
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

/// construct an eight-page zine for the current printer page size
/// 
/// The size of the zine pages are deduced from the current page size.
/// The current page defines the size of the page that the zine would be
/// printed on.
///
/// The zine's pages are provided in the order that they should be read,
/// separated by `pagebreak()`s. They are wrapped and then moved into position
/// so that any zine-page-internal layout is preserved.
///
/// === #text(red.darken(25%), underline[Failure Mode])
/// #text(red.darken(25%), [This function will fail if there are not exactly seven `pagebreak()` calls
/// within the document (implying eight pages are defined).])
///
/// Unfortunately, we cannot render an example since zen-zine requires
/// access to the page information to be able to deduce the size of the zine
/// pages.
///
/// -> content
#let zine(
  /// whether to draw the border of the zine pages in printer mode
  /// 
  /// This border is sometimes helpful for seeing the placement of
  /// content on the final printer-ready page.
  /// -> boolean
  draw-border: true,
  /// whether to be in printer mode (false) or digital (true)
  ///
  /// When creating a digital zine, the margin specified with `zine-page-margin`
  /// is divided by two so that the digital visually looks like the printed
  /// zine with the pages cut out.
  /// -> boolean
  digital: false,
  /// other named arguments are given to zine-page
  ..zine-page-kwargs,
  /// input content of zine
  /// -> content
  content
) = context {

  // break content into the array of pages using the pagebreak
  // function and then place those pages into the grid
  let contents = ()
  let current-content = []
  for child in content.at("children") {
    if child.func() == pagebreak {
      contents.push(current-content)
      current-content = []
    } else {
      current-content = current-content + child
    }
  }

  if current-content != [] {
    contents.push(current-content)
  }

  assert.eq(
    contents.len(), 8,
    message: "Document content does not have exactly 8 pages (7 pagebreaks)."
  )

  // we need to be in context so we can get the full page's height and width
  // in order to deduce the zine page height and width
  // each of the zine pages share the margin with their neighbors
  // this height/width is without margins
  let zine-page-height = page.width/2;
  let zine-page-width = page.height/4;

  // wrap pages in zine-page
  let contents = contents.enumerate().map(
    ((i, content))=> zine-page(
      height: zine-page-height,
      width: zine-page-width,
      page-number: i+1,
      ..zine-page-kwargs,
      content
    )
  )

  // zine-page is handling the margin, so the parent page should have zero margin
  set page(margin: 0pt)
  if digital {
    // resize output page to be same size as zine-page
    set page(height: zine-page-height, width: zine-page-width)
    for zpage in contents {
      zpage
    }
  } else {
    // make sure page is flipped
    set page(flipped: true)
    
    // re-order and place onto printer page
    let contents = (
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
      columns: 4 * (zine-page-width, ),
      rows: zine-page-height,
    )
    if draw-border {
      zine-grid = zine-grid.with(
        stroke: luma(0)
      )
    }
    zine-grid(..contents)
  }
}


/// construct zine booklet for the current printer page size
/// 
/// The size of the zine pages are deduced from the current page size.
/// The current page defines the size of the page that the zine would be
/// printed on.
///
/// The zine's pages are provided in the order that they should be read,
/// separated by `pagebreak()`s. They are wrapped and then moved into position
/// so that any zine-page-internal layout is preserved.
///
/// Unfortunately, we cannot render an example since zen-zine requires
/// access to the page information to be able to deduce the size of the zine
/// pages.
///
/// -> content
#let zine2(
  /// size of margin around each zine page
  ///
  /// The default value of 0.25in is chosen because that is a pretty
  /// common minimum margin for printers. You could freely shrink this
  /// margin however the printer may clip the outer edges of the zine
  /// pages.
  ///
  /// The inner margins are _shared_ between pages so this is also
  /// the inner distance between any two zine pages.
  /// -> length
  zine-page-margin: 0.25in,
  /// whether to draw the border of the zine pages in printer mode
  /// 
  /// This border is sometimes helpful for seeing the placement of
  /// content on the final printer-ready page.
  /// -> boolean
  draw-border: true,
  /// whether to be in printer mode (false) or digital (true)
  ///
  /// When creating a digital zine, the margin specified with `zine-page-margin`
  /// is divided by two so that the digital visually looks like the printed
  /// zine with the pages cut out.
  /// -> boolean
  digital: false,
  /// input content of zine
  /// -> content
  content
) = context {
  // we need to be in context so we can get the full page's height and width
  // in order to deduce the zine page height and width
  // each of the zine pages share the margin with their neighbors
  // this height/width is without margins
  let zine-page-height = (page.width - 2*zine-page-margin);
  let zine-page-width = (page.height - 3*zine-page-margin)/2;
  if digital {
    // assign half the zine margin to each digital page
    // resize pages and then provide content since it has pagebreaks already
    set page(
      height: zine-page-height+zine-page-margin/2,
      width: zine-page-width+zine-page-margin/2,
      margin: zine-page-margin/2
    )
    content
  } else {
    // make sure page has the correct margin and it is flipped
    set page(margin: zine-page-margin, flipped: true)
    // break content into the array of pages using the pagebreak
    // function and then place those pages into the grid
    let contents = ()
    let current-content = []
    for child in content.at("children") {
      if child.func() == pagebreak {
        contents.push(current-content)
        current-content = []
      } else {
        current-content = current-content + child
      }
    }

    if current-content != [] {
      contents.push(current-content)
    }
    
    let contents = contents.map(
      // wrap the contents in blocks the size of the zine pages so that we can
      // maneuver them at will
      elem => block(
        width: zine-page-width,
        height: zine-page-height,
        spacing: 0em,
        elem
      )
    )
  
    let zine-grid = grid.with(
      columns: 2 * (zine-page-width, ),
      rows: zine-page-height,
      gutter: zine-page-margin,
    )
    if draw-border {
      zine-grid = zine-grid.with(
        stroke: luma(0)
      )
    }
    zine-grid(..contents)
  }
}


/// construct 16-page zine for the current printer page size
/// 
/// The size of the zine pages are deduced from the current page size.
/// The current page defines the size of the page that the zine would be
/// printed on.
///
/// The zine's pages are provided in the order that they should be read,
/// separated by `pagebreak()`s. They are wrapped and then moved into position
/// so that any zine-page-internal layout is preserved.
///
/// Unfortunately, we cannot render an example since zen-zine requires
/// access to the page information to be able to deduce the size of the zine
/// pages.
///
/// -> content
#let zine16(
  /// size of margin around each zine page
  ///
  /// The default value of 0.25in is chosen because that is a pretty
  /// common minimum margin for printers. You could freely shrink this
  /// margin however the printer may clip the outer edges of the zine
  /// pages.
  ///
  /// The inner margins are _shared_ between pages so this is also
  /// the inner distance between any two zine pages.
  /// -> length
  zine-page-margin: 0.25in,
  /// whether to draw the border of the zine pages in printer mode
  /// 
  /// This border is sometimes helpful for seeing the placement of
  /// content on the final printer-ready page.
  /// -> boolean
  draw-border: true,
  /// whether to be in printer mode (false) or digital (true)
  ///
  /// When creating a digital zine, the margin specified with `zine-page-margin`
  /// is divided by two so that the digital visually looks like the printed
  /// zine with the pages cut out.
  /// -> boolean
  digital: false,
  /// input content of zine
  /// -> content
  content
) = context {
  // we need to be in context so we can get the full page's height and width
  // in order to deduce the zine page height and width
  // each of the zine pages share the margin with their neighbors
  // this height/width is without margins
  let zine-page-height = (page.height - 5*zine-page-margin)/4;
  let zine-page-width = (page.width - 5*zine-page-margin)/4;
  if digital {
    // assign half the zine margin to each digital page
    // resize pages and then provide content since it has pagebreaks already
    set page(
      height: zine-page-height+zine-page-margin/2,
      width: zine-page-width+zine-page-margin/2,
      margin: zine-page-margin/2
    )
    content
  } else {
    // make sure page has the correct margin and it is flipped
    set page(margin: zine-page-margin)
    // break content into the array of pages using the pagebreak
    // function and then place those pages into the grid
    let contents = ()
    let current-content = []
    for child in content.at("children") {
      if child.func() == pagebreak {
        contents.push(current-content)
        current-content = []
      } else {
        current-content = current-content + child
      }
    }

    if current-content != [] {
      contents.push(current-content)
    }

    // check for 16 pages
    assert.eq(
      contents.len(), 16,
      message: "Document content does not have exactly 16 pages (15 pagebreaks), it has "+str(contents.len())
    )

    let contents = (
      contents.slice(5,9).rev()+contents.slice(9,11)+contents.slice(3,5)+contents.slice(11,13).rev()+contents.slice(1,3).rev()+contents.slice(13,16)+contents.slice(0,1)
    ).map(
      // wrap the contents in blocks the size of the zine pages so that we can
      // maneuver them at will
      elem => block(
        width: zine-page-width,
        height: zine-page-height,
        spacing: 0em,
        elem
      )
    ).enumerate().map(
      // flip if on top row
      elem => if elem.at(0) < 4 or elem.at(0) > 7 and elem.at(0) < 12 {
        rotate(
          180deg,
          origin: center,
          elem.at(1)
        )
      } else {
        elem.at(1)
      }
    )
  
    let zine-grid = grid.with(
      columns: 4 * (zine-page-width, ),
      rows: zine-page-height,
      gutter: zine-page-margin,
    )
    if draw-border {
      zine-grid = zine-grid.with(
        stroke: luma(0)
      )
    }
    zine-grid(..contents)
  }
}
