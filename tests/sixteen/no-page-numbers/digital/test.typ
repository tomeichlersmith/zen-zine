#import "/src/lib.typ": zine16
#set page("us-letter")
#show heading.where(level: 1): hd => {
  pad(top: 2em, text(5em, align(center, hd.body)))
}
#let show-page-box(body) = block(stroke: black, width: 100%, height: 100%, body)
#show: zine16.with(digital: true)

#show-page-box[
= 1
]

#pagebreak()

= 2

#pagebreak()

#show-page-box[
== 3
#lorem(20)
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

#pagebreak()

#show-page-box[
= 9
]

#pagebreak()

= 10

#pagebreak()

#show-page-box[
== 11
#lorem(20)
]

#pagebreak()

== 12

#pagebreak()

= 13
#v(1fr)
thirteen

#pagebreak()

fourteen

#pagebreak()

#show-page-box[
= 15
fifteen
]

#pagebreak()

$ 16 $
