#import "/src/lib.typ": zine
#set page("us-letter")
#show heading.where(level: 1): hd => {
  pad(top: 2em, text(10em, align(center, hd.body)))
}
#let show-page-box(body) = block(stroke: black, width: 100%, height: 100%, body)
#show: zine.with(digital: true, numbering: auto)

#show-page-box[
= 1
]

#pagebreak()

= 2

#pagebreak()

#show-page-box[
== 3
#lorem(50)
]

#pagebreak()

== 4

#pagebreak()

= 5
#v(1fr)
five

#pagebreak()

six

#pagebreak()

#show-page-box[
= 7
seven
]

#pagebreak()

$ 8 $

