#!/usr/bin/env python3

""" This script can  """

__appname__ = '[application name here]'
__author__ = 'Junyue (jz1621@ic.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

import sys
import os
import math
import pandas as pd

TreeData = pd.read_csv(sys.argv[1]) # open a .csv file
## obtain the input file name without extension and relative path
InputFileName = os.path.basename(sys.argv[1]).split('.')[0]

def TreeHeight(degrees, distance):
    radians = degrees * math.pi / 180 # convert degrees to radians
    height = distance * math.tan(radians) # calculate the tree height using the trigonometric formula
    print("Tree height is:" + " " + str(height)) # print tree height
    return (height)

height = [] # initialize a new vector
TreeLength = len(TreeData["Species"]) # obtain the number of species

for i in range(TreeLength):
    z = TreeHeight(TreeData["Angle.degrees"][i], TreeData["Distance.m"][i]) # call the function TreeHeight and input the corresponding degrees and distances 
    height.append(z) # append the tree height

TreeData["Tree.Height.m"] = height # add a new column to the original data frame
TreeData.to_csv("../results/" + InputFileName + "_treeheightsP.csv") # create a csv output file



