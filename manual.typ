#import "@preview/tidy:0.4.3"

// the module consists of exactly one function
// and I'm not expecting the manual to be printed onto real paper
// so I let the height of the page fit the content
// making the manual a single oblong page
#set page(height: auto)

#let docs = tidy.parse-module(
  read("lib.typ"),
  name: "zen-zine",
)

#show heading.where(level: 1): hd => {
  align(center, text(2em, blue)[#hd.body])
}

#tidy.show-module(
  docs,
  first-heading-level: 1,
  show-outline: false,
  style: tidy.styles.default
)
