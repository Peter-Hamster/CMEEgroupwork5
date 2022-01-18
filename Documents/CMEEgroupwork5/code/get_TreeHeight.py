#!/usr/bin/env python3

""" This script can calculate heights of trees given distance of each tree from its base and angle to its top, using the trigonometric formula. """

__appname__ = '[application name here]'
__author__ = 'Junyue (jz1621@ic.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

## import ##
import sys
import os
import math
import pandas as pd

TreeData = pd.read_csv(sys.argv[1]) # load the csv file
## obtain the input file name without extension and relative path
InputFileName = os.path.basename(sys.argv[1]).split('.')[0]

def TreeHeight(degrees, distance):
    """calculate the tree height. """
    radians = degrees * math.pi / 180 # convert degrees to radians
    height = distance * math.tan(radians) # calculate the tree height using the trigonometric formula
    print("Tree height is:" + " " + str(height)) # print tree height
    return (height)

height = [] # initialize a new list
TreeLength = len(TreeData["Species"]) # obtain the number of species

for i in range(TreeLength):
    z = TreeHeight(TreeData["Angle.degrees"][i], TreeData["Distance.m"][i]) # call the function TreeHeight and input the corresponding degrees and distances 
    height.append(z) # append the tree height

TreeData["Tree.Height.m"] = height # add the tree height column 
TreeData.to_csv("../results/" + InputFileName + "_treeheights.csv") # create a csv output file


