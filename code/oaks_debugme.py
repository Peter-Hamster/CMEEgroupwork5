"""oaks_debugme.py is a python script. This script is aimed to find out the oak in the list of species"""

__appname__ = 'oaks_debugme.py'
__author__ = 'Peter Zeng (Email: pz221@ic.ac.uk)'
__version__ = '0.0.1'

import csv
import sys
import doctest

#Define function
def is_an_oak(name):

    """Returns True if name is starts with 'quercus'
    >>> is_an_oak("Quercus")
    True
    >>> is_an_oak("Pinus")
    False
    >>> is_an_oak("Fagus sylvatica")
    False
    >>> is_an_oak("Quercuss")
    False
    """

    return (name.lower().startswith('quercus') and len(name) == 7)

def main(argv): 

    """The main function which process the file and utilize the is_an_oak function"""

    f = open('../data/TestOaksData.csv','r')
    g = open('../data/JustOaksData.csv','w')
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)
    oaks = set()

    # for row in taxa:
    #     print(is_an_oak(row[0]))

    csvwrite.writerow(["Genus", "species"])   

    for row in taxa:
        if row[0] == "Genus":
            continue    
        print(row)
        print ("The genus is: ") 
        print(row[0] + '\n')
        if is_an_oak(row[0]):
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0], row[1]])    

    return 0

if (__name__ == "__main__"):
    status = main(sys.argv)

doctest.testmod()
