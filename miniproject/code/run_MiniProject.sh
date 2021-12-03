 #! /bin/sh

ipython3 Data_prep.py

Rscript model.R

Rscript analysis.R

pdflatex writeup.tex
bibtex writeup.aux
pdflatex writeup.tex
pdflatex writeup.tex
