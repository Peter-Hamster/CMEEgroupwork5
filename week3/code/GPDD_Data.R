# load "maps" package
library(maps)

# Loads the GPDD data
load("/home/kate121/Documents/CMEECourseWork/week3/data/GPDDFiltered.RData")

# Create a world map
map('world')

# Superimpose all the locations from the GPDD dataframe on the map 

points(x = gpdd$lon, y= gpdd$lat, col = "Red")

               
# Potential biases?
# The data is biased towards the northern hemisphere (esp. North America and Europe). This may be because more data has been sampled from these regions. 
