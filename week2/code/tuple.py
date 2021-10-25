birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
        )

# Birds is a tuple of tuples of length three: latin name, common name, mass.
# write a (short) script to print these on a separate line or output block by species 
# 
# A nice example output is:
# 
# Latin name: Passerculus sandwichensis
# Common name: Savannah sparrow
# Mass: 18.7
# ... etc.

# Hints: use the "print" command! You can use list comprehensions!

# On new lines, print "Latin name" (the first element of each tuple), "common name" (the second element of each tuple) and "body mass" (third element of each tuple)
# The join() method takes all items in an iterable (i.e, a list, string or tuple), which are seperated by a separator, and joins them into one combined string. 
# using an "f" in front of a string (i.e., f string) means all the variables inside the curly brackets are read and replaced with their value (e.g., {birds[i][1]}= the second element (common name) of each tuple in "birds")
# len() returns the number of items in an interable object (lists, strings or tuples)
print('\n...\n'.join([f"Latin name: {birds[i][0]}\ncommon name: {birds[i][1]}\nbody mass: {birds[i][2]}" for i in range(len(birds))]))


# personal notes
###########################
# print latin name, common name and body mass seperately 

# Latin_name, common_name, body_mass = zip(*birds)
# print(Latin_name)
# print(common_name)
# print(body_mass)

# ask about how to get this to work

# print(f"Latin name:{birds[0]}\nCommon name:{birds[1]}\nBody mass:{birds[2]}".format(birds[0],birds[1],birds[2]))