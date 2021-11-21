#!/usr/bin/env python3

"""This script is ..."""

__appname__ = 'Python II, in class scripts: vectorization'
__author__ = 'Kate Griffin (kate.griffin21@imperial.ac.uk'

import numpy as np 
import timeit
import matplotlib.pylab as p 

# Loop based function to calculate the entrywise product of two 1D arrays of the same length
def loop_product(a, b):
    "Function which uses a loop to calculate the entrywise product of two 1D arrays of the same length"
    N = len(a)
    c = np.zeros(N)
    for i in range(N):
        c[i] = a[i] * b[i]   
    return c

# Vectorised function to calculate the entrywise product of two 1D arrays of the same length
def vect_product(a, b):
    """Vectorised function which calculates the entrywise product of two 1D arrays of the same length"""
    return np.multiply(a, b)

# Compare the runtimes of loop_product and vect_product on increasingly large randomly-generated 1D arrays
# Make an array with various lengths
array_lengths = [1, 100, 10000, 1000000, 10000000]
t_loop = [] # initialize an empty list
t_vect = [] # initialize an empty list

for N in array_lengths:
    print("\nSet N=%d" %N)
    #randomly generate our 1D arrays of length N
    a = np.random.rand(N)
    b = np.random.rand(N)
    
    # time loop_product 3 times and save the mean execution time.
    timer = timeit.repeat('loop_product(a, b)', globals=globals().copy(), number=3)
    t_loop.append(1000 * np.mean(timer))
    print("Loop method took %d ms on average." %t_loop[-1])

    # time vect_product 3 times and save the mean execution time.
    timer = timeit.repeat('vect_product(a, b)', globals=globals().copy(), number=3)
    t_vect.append(1000 * np.mean(timer))
    print("vectorized method took %d ms on average." %t_vect[-1])

# Compare the timings on a plot
p.figure()
p.plot(array_lengths, t_loop, label="loop method")
p.plot(array_lengths, t_vect, label="vect method")
p.xlabel("Array length")
p.ylabel("Execution time (ms)")
p.legend()
p.show()

# Rerun above but make it bigger
N = 1000000000

a = np.random.rand(N)
b = np.random.rand(N)
c = vect_product(a, b)

# if no error, remove a, b, c from memory.
del a
del b
del c