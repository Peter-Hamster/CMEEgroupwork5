# "birds" is a variable with 5 tuples. Each tuple has three elements (Latin names, common names and body mass)
birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 

# list all latin names from "birds" list (i.e., i[0]- the first element from each tuple in the "birds" list)
latin_names = [i[0] for i in birds] 
print (latin_names)

# List common names from "birds" list (i.e., i[1]- the second element from each tuple)
common_names = [i[1] for i in birds] 
print (common_names)

# Lists body masses from "birds" list (i.e., i[2]- the third element from each tuple)
body_mass = [i[2] for i in birds] 
print (body_mass)


# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

# Create a loop which returns latin names
# For every tuple in the birds list, print the first element [0]
for bird in birds:
    print(bird[0])

## Create a loop which returns common names
# For every tuple in the birds list, print the second element [1]
for bird in birds:
    print(bird[1])

## Create a loop which returns body mass
# For every tuple in the birds list, print the third element [2]
for bird in birds:
    print(bird[2])

############################
# Alternative solutions
############################
## same as first solution but first prints out each tuple and then print the first element ("latin name")

# for bird in birds:
#     print(f"bird = {bird}")
#     print(f"latin name = {bird[0]}")


## define "latin_names" as a function, whereby for every tuple in birds, return the first value [0]. Useful when using more complicated data (e.g. multiple lists of birds)

# def latin_names(bird_list):
#     for bird in bird_list:
#         print(bird[0])


# A nice example out out is:
# Step #1:
# Latin names:
# ['Passerculus sandwichensis', 'Delichon urbica', 'Junco phaeonotus', 'Junco hyemalis', 'Tachycineata bicolor']
# ... etc.
 