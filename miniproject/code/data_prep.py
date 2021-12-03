##########################
# Data preperation script
##########################

# Import pandas and numpy
import pandas as pd
import numpy as np

# Read in data and metadata
data = pd.read_csv("../data/LogisticGrowthData.csv")
metadata = pd.read_csv("../data/LogisticGrowthMetaData.csv")

####################
# Create unique IDs
####################

# Create unique IDs by combining Species, Medium, Temp and Citation columns
data.insert(0, "ID", data.Species + "_" + data.Temp.map(str) + "_" + data.Medium + "_" + data.Citation)

# Repace unique IDs with numbers
data['ID'] = pd.factorize(data['ID'])[0]+1
print(data.ID.unique()) 

#################
# Data wrangling
################

# Check for any negative values ?
# (data.Time < 0).values.any() # Negative values present
# (data.PopBio < 0).values.any() # Negative values present

# # Check for any NAs?
# data.isnull().values.any() # No NA values

# # Check number of rows
# len(data.index)

# data.head()

# Remove rows with negative values 
data = data[data["Time"] > 0]
data = data[data["PopBio"] > 0]


# # Any negative values after wrangling?
# (data.Time < 0).values.any()
# (data.PopBio < 0).values.any()

# # Any NAs?
# data.isnull().values.any()

#####################
# Export to .CSV file
#####################

data.to_csv("../data/miniproject_data.csv")

