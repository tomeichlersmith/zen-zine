_default:
    @just --list  

# compile the template example once
compile *ARGS:
  sed 's/@preview/@local/' template/main.typ |\
    typst compile - {{ ARGS }}

# render template example into both digital and print forms
render: (compile "preview-digital.pdf" "--input" "digital=true") (compile "preview-print.pdf" "--input" "digital=false")

# compile template example into preview png
preppreview: (compile "template/preview.png --format png")

# compile manual
manual:
    typst compile manual.typ

# prep a python venv for using showman
init-showman:
    #!/bin/bash
    python3 -m venv venv
    . venv/bin/activate
    pip install showman

_showman_package *ARGS:
    #!/bin/bash
    . venv/bin/activate
    showman package typst.toml {{ ARGS }}

# install to local repository for testing
install: (_showman_package "--overwrite" "--symlink")

# package into my fork of typst/packages to prep a PR
package FORKPATH: (_showman_package "--typst_packages_folder" FORKPATH "--namespace" "preview" "--overwrite")
