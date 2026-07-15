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
package FORKPATH="packages/packages":
    uvx showman package typst.toml --typst_packages_folder {{FORKPATH}} --namespace preview --overwrite

set-version NEWVER:
    sed -i "s|$(grep version typst.toml | cut -f 3 -d ' ' | tr -d \")|{{NEWVER}}|g" README.md typst.toml template/main.typ
    git add README.md typst.toml template/main.typ
    git commit -v
    git push

# light clone of fork repo assumed on github
clone-packages repo="tomeichlersmith/typst-packages":
    git clone --depth 1 --no-checkout --filter="tree:0" git@github.com:{{repo}} packages
    git -C packages sparse-checkout init
    git -C packages sparse-checkout set packages/preview/zen-zine
    git -C packages remote add upstream git@github.com:typst/packages
    git -C packages config remote.upstream.partialclonefilter tree:0
    git -C packages checkout main
