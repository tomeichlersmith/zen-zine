#import "/src/lib.typ": zine
#set page("us-letter")
#show heading.where(level: 1): hd => {
  pad(top: 2em, text(10em, align(center, hd.body)))
}
#show: zine.with(digital: true)

= 1

#pagebreak()

= 2

#pagebreak()

== 3
#lorem(50)

#pagebreak()

== 4

#pagebreak()

= 5
#v(1fr)
five

#pagebreak()

six

#pagebreak()

= 7
seven

#pagebreak()

$ 8 $

