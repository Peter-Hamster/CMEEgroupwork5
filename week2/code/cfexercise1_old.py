# divides x in half
def foo_1(x):
    return x ** 0.5

# only returns higher value of 2 numbers
def foo_2(x, y):
    if x > y:
        return x
    return y

# puts 3 numbers in order from lowest to highest
def foo_3(x, y, z):
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
def foo_3(x, y, z):
    if x > y:
        y,x = x,y
    if y > z:
        z,y = y,z
    return [x, y, z]


# 1*i in a set range over x times
def foo_4(x):
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

# calculates factorial
def foo_5(x): # a recursive function that calculates the factorial of x
    if x == 1:
        return 1
    return x * foo_5(x - 1)
     

# calculate factorial
def foo_6(x): # Calculate the factorial of x in a different way
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto
    