#import "/src/lib.typ": zine16
#set page("us-letter")
#assert.eq(
  catch(() => zine16(range(7))),
  "equality assertion failed: Document content does not have exactly 16 pages (15 pagebreaks), only 7 pages were found."
)
