#let default-margin-zine8 = ("bottom": 0.5in, "rest": 0.25in)

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
  /// increased to make room for the page number if
  /// numbering is not none and margin is auto.
  ///
  /// -> length
  margin: auto,
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
  numbering: none,
  /// how to align the page numbers relative to the page
  /// -> align
  number-align: center+bottom,
  /// whether to draw the border of the zine pages
  /// 
  /// This border is sometimes helpful for seeing the placement of
  /// content on the final printer-ready page and seeing the margins
  /// of the zine pages
  /// -> boolean
  draw-border: false,
  /// content to put into page
  /// -> content
  body
) = {
  let numbering = if numbering == auto {
    "1"
  } else {
    numbering
  }
  let margin = if margin == auto {
    if numbering == none {
      0.25in
    } else {
      default-margin-zine8
    }
  } else {
    margin
  }
  block(
    width: width,
    height: height,
  )[
    #block(
      inset: margin,
      width: 100%,
      height: 100%,
      stroke: if draw-border { black } else { none },
      body
    )

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

/// break content into an array of pages
///
/// Perhaps in a future version of Typst, we can call some kind of internal
/// function given the current `page` configuration and it will inform
/// us of the array of page contents, but for now, we simply require the
/// user to manually insert `pagebreak()` calls where they wish the
/// zine-page boundaries to be.
/// -> array
#let break-content-into-page-array(content) = {
  // allow super-users to provide an array of content directly
  if type(content) == array {
    return content
  }

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

  contents
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
#let zine8(
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
) = {

  let contents = break-content-into-page-array(content);

  assert.eq(
    contents.len(), 8,
    message: "Document content does not have exactly 8 pages (7 pagebreaks)."
  )

  context {
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
      zine-grid(..contents)
    }
  }
}

#let zine = zine8

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
) = {

  let contents = break-content-into-page-array(content);

  assert.eq(
    contents.len(), 16,
    message: "Document content does not have exactly 16 pages (15 pagebreaks)."
  )

  context {
    // we need to be in context so we can get the full page's height and width
    // in order to deduce the zine page height and width
    // each of the zine pages share the margin with their neighbors
    // this height/width is without margins
    let zine-page-height = page.height/4;
    let zine-page-width = page.width/4;

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
      // resize output page to be the same size as the zine-page
      set page(height: zine-page-height, width: zine-page-width)
      for zpage in contents {
        zpage
      }
    } else {
      let contents = (
        contents.slice(5,9).rev()+contents.slice(9,11)+contents.slice(3,5)+contents.slice(11,13).rev()+contents.slice(1,3).rev()+contents.slice(13,16)+contents.slice(0,1)
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
        rows: zine-page-height
      )
      zine-grid(..contents)
    }
  }
}
