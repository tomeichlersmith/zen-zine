// this height and width should match page dimensions in assemble source
#let printer-page = (
  "height": 11in,
  "width": 8.5in
)
#set page(
  height: printer-page.width / 2,
  width: printer-page.height / 4,
  margin: 0.25in
)
// Typst handles layout onto different pages
#lorem(700)
