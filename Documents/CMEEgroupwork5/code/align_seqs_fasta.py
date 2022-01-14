#!/usr/bin/env python3
import sys
import csv

path = "../data/fasta/"
if (len(sys.argv) > 1):
    f1 = open(path + sys.argv[1], "r")
    f2 = open(path + sys.argv[2], "r")
else:
    print("Sorry, no inputs were given.")
    f1 = open("../data/fasta/407228326.fasta", "r")
    f2 = open("../data/fasta/407228412.fasta", "r")

lines1strip = []
lines1 = f1.readlines()[1:]
for line in lines1:
    line = line.strip("\n")
    lines1strip.append(line)
seq1 = "".join(lines1strip)
f1.close()

lines2strip = []
lines2 = f2.readlines()[1:]
for line in lines2:
    line = line.strip("\n")
    lines2strip.append(line)
seq2 = "".join(lines2strip)
f2.close()


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
    my_best_align = None
    my_best_score = -1
    for i in range(l1): # Note that you just take the last alignment with the highest score
        z = calculate_score(s1, s2, l1, l2, i)
        if z > my_best_score:
            my_best_align = "." * i + s2 # think about what this is doing!
            my_best_score = z 
    print(my_best_align)
    print(s1)
    print ("Best score:", my_best_score)
    with open("../results/align_seqs_fasta.txt", "w") as f3:
        f3.write(my_best_align)
        f3.write(f"\nBest score: {my_best_score}")
    return 0


if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)

    
    
