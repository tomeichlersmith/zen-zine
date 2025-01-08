_default:
    @just --list  

# compile the template example once
compile:
  sed '1c\#import "/lib.typ": *' template/main.typ |\
    typst compile - template/preview.png --format png
