#import "@preview/tidy:0.4.3"

#let docs = tidy.parse-module(
  read("src/lib.typ"),
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
