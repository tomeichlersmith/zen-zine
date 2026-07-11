#import "/src/lib.typ": zine8
// this page needs to match the dimensions used in the content source
#set page("us-letter")
#zine8(
  // margin probably needs to be tweaked
  // (have not printed and tested folding)
  margin: 0pt,
  // pass in pages as array of images
  range(8).map(
    (i) => image(
      "two-step-content-"+str(i+1)+".svg",
    )
  )
)
