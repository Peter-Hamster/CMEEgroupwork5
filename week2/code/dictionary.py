taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa.
# 
# An example output is:
#  
# 'Chiroptera' : set(['Myotis lucifugus']) ... etc.
#  OR,
# 'Chiroptera': {'Myotis lucifugus'} ... etc

# orders = set([i for i in Rodentia])
# print(orders)
# put lists in for loop for it loops through the orders

# Create a list of "Rodentia" species
Rodentia= []
for i in taxa:
    if i[1] == "Rodentia":
        print(i)
        Rodentia.append(i[0])

# Create a list of "Chiroptera" species
Chiroptera= []
for i in taxa:
    if i[1] == "Chiroptera":
        print(i)
        Chiroptera.append(i[0])

# Create a list of "Afrosoricida" species
Afrosoricida= []
for i in taxa:
    if i[1] == "Afrosoricida":
        print(i)
        Afrosoricida.append(i[0])

# Create a list of "Carnivora" species
Carnivora= []
for i in taxa:
    if i[1] == "Carnivora":
        print(i)
        Carnivora.append(i[0])

# Create a dictionary of orders with a list of species (created in previous for loops)
Orders_and_species = {"Carnivora":Carnivora, "Afrosoricida": Afrosoricida, "Chiroptera":Chiroptera, "Rodentia":Rodentia}
print(Orders_and_species)