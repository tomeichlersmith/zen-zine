_default:
    @just --list  

# compile the template example once
compile *ARGS:
  sed 's/@preview/@local/' template/main.typ |\
    typst compile - {{ ARGS }}

# render template example into both digital and print forms
render: (compile "preview-digital.pdf" "--input" "digital=true") (compile "preview-print.pdf" "--input" "digital=false")

# compile template example into preview png
preppreview: (compile "preview.png --format png")

# compile manual
manual:
    typst compile manual.typ

# install to local repository for testing
install:
    uvx showman package typst.toml --overwrite --symlink

# package into my fork of typst/packages to prep a PR
package FORKPATH:
    uvx showman package typst.toml --typst_packages_folder {{FORKPATH}} --namespace preview --overwrite
