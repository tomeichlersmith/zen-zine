#import "/src/lib.typ": zine16
#set page("us-letter")
#show heading.where(level: 1): hd => {
  pad(top: 2em, text(5em, align(center, hd.body)))
}
#let show-page-box(body) = block(stroke: black, width: 100%, height: 100%, body)
#zine16(
  digital: false,
  range(16).map((i) => show-page-box[= #i])
)
