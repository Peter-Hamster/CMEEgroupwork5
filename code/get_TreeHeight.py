#!/usr/bin/env python3

"""align DNA sequences"""
__author__ = 'Kate Griffin (kate.griffin21@imperial.ac.uk)'
__version__ = '0.0.1'

import sys
import csv
import pandas as pd
import numpy as np

######################################################################
# Load in the dataset as a pandas df, given as an commad line argument 
######################################################################
def read_csv(arg):
    """read in csv file"""
    data_in = pd.read_csv("../data/" + arg + ".csv")

    return(data_in)

########################
# Calculate tree height
#######################
def calculate_height(data):
    "Calculate tree height by converting angle in degrees to radians, then multiplying tan(angle in radians) by the distance from base of trees (m)"

    # Define radians as degrees*pi/180 
    ##################################
    # For each row in the dataset, take the angles in degrees and multiply by pi/100. Make "Rad" column and fill with resulting values.
    for row in data:
        data["Rad"] = data["Angle.degrees"] * np.pi/180
    
    # Calculate tree height
    #######################
    # For each row, multiply the distance from the base of the tree by the tangent of previously calculated degree in angles. Make a new column (Tree.Height) and fill it with resulting values.
    for row in data:
        data["Tree.Height"] = data["Distance.m"] * np.tan(data["Rad"])

    return(data)

def main(argv):
    "Run functions"
    data_in = read_csv(sys.argv[1]) # Run read_csv() where the second argument from the command line (note: first argument is script name) will be used as the argument for this function (return: data_in)
    data = calculate_height(data_in) # Run calculate_height() function with data_in (i.e., the csv data loaded as a df from running read_csv()) as the argument (return: data)
    data.to_csv("../results/" + sys.argv[1] + "_treeheight_py.csv", sep= ',') # Write csv file for results

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)
