#!/usr/bin/env python3

"""This script is used to demonstrate profiling"""

__appname__ = 'Python II, in class scripts: Porfile me 2'
__author__ = 'Kate Griffin (kate.griffin21@imperial.ac.uk'

# Function which squares each value in a range (which is specified as an argument) 
def my_squares(iters):
    """Function which squares each value in a given range"""
    out = [i ** 2 for i in range(iters)]
    return out

# Make a function which takes two arguments (inters is explained in the code above)
# This function takes a string as an argument, repeats it x number of times (based on value for "inters") and adds a comma between each iteration
def my_join(iters, string):
    """Function which takes a string as an argument, repeats it and adds a comma between each iteration"""
    out = ''
    for i in range(iters):
        out += ", " + string
    return out

# Make a function which takes two arguments (x and y) 
# This function puts x and y into the above functions
def run_my_funcs(x,y):
    """Function with 2 arguments, puts them into my_squares and my_join, runs both functions and then returns 0"""
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000,"My string")

# Note to self: look at profileme.py for more detailed explanation of each line