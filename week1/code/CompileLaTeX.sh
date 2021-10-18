#!/bin/bash

# remove file extension from $1, name this value "filename"
filename=$(basename "$1" .tex)

pdflatex $filename.tex
bibtex $filename
pdflatex $filename.tex
pdflatex $filename.tex
evince $filename.pdf &

## Cleanup
rm *.aux
rm *.log
rm *.bbl
rm *.blg()