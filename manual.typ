#import "@preview/tidy:0.4.0"
#import "/lib.typ"

#let docs = tidy.parse-module(
  read("lib.typ"),
  name: "zen-zine",
)
#tidy.show-module(
  docs,
  style: tidy.styles.default
)
