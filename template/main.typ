#import "@preview/zine:0.1.0": zine

#set document(author: "Tom", title: "Zine Mania")
#set text(font: "Linux Libertine", lang: "en")

// provide your content pages in order and they
// are placed into the zine template positions.
// the content is wrapped before movement so that
// padding and alignment are respected.
#zine(
  contents: (
    range(8).map(
      number => [
        #pad(2em,
          text(
            10em,
            align(
              center,
              str(number)
            )
          )
        )
      ]
    )
  )
)
