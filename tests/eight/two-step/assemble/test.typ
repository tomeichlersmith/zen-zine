#import "/src/lib.typ": zine8-assemble
#set page("us-letter")
#zine8-assemble(
  (i) => path("../content/ref/"+str(i)+".png")
)
