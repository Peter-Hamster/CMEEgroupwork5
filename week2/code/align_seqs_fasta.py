#!/usr/bin/env python3

"""align DNA sequences"""
__author__ = 'Kate Griffin (kate.griffin21@imperial.ac.uk)'
__version__ = '0.0.1'

import sys

# Two example sequences to match
# seq2 = "ATCGCCGGATTACGGG"
# seq1 = "CAATTCGGAT"
# make a function which reads two fasta files containing 2 seqs

# read fasta files
def read_fasta(arg1 = "407228412.fasta", arg2 = "407228326.fasta"):
    """read fasta file"""
    temp = []
    with open("../../week1/data/" + arg1,'r') as f:
        next(f)
        s1 = f.read()
        temp.append(s1)
        #print(temp[0])
    with open('../../week1/data/' + arg2,'r') as f2:
        next(f2)
        s2 = f2.read()
        temp.append(s2)
        #print(temp[1])

    seq1 = temp[0].replace("\n", "")  
    seq2 = temp[1].replace("\n", "")
    return(seq1, seq2)

# Assign the longer sequence s1, and the shorter to s2
# l1 is length of the longest, l2 that of the shortest
def set_length(seq1,seq2):
    """Assign longest and shortest sequence"""
    l1 = len(seq1)
    l2 = len(seq2)
    if l1 >= l2:
        s1 = seq1
        s2 = seq2
    else:
        s1 = seq2
        s2 = seq1
        l1, l2 = l2, l1 # swap the two lengths
    
    return s1,s2,l1,l2

# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)
def calculate_score(s1, s2, l1, l2, startpoint):
    """Computes a score by returning the number of matches starting from arbitrary startpoint (chosen by the user)"""
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        # import ipdb; ipdb.set_trace()
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"


    # some formatted output
    #print("." * startpoint + matched)           
    #print("." * startpoint + s2)
    #print(s1)
    #print(score) 
    #print(" ")

    return score

# Test the function with some example starting points:
# z= calculate_score(s1, s2, l1, l2, 0)
# calculate_score(s1, s2, l1, l2, 1)
# calculate_score(s1, s2, l1, l2, 5)

# now try to find the best match (highest score) for the two sequences
def best_match(s1, s2, l1, l2):
    """Find best match by comparing scores"""
    my_best_align = None
    my_best_score = -1

    for i in range(l1): # Note that you just take the last alignment with the highest score
        z = calculate_score(s1, s2, l1, l2, i)
        if z > my_best_score:
            my_best_align = "." * i + s2 # think about what this is doing!
            my_best_score = z 
    

    print("Best alignment: \n", my_best_align)
    print("\n", s1)
    print("Best score:", my_best_score)

    return(my_best_align, s1, my_best_score)


# function which prints my_best_align in a txt file

# read .fasta files and return two values, i.e., sequence 1 (seq1) and sequence 2 (seq2). 
# input seq1 and seq2 into "set_length" function, which will return sequence lengths 
# input sequence lengths into "best_match"function to return the best alignment ("my_best_align")
def main(argv):
    if (len(sys.argv) == 3):
        seq1, seq2 = read_fasta(sys.argv[1], sys.argv[2])
    else:
        seq1, seq2 = read_fasta("407228412.fasta", "407228326.fasta")

    s1, s2, l1, l2= set_length(seq1,seq2)
    my_best_align, s1, my_best_score= best_match(s1, s2, l1, l2)

    f = open("../results/output.txt","w")
    f.write(my_best_align+ "\n")
    f.write(s1+ "\n")
    f.write(str(my_best_score))

    f.close()
   
    
if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)
    

# arguments
###########
# 407228412.fasta 407228326.fasta

