#!/usr/bin/env python3

"""Runs a function which returns the growth rate of consumer and resource population and produces two graphs which visualise the consumer-resource population dynamics """

__appname__ = 'Python II, practical 1, LV1'

__author__ = 'Kate Griffin (kate.griffin21@imperial.ac.uk'

## imports ##
import sys # module to interface our program with the operating system


# Define a function which returns the growth rate of consumer and resource population at any given time step
def dCR_dt(pops, t=0):
    """ Return the growth rate of consumer and resource population"""
    R = pops[0]
    C = pops[1]
    dRdt = r * R - a * R * C 
    dCdt = -z * C + e * a * R * C
    
    return np.array([dRdt, dCdt])


# Check to see that dCR_dt has been stored as a function
# type(dCR_dt)

# Now assign some parameter values:
r = 1.
a = 0.1 
z = 1.5
e = 0.75

# import numpy 
import numpy as np 

# Define the time vector; integrate from time point 0 to 15, using 1000 sub-divisions of time
t = np.linspace(0, 15, 1000)

# Set the initial conditions for the two populations (10 resources and 5 consumers per unit area), and convert the two into an array (dCR_dt function takes an array as input)
R0 = 10
C0 = 5 
RC0 = np.array([R0, C0]) # make array

# Import integrate
import scipy.integrate as integrate

# Numerically integrate this system forward from those starting conditions 
pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)

# Import matplotlib.pylab as p
import matplotlib.pylab as p

# Make a graph which visualises population density of consumer (predator) and resource (prey) over time
f1 = p.figure() # open empty figure
p.plot(t, pops[:,0], 'g-', label='Resource density') # add elements to the plot
p.plot(t, pops[:,1]  , 'b-', label='Consumer density')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics')
p.show()# To display the figure

  
# Save as a .pdf
f1.savefig('../results/LV_model.pdf') #Save figure

# Practical q1
# Make a new figure and save as a .pdf
f1 = p.figure()# Open an empty figure object 
p.plot(pops[:,0], pops[:,1], 'r-')# Add elements to the plot
p.grid()
p.xlabel('Resource density')
p.ylabel('Consumer density')
p.title('Consumer-Resource population dynamics')
p.show()# To display the figure

# Save as a .pdf
f1.savefig('../results/LV_model2.pdf') #Save figure


