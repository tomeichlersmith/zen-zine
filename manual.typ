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
#show "/src/lib.typ": "@preview/zen-zine:"+version

#show heading.where(level: 1): hd => {
  align(center, text(2em, blue)[#hd.body])
}

= zen-zine
#align(center, version)
#align(center)[typset a fun little single-printer-page zine about your favorite topic!]

== reference example
#figure(
  block[
    #raw(read("tests/eg-ref/test.typ"), lang: "typ", block: true),
    #place(
      bottom+right,
      block(stroke: black, image("tests/eg-ref/ref/1.png", width: 60%)),
    )
  ],
  caption: [a short reference example to get started with its rendering (lower right)]
)

== pages and margins <zine-margin>
There are some limitations in the dynamics of the underlying Typst `page`, so we
are forced to manually replicate the behavior of a `page` container (done by #ref-fn("zine-page")).
However, the pages in the final, folded zine are _not_ the same as the page that the zine is printed on.
In this context, we refer to a page of the final, folded zine as "zine page" and its margins as "zine margins"
while the parent Typst `page` is the "printer page" and the "printer margin".

Zine margins can be specified with normal margins for a `page` (top, bottom, left, right, or rest).
They are relative to the zine page as it would be oriented in the final, folded zine.
Additionally, more possible margins specified in @zine-margin-names allow for more helpful control over the zine margins that could be relevant to zines -- they are defined by how the two zine pages that border each other interact in the final, folded zine.

#figure(
  table(
    columns: (auto, 50%),
    align: (right, left),
    table.header([*name*], [*description*]),
    [`inner-fold`], [two pages connected by a fold of the paper and the pages are adjacent when the zine is open],
    [`outer-fold`], [two pages connected by a fold of the paper but the pages are not next to each other when the zine is open],
    [`cut`], [the paper would be cut between these two pages],
    [`printer-margin`], [the zine page side adjacent to the outer edge of the printer page]
  ),
  caption: [definition of the additional margins for zine-pages]
) <zine-margin-names>

=== to trim or not to trim
If you have made a zine before, you may notice a slight size discrepancy between the different zine pages.
This is because printers often have a minimum margin from the edge of the printer page and so the "outer most"
zine pages (the ones with two edges along the edge of the printer page) are most effected by this margin.
@printer-margin-comp shows two different ways to specify how a printed zine should be constructed given a specific printer margin.

The first option is to modify the printer page directly using `set page`.
For example

#codly(range: (3,4))
#raw(read("tests/eight/printer-margin/intend-to-trim/test.typ"), lang: "typ", block: true)

which produces the left image in @printer-margin-comp.
Another option is to use the `printer-margin` key for zine margins. For example

#codly(range: (3,3))
#raw(read("tests/eight/printer-margin/no-trim/test.typ"), lang: "typ", block: true)

which produces the right image in @printer-margin-comp.

#figure(
  grid(
    columns: (1fr, 1fr),
    box(stroke: black, image("tests/eight/printer-margin/intend-to-trim/ref/1.png", width: 95%)),
    box(stroke: black, image("tests/eight/printer-margin/no-trim/ref/1.png", width: 95%)),
  ),
  caption: [Comparison between specifying the printer margin via `set page` (left) or within zine margin (right).]
) <printer-margin-comp>

While using a large margin like 3cm is probably unrealistic, it does help show the difference between the two strategies which (as the name of this section suggests) large comes down to how you are constructing the physical zine.

If you plan to have a white background (or whatever the color of the paper is) in the final, folded zine, then you can probably do fine without needing to trim off the printer margins. In this case, the second option (using the `printer-margin` zine margin) is the best case since then the page boundaries are lined up with where the folds would be.
If you won't have a white background or you want the zine pages to be identical in size, then you will probably need to trim off the printer margins. In this case, the first option using `set page` works well because the page boundaries are lined up with the where the folds would be _after_ trimming the printer margin off.


= Function Reference
#tidy.show-module(
  docs,
  first-heading-level: 2,
  show-outline: true,
  style: tidy.styles.default,
)
