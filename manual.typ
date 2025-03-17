#import "@preview/tidy:0.4.2"

#let docs = tidy.parse-module(
  read("lib.typ"),
  name: "zen-zine",
  scope: (
    template: read("template/main.typ"),
    preview: image("template/preview.png"),
    tidy: tidy
  ),
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
