#!/usr/bin/env python3

"""Modify cfexercies.py to make it a module which contains functions (foo_x funtions) which takes argument """

__author__ = 'Kate Griffin (kate.griffin21@imperial.ac.uk)'
__version__ = '0.0.1'

## imports ##
import sys # module to interface our program with the operating system

# x to the power of 0.5
def foo_1(x):
    """10^0.5"""
    return x ** 0.5 

# only returns higher value of 2 numbers
def foo_2(x, y):
    """Returns higher value: 20 is higher than 10"""
    if x > y:
        return x
    return y

# puts 3 numbers in order from lowest to highest
def foo_3(x, y, z):
    """Puts 3 numbers in order from lowest to highest: 10<20<30"""
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]

# ^ Another way of doing it
#def foo_3(x, y, z):
#    if x > y:
#        y,x = x,y
#    if y > z:
#        z,y = y,z
#    return [x, y, z]


# 1*i in a set range over x times
def foo_4(x):
    """1*i in a set range over 10 times"""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

# calculates factorial
def foo_5(x): # a recursive function that calculates the factorial of x
    """Factorial of 10"""
    if x == 1:
        return 1
    return x * foo_5(x - 1)
     

# calculate factorial
def foo_6(x): # Calculate the factorial of x in a different way
    """Factorial of 10"""
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto

def main(argv):
    print(foo_1(10))
    print(foo_2(10, 20))
    print(foo_3(10, 20, 30))
    print(foo_4(10))
    print(foo_5(10))
    print(foo_6(10))
    return 0

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)
    