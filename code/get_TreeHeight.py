"""get_TreeHeight is a python script that calculates tree heights"""

<<<<<<< HEAD
__appname__ = 'get_TreeHeight.py'
__author__ = 'Peter Zeng (Email: pz221@ic.ac.uk)'
=======
__appname__ = 'get_TreeHeight.py' 
__author__ = 'Peter (Guancheng) Zeng (pz221@ic.ac.uk), Kate Griffin (kate.griffin21@imperial.ac.uk), Junyue Zhang (jz1621@ic.ac.uk), Kayleigh Greenwood (Kayleigh.Greenwood21@ic.ac.uk)'
>>>>>>> 018a50b17243a8b2c0adeea902645bafee4e208c
__version__ = '0.0.1'


### import ###
import sys
import pandas
import numpy

treeData = pandas.read_csv("../data/" + sys.argv[1] + ".csv")

### to calculate the height for every rows ###
for row in treeData:
    treeData["Tree.Height.m"] = treeData["Distance.m"] * numpy.tan(treeData["Angle.degrees"] * numpy.pi/180)

### output the data to the tree data csv
<<<<<<< HEAD
treeData.to_csv("../results/" + sys.argv[1] + "_TreeHts_py.csv", sep= ',',index=False)
=======
treeData.to_csv("../results/" + sys.argv[1] + "_TreeHts_py.csv", sep= ',',index=False)
>>>>>>> 018a50b17243a8b2c0adeea902645bafee4e208c
