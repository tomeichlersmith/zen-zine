#import "/src/lib.typ": zine8
#set page("us-letter")
#assert.eq(
  catch(() => zine8(range(7))),
  "equality assertion failed: Document content does not have exactly 8 pages (7 pagebreaks), only 7 pages were found."
)
