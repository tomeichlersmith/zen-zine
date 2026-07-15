#import "/src/lib.typ": zine8-assemble
#set page("us-letter")
#zine8-assemble(
  (i) => "/tests/eight/two-step/content/ref/"+str(i)+".png"
)
