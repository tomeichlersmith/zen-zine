#import "@preview/tidy:0.4.3"
#import "@preview/codly:1.3.0": codly-init, no-codly, codly

#let docs = tidy.parse-module(
  read("src/lib.typ"),
  name: "zen-zine",
)

#show link: it => {
  let dest = str(it.dest)
  if "." in dest and not "/" in dest {
    return underline(it, stroke: luma(60%), offset: 1pt)
  }
  set text(fill: rgb("#1e8f6f"))
  underline(it)
}

#show: codly-init
#show raw.where(block: true): set text(size: 0.95em)
#show raw.where(block: true): it => pad(x: 4%, it)
#show raw.where(block: false, lang: "typ").or(raw.where(lang: "notnone")): it => box(
  inset: (x: 3pt),
  outset: (y: 3pt),
  radius: 40%,
  fill: luma(235),
  it
)
#set raw(lang: "notnone")

#let ref-fn(name) = link(label("zen-zine-"+name+"()"), raw(name))

#let version = toml("/typst.toml").package.version

#show heading.where(level: 1): hd => {
  align(center, text(2em, blue)[#hd.body])
}

= zen-zine
#align(center, version)
#align(center)[typset a fun little single-printer-page zine about your favorite topic!]

== pages and margins
There are some limitations in the dynamics of the underlying Typst `page`, so we
are forced to manually replicate the behavior of a `page` container (done by #ref-fn("zine-page")).
However, the pages in the final, folded zine are _not_ the same as the page that the zine is printed on.
In this context, we refer to a page of the final, folded zine as "zine page" and its margins as "zine margins"
while the parent Typst `page` is the "printer page" and the "printer margin".

== to trim or not to trim
#figure(
  grid(
    columns: (1fr, 1fr),
    box(stroke: black, image("tests/eight/printer-margin/intend-to-trim/ref/1.png", width: 95%)),
    box(stroke: black, image("tests/eight/printer-margin/no-trim/ref/1.png", width: 95%)),
  ),
  caption: []
)

= Function Reference
#tidy.show-module(
  docs,
  first-heading-level: 2,
  show-outline: true,
  style: tidy.styles.default
)
