#import "/src/lib.typ": zine8
#set page("us-letter")
#show heading.where(level: 1): hd => {
  pad(top: 2em, text(10em, align(center, hd.body)))
}
#let show-page-box(body) = block(stroke: black, width: 100%, height: 100%, body)
#zine8(
  margin: (
    "inner-fold": 0.05in,
    "bottom": 0.5in,
    "rest": 0.25in
  ),
  range(8).map(
    (i) => show-page-box[= #i]
  )
)
