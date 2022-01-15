"""align_seqs_better.py is a python script. This script aligns two DNA sequences and saves the best alignment 
along with its corresponding score in a single text file"""


__appname__ = 'align_seqs_better.py'
__author__ = 'Peter Zeng (Email: pz221@ic.ac.uk)'
__version__ = '0.0.1'

### imports ###
import sys

### assign method, to read the fasta file ###
def assign(a, b):
    """Read and initialize the file"""

    temp = []
    ### open the file ###
    with open("../data/" + a, "r") as myfile:
        next(myfile) 
        s1 = myfile.read()
        temp.append(s1)
        seq1 = temp[0].replace("\n", "")  

    ### open the file ###
    with open("../data/" + b, "r") as myfile:
        next(myfile)
        s2 = myfile.read()
        temp.append(s2)
        seq2 = temp[1].replace("\n", "")

    ###  Assign the longer sequence s1, and the shorter to s2 ###
    ### l1 is length of the longest, l2 that of the shortest ###

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


### A function that computes a score by returning the number of matches starting ###
### from arbitrary startpoint (chosen by user) ###

def calculate_score(s1, s2, l1, l2, startpoint):
    """Calculate and find out the best score"""
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
    # print("." * startpoint + matched)           
    # print("." * startpoint + s2)
    # print(s1)
    # print(score) 
    # print(" ")

    return score

### The main function ###

def main(argv):
    """The main function that will use other function"""
    sys.argv[0] # prints python_script.py
    fastaFile1 = sys.argv[1] # prints var1
    fastaFile2 = sys.argv[2] # prints var2

    s1, s2, l1, l2 = assign(fastaFile1, fastaFile2)

    # now try to find the best match (highest score) for the two sequences
    my_best_align = []
    my_best_score = [-1]
    numberBestMatch = 0

    for i in range(l1): # Note that you just take the last alignment with the highest score
        z = calculate_score(s1, s2, l1, l2, i)
        if z > my_best_score[0]:
            my_best_align = ["." * i + s2] # think about what this is doing!
            my_best_score = [z]
            numberBestMatch = 1
            continue
        if z == my_best_score[0]:
            my_best_align.append ("." * i + s2)
            my_best_score.append(z)
            numberBestMatch = numberBestMatch + 1
    
    with open("../results/align_seqs_better_output.txt",'w+') as outputFile:
        for i in range(numberBestMatch):
            outputFile.write(str(my_best_align[i]))
            outputFile.write(s1)
            outputFile.write(("Best score: " + str(my_best_score[i])))
            outputFile.write("\n\n")

    print(("Best score: " + str(my_best_score[0])))

### 
if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)

