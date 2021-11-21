#!/usr/bin/env python3

"""This script is used to demonstrate profiling"""

__appname__ = 'Python II, in class scripts: Porfile me'
__author__ = 'Kate Griffin (kate.griffin21@imperial.ac.uk'

# Function which squares each value in a range (which is specified as an argument) 
def my_squares(iters):
    """Function which squares each value in a given range"""
    out = [] #initialise an empty list
    for i in range(iters): # for i in the specified range
        out.append(i ** 2) # square each value ad add to the list "out"
    return out # return list with squared values

# Make a function which takes two arguments (inters is explained in the code above)
# This function takes a string as an argument, repeats it x number of times (based on value for "inters") and adds a comma between each iteration
def my_join(iters, string):
    """Function which takes a string as an argument, repeats it and adds a comma between each iteration"""
    # This whole function could just be replaced with: return ", ".join([string]*iters)
    out = '' # make an undefined string
    for i in range(iters): # for each value in the range ("inters"- given as an argument)
        out += string.join(", ") # repeates a string *inter number of times and seperates each iteration with a comma between each 
    return out

# Make a function which takes two arguments (x and y) 
# This function puts x and y into the above functions
"""Function with 2 arguments, puts them into my_squares and my_join, runs both functions and then returns 0"""
def run_my_funcs(x,y):
    print(x,y)
    my_squares(x) # puts x as an argument for  my_squares
    my_join(x,y) # puts x and y as an argument for my_joins
    return (0) # returns 0 

run_my_funcs(10000000,"My string")