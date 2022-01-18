#!/bin/bash
# Author: Junyue jz1621@imperial.ac.uk
# Script: CompileLaTeX.sh
# Desc: Compile latex with bibtex
# Arguments: latex file
# Date: Oct 2021

name=$(echo "$1" | cut -f 1 -d '.') # remove .tex extension
## compile latex with bibtex ##
pdflatex $name.tex
bibtex $name
pdflatex $name.tex
pdflatex $name.tex
evince $name.pdf &

## Cleanup
rm *.aux
rm *.log
rm *.bbl
rm *.blg