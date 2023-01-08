#!/bin/sh
#assemble and preprocess all the sources files

if [ ! -d "./latex" ]; then
  mkdir ./latex
fi

pandoc text/pre.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/1pre.tex
pandoc text/intro.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/2intro.tex

for filename in text/ch*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --lua-filter=footnote.lua --to markdown | pandoc --lua-filter=filter.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --to latex > latex/"$(basename "$filename" .txt).tex"
done

pandoc text/epi.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/epi.tex

for filename in text/apx*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --to latex > latex/"z$(basename "$filename" .txt).tex"
done

pandoc -s latex/*.tex -o book.tex
pandoc -N --quiet -V geometry:margin=1.2in -V mainfont="NotoSansMono-Regular" -V sansfont="NotoSansMono-Regular" -V monofont="NotoSansMono-Regular" -V fontsize=10pt book.tex --pdf-engine=xelatex --toc -o book.pdf
pandoc --quiet -f latex book.tex -o book.epub
# sed -i '' 's+Figure+Εικόνα+g' ./latex/ch0*

