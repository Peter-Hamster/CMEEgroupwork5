#!/usr/bin/env python3

"""align two DNA sequences such that they are as similar as possible
"""

__author__ = 'Kayleigh Greenwood (kayleigh.greenwood21@imperial.ac.uk)'
__version__ = '0.0.1'

### imports ###
import csv
import sys

### script ###

def assign(fastafile1, fastafile2):
    """assign sequences and their lengths into variables to be returned"""
    s1 = [] # create arrays for lines of DNA bases to go into
    s2 = []
    with open(fastafile1, 'r') as f: #opens the first file to read
        for line in f:
            if not line.startswith(">"): # makes sure all lines except first header line are copied
                s1.append(line)
    
    with open(fastafile2, 'r') as f: #opens the second file to read
        for line in f:
            if not line.startswith(">"):
                s2.append(line)

    news1 = [] # creates new array for modified sequence to go into
    for x in s1: 
        news1.append(x.replace("\n", "")) # removes all newline characters

    news2 = []
    for x in s2:
        news2.append(x.replace("\n", ""))

    s1 = ''.join(map(str, news1)) # converts array of individual lines into one string of continuous DNA bases
    s2 = ''.join(map(str, news2))

    l1 = len(s1) # assigns length of sequences to variables
    l2 = len(s2)

    # Now alter to ensure that s1 & l1 represent the longest sequence
    if l1 < l2: # if l1 is less than l2, swap them around
        s1, s2 = s2, s1 # swap the two seqs
        l1, l2 = l2, l1 # swap the two lengths

    return s1, s2, l1, l2

def calculate_score(s1, s2, l1, l2, startpoint):
    """computes a score for one specific alignment of two sequences, based on a specific startpoint of the shorter sequence
    by returning the number of matches starting from an abitrary startpoint chosen by the user"""
    
    matched = "" # to hold string displaying alignements
    score = 0 # starts with zero alignments
    for i in range(l2): # l2 is the shorter length
        if (i + startpoint) < l1: # if the startpoint is small enough that the bases still overlap
            if s1[i + startpoint] == s2[i]: # if the base in the same position in s1 and s1 match,
                matched += "*" # add a * to the matched variable to indicate a match
                score += 1 # increment score to record the match
            else:
                matched += "-" # add a - to the matched variable to indicate no match

    # some formatted output
    # print("." * startpoint + matched) # print full stops up until where the startpoint was, then print the matched variable
    # # which contains the pattern of which bases are matching vs not matching           
    # print("." * startpoint + s2) # display the correspondin alignment of s2 (the shorter sequence)
    # print(s1) # display the longer sequence underneath
    # print("Score:", score) 
    # print(" ")

    return score

def calculate_best(s1, s2, l1, l2):
    """ Finds the best match (highest score) for the two sequences """
    my_best_align = None
    my_best_score = -1 # need to set to -1 because in the first loop, we need z to be bigger than my_best_score so that the first loop runs
    # for this reason, if we set my_best_score to 0, the loop still might not run because there is a chance z could be 0
    # z could be 0 because there could be alignments where there are no matches
    # this is why we must set it to -1

    for i in range(l1): # Loops through what will be the various starting points / alignments to check
        z = calculate_score(s1, s2, l1, l2, i)
        if z > my_best_score:
            my_best_align = "." * i + s2 # update the pattern for my_best_align every time a new highest score is reached.
            my_best_score = z # updates with highest score
        
    
    return my_best_align, my_best_score

def run_alignment(input1, input2):
    """Combines processes to find best alignment of two sequences"""

    s1, s2, l1, l2 = assign(input1, input2)
    my_best_align, my_best_score = calculate_best(s1, s2, l1, l2)

    # write results into file
    f = open('../results/align_seqs_results.txt', 'w')
    f.write("Best alignment: \n")
    f.write(str(my_best_align))
    f.write("\n")
    f.write(str(s1))
    f.write("\nBest alignment score: \n")
    f.write(str(my_best_score))
    f.write("\n")

    f.close()

    print("Results saved into ../results/align_seqs_results.txt")

### ENTRY POINT ###
def main(argv):
    """Main entry point of the program"""
    if len(argv)>=2:
        try:
            # if user has entered all required parameters
            run_alignment(argv[1], argv[2])
        except:
            # if user has entered enough required parameters but of wrong format
            print("Error: input parameters of the wrong format.")
    elif len(argv)>1:
            # if user has entered parameters, but not enough
            print("Error: not enough input parameters.", "\n")
    else:
        # if user has entered no parameters
        
        print("Running script with default values.")
        run_alignment("../data/407228326.fasta", "../data/407228412.fasta")



if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)

