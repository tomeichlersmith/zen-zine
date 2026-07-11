#import "/src/lib.typ": zine8-assemble
#set page("us-letter")
#zine8-assemble(
  range(8).map((i) => "/tests/eight/two-step/content/ref/"+str(i+1)+".png")
)
