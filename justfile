_default:
    @just --list  

# compile the template example once
compile *ARGS:
  sed '1c\#import "/lib.typ": *' template/main.typ |\
    typst compile - {{ ARGS }}

preppreview: (compile "template/preview.png --format png")
