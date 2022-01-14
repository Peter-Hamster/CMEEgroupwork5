#!/usr/bin/env python3

"""Calculates heights of trees given distance of farthest treetop 
"""

__author__ = 'Kayleigh Greenwood (kayleigh.greenwood21@imperial.ac.uk)'
__version__ = '0.0.1'

## Imports ##
import csv
import sys
import pandas as pd
from pathlib import Path
import os 
import math

## Functions ##

def TreeHeight(degrees, distance):
    # stores function inside variable TreeHeight

    radians = degrees * math.pi / 180 
    # converts degrees to radians
    height = distance * math.tan(radians) 
    # uses trig to calculate height

    return height
    # returns the value of height, making it available outside of the function

## Code ##
 

def main(argv):
    """Main entry point of the program"""

    # imports data frame to read and puts it into TreeData variable
    TreeData = pd.read_csv(argv[1])
    # TreeData = pd.read_csv("../data/trees.csv")

    # creates a new column for data frame in TreeData named Tree.Height.m   
    TreeData["Tree.Height.m"] = 0.0 
    # set to 0.0 instead of "" so that column would default to float
    # could set as "" and use pd.to_numeric(TreeData["Tree.Height.m"]) to change to float 

    # for loop that calculates tree height for each data entry and adds it to Tree.Height.m column
    print(len(TreeData))
    for i in range(len(TreeData)):
        # for each row(and therefore data point) in treedata
        
        TreeHeightValue = TreeHeight(TreeData.iloc[i]["Angle.degrees"], TreeData.iloc[i]["Distance.m"]) 
        # create a new variable and store the output of the tree height function into it
        # use indexing to calculate Tree Height for that row

        TreeData.at[i, "Tree.Height.m"] = TreeHeightValue
        # store result in the Tree.height.m column of each row

    filebase = os.path.splitext(os.path.basename(argv[1]))[0]
    # .splitect removes file extension and .basename removes path

    filename = "../results/" + filebase + "_treeheights.csv"
    # creates name of new file that results will be written to
    
    TreeData.to_csv(filename, index=False)
    # writes the contents of TreeData into a file in results, without the rows being numbered.
    
    print("Results saved to", filename)
    # end



if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)