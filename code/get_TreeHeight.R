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

# Load in the dataset, given as an commad line argument 
args<-commandArgs(TRUE)

Data<- read.csv(paste0("../data/", args, ".csv"), stringsAsFactors = F)


# Make a new column and fill with NA values
Data$Rad <- NA

# define radians as degrees*pi/180
###################################
# for each row (1:nrow(TreeData)) in the dataset:
# For each observation in the third column [i, 3], multiply by pi/180 and  then plug these values into "Rad" column [i,4]
for (i in 1:nrow(Data)){
  
  #  browser() ## use this breakpoint to see what each loop does
  Data[i,4] <- Data[i,3] * pi/180
} 

# define height as distance*ran(radians)

# For every 1 to x many number of rows of the "TreeData" dataset
# make new column called "Height.n", and for each iteration, take values from the second column of the the dataset and multiply by tan(radians) and put into new column (Tree.Height.m)
for (i in 1:nrow(Data)){ 
  Data$Tree.Height.n[i] <- Data[i,2] * tan(Data$Rad[i])
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
write.csv(Data, paste0("../results/", args, "_treeheight.csv"))

# Script complete
print("Script complete! :)")



# Note- this works if you strip extension (.csv) and file path (../results) from  command line argument,  but check if this is okay or do we need to strip extension and filepath from inside script. 
