import csv
import sys
import doctest

#Define function
def is_an_oak(name):
    # import ipdb; ipdb.set_trace()
    """ Returns True if name is starts with 'quercus' 

    >>> is_an_oak('Quercus robur') 
    True
    
    >>> is_an_oak('Fraxinus excelsior') 
    False

    >>> is_an_oak('Pinus sylvestris')
    False

    >>> is_an_oak('Quercus cerris')
    True

    >>> is_an_oak('Quercus petraea')
    True

    >>> is_an_oak('oak')
    False

    >>> is_an_oak('Quercuss robur')
    False

    """
    return name.lower().startswith('quercus ', 0, 8)

def main(argv): 
    """ Reads csv file and copies enteries which belong to the genus "quercus" into a new csv file"""
    # import ipdb; ipdb.set_trace()
    f = open('../data/TestOaksData.csv','r')
    g = open('../data/JustOaksData.csv','w')
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)
    oaks = set()
    for row in taxa:
        # import ipdb; ipdb.set_trace()
        print(row)
        print ("The genus is: ") 
        print(row[0] + '\n')
        if is_an_oak(row[0]):
            # import ipdb; ipdb.set_trace()
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0], row[1]])    

    return 0
    
if (__name__ == "__main__"):
    status = main(sys.argv)

    doctest.testmod()
