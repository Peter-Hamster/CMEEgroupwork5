#!/usr/bin/env python3

"""This script is used to demonstrate which is faster: loops vs list comprehensions/the join method for strings"""

__appname__ = 'Python II, in class scripts: timeime.py'
__author__ = 'Kate Griffin (kate.griffin21@imperial.ac.uk'


##############################################################################
# loops vs. list comprehensions: which is faster?
##############################################################################

iters = 1000000

import timeit

from profileme import my_squares as my_squares_loops

from profileme2 import my_squares as my_squares_lc

##############################################################################
# loops vs. the join method for strings: which is faster?
##############################################################################

mystring = "my string"

from profileme import my_join as my_join_join

from profileme2 import my_join as my_join

# run the two sets of comparisons using timeit() 
# %timeit my_squares_loops(iters)
# %timeit my_squares_lc(iters)
# %timeit (my_join_join(iters, mystring))
# %timeit (my_join(iters, mystring))

import time
start = time.time()
my_squares_loops(iters)
print("my_squares_loops takes %f s to run." % (time.time() - start))

start = time.time()
my_squares_lc(iters)
print("my_squares_lc takes %f s to run." % (time.time() - start))

