import scipy as sc
import scipy.stats


sc.stats.norm.rvs(size = 10)

np.random.seed(1234)
sc.stats.norm.rvs(size = 10)

sc.stats.norm.rvs(size=5, random_state=1234)

sc.stats.randint.rvs(0, 10, size = 7)

sc.stats.randint.rvs(0, 10, size = 7, random_state=1234)

sc.stats.randint.rvs(0, 10, size = 7, random_state=3445) # a different seed

# using scipy.integrate
import scipy.integrate as integrate

y = np.array([5, 20, 18, 19, 18, 7, 4]) # The y values; can also use a python list here

import matplotlib.pylab as p

p.plot(y)

# trapezoidal rule

area = integrate.trapz(y, dx = 2)
print("area =", area)

area = integrate.trapz(y, dx = 1)
print("area =", area)

area = integrate.trapz(y, dx = 3)
print("area =", area)

#simpsons rule
area = integrate.simps(y, dx = 2)
print("area =", area)

area = integrate.simps(y, dx = 1)
print("area =", area)

area = integrate.simps(y, dx = 3)
print("area =", area)


