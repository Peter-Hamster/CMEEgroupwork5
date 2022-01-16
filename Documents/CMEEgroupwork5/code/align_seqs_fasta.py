#!/usr/bin/env python3

""" This script takes any two fasta sequences (in separate files) to be aligned as input. """

__appname__ = '[application name here]'
__author__ = 'Junyue (jz1621@ic.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

## imports ##
import sys
import csv

path = "../data/fasta/" 
if (len(sys.argv) > 1): # check if there are given inputs 
    f1 = open(path + sys.argv[1], "r") # assign the second argument variable to f1
    f2 = open(path + sys.argv[2], "r") # assign the third argument variable to f2
else:
    print("Sorry, no inputs were given.") # if no inputs were given
    ## use two fasta sequences from the data directory as defaults
    f1 = open("../data/fasta/407228326.fasta", "r") 
    f2 = open("../data/fasta/407228412.fasta", "r")

lines1strip = []
lines1 = f1.readlines()[1:] # return a list containing each line except the first one in f1 as a list item
for line in lines1:
    line = line.strip("\n") # remove \n from the string
    lines1strip.append(line) # append each line to a new list
seq1 = "".join(lines1strip) # join all items in the list into a string
f1.close() # close the file

lines2strip = []
lines2 = f2.readlines()[1:] # return a list containing each line except the first one in f2 as a list item
for line in lines2:
    line = line.strip("\n") # remove \n from the string
    lines2strip.append(line) # append each line to a new list
seq2 = "".join(lines2strip) # join all items in the list into a string
f2.close() # close the file


# Two example sequences to match

# Assign the longer sequence s1, and the shorter to s2
# l1 is length of the longest, l2 that of the shortest

l1 = len(seq1)
l2 = len(seq2)
if l1 >= l2:
    s1 = seq1
    s2 = seq2
else:
    s1 = seq2
    s2 = seq1
    l1, l2 = l2, l1 # swap the two lengths

# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)

def calculate_score(s1, s2, l1, l2, startpoint):
    """count the “score” as total of number of bases matched """
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    # some formatted output
    print("." * startpoint + matched)           
    print("." * startpoint + s2)
    print(s1)
    print(score) 
    print(" ")

    return score

# Test the function with some example starting points:
# calculate_score(s1, s2, l1, l2, 0)
# calculate_score(s1, s2, l1, l2, 1)
# calculate_score(s1, s2, l1, l2, 5)

# now try to find the best match (highest score) for the two sequences

def main(argv):
    """ Main entry point of the program. """
    my_best_align = None
    my_best_score = -1
    for i in range(l1): # take the last alignment with the highest score
        z = calculate_score(s1, s2, l1, l2, i) # call the function calculate_score
        if z > my_best_score: # if z is greater than the previous best score
            my_best_align = "." * i + s2 # get the best alignment
            my_best_score = z # get the best score
    print(my_best_align)
    print(s1)
    print ("Best score:", my_best_score)
    with open("../results/align_seqs_fasta.txt", "w") as f3: ## save the best alignment along with its corresponding score in a single text file
        f3.write(my_best_align) ## save the best alignment
        f3.write(f"\nBest score: {my_best_score}") ## save the best score
    return 0


if (__name__ == "__main__"):
    """Makes sure the "main" function is called from command line.""" 
    status = main(sys.argv)
    sys.exit(status)

    
    
