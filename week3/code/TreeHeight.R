# This function calculates heights of trees given distance of each tree 
# from its base and angle to its top, using  the trigonometric formula 
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees:   The angle of elevation of tree
# distance:  The distance from base of tree (e.g., meters)
#
# OUTPUT
# The heights of the tree, same units as "distance"

# Load in trees.csv as TreeData
TreeData <- read.csv("../data/trees.csv", stringsAsFactors = F)

# Make a new column and fill with NA values
TreeData$Rad <- NA

# define radians as degrees*pi/180
###################################
# for every index value in 1 to however many rows (1:nrow(TreeData)) in the dataset:
# For each iterable (each value) in the third column [i, 3], multiply by pi/180 and  then plug these values into "Rad" column [i,4]

# rferecing by index 
for (i in 1:nrow(TreeData)){
  
#  browser() ## use this breakpoint to see what each loop does
  TreeData[i,4] <- TreeData[i,3] * pi/180
} 

## referencing by name
# for (i in 1:nrow(TreeData)){
#   TreeData$Rad[i] <- TreeData$Angle.degrees[i] * pi/180
# } 
# 

# Alternative method- longer but a but more intuitive. This time names are assigned to the calculated values
##########################################################################################################
#for (i in 1:nrow(TreeData)){
# radians <- TreeData[i,3] * pi/180
# TreeData$Rad[i] <- radians
# } 

  
# define height as distance*ran(radians)

# For every 1 to x many number of rows of the "TreeData" dataset
# make new column called "Height.n", and for each iterable [i] in this new coloumn, take values from the second column of the "TreeData" dataset and multiply by tan(radians) and put into new column (Tree.Height.m)
for (i in 1:nrow(TreeData)){ 
TreeData$Tree.Height.n[i] <- TreeData[i,2] * tan(TreeData$Rad[i])
}
#note: should make column first, but can also just use $ to add new column 

############
# longer way
############
#for (i in (TreeData$Distance.m)){ 
#  height <- i * tan(radians)
#  TreeData$Tree.Height.n[i] <- height
#} 

# Export TreeDta as a .csv and save in results directory 
write.csv(TreeData, "../results/TreeHts.csv")

# Script complete
print("Script complete! :)")

  
  

