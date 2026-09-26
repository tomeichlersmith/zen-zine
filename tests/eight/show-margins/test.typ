#import "/src/lib.typ": zine8, zine8-margin-names
#set page(fill: luma(80%))
#let demo-margins(
  page
) = {
  box(
    fill: aqua.lighten(50%)
  )[#h(1fr)#v(1fr)]
  for ((name, edges)) in zine8-margin-names.at(page) {
    for edge in edges {
      let (alignment, orientation) = if edge == "top" {
        (top+center, 0deg)
      } else if edge == "bottom" {
        (bottom+center, 180deg)
      } else if edge == "left" {
        (left+horizon, -90deg)
      } else if edge == "right" {
        (right+horizon, +90deg)
      } else {
        (center+horizon, 0deg)
      }
      place(
        alignment,
        rotate(
          orientation,
          origin: bottom,
          reflow: true,
          text(
            size: 1.4em
          )[#name | #edge]
        )
      )
    }
  }
}
#show: zine8.with(
  digital: false,
  draw-border: true,
  fill: white,
  margin: (
    trim-margin: 1.0cm,
    printer-margin: 0.5cm,
    inner-fold: 0.25cm,
    outer-fold: 0.75cm,
    cut: 0.5cm,
    rest: 1cm,
  )
)
#demo-margins(0)
#pagebreak()
#demo-margins(1)
#pagebreak()
#demo-margins(2)
#pagebreak()
#demo-margins(3)
#pagebreak()
#demo-margins(4)
#pagebreak()
#demo-margins(5)
#pagebreak()
#demo-margins(6)
#pagebreak()
#demo-margins(7)
