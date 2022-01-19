# CMEE Groupwork (Group 5)
## Brief description
This is the groupwork for the CMEE program from group 5. This project contains practice of the group work. These group works are aimed to practice how to write Python and R script 


## Languages

Python: 3.8.10
R: 3.6.3
Linux kernal: 5.11.0-27-generic


## Dependencies
Python: sys, csv, doctest, pandas, numpy

## Author name and contact
Author name: Peter (Guancheng) Zeng

Email: pz221@ic.ac.uk

# Project structure and Usage
## Biological Computing in Python I

### align_seqs_fasta.py

align_seqs_fasta.py is a python script. This script aligns two DNA sequences and saves the best alignment along with its corresponding score in a single text file. The external input should be required, for example: align_seqs_fasta.py seq1.fasta seq2.fasta . The result will be stored to the results folder

### align_seqs_better.py

align_seqs_better.py is a python script. This script aligns two DNA sequences and saves the best alignment along with its corresponding score in a single text file. The external input should be required, for example: align_seqs_better.py seq1.fasta seq2.fasta . The result will be stored to the results folder. The align_seqs_better.py will output several best align ig their alignment score are the same

### oaks_debugme.py

oaks_debugme.py is a python script. The script carefully compare the looping and the list comprehension way for the two tasks, which are to find oak tree species names and get names in upper case. This script used to have bugs, but they have been debugged

## Biological Computing in R
### get_TreeHeight.py

get_TreeHeight.py is a python script which calculates tree heights for all trees in the data. The script has been generalised so that it could be used for other datasets.

### get_TreeHeight.r

get_TreeHeight.r is an R script which calculates tree heights for all trees in the data. The script has been generalised so that it could be used for other datasets.

### run_get_TreeHeight.sh

run_get_TreeHeight.sh is a shell script that use to execute the get_TreeHeight.py and get_TreeHeight.r

### TAutoCorr.R

TAutoCorr.R is an R script which is used to find out if there is an autocorrelation in Florida weather

### FloridaLaTeX.tex

FloridaLaTeX.tex is a LaTeX file, which is the report of the result from TAutoCorr.R
