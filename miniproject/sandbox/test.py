import pandas as pd

# read data
data = pd.read_csv("../data/LogisticGrowthData.csv")
print("Loaded {} columns.".format(len(data.columns.values)))

print(data.columns.values)

pd.read_csv("../data/LogisticGrowthMetaData.csv")
data.head()

print(data.PopBio_units.unique()) #units of the response variable 

print(data.Time_units.unique()) #units of the independent variable 

data.insert(0, "ID", data.Species + "_" + data.Temp.map(str) + "_" + data.Medium + "_" + data.Citation)

print(data.ID.unique()) #units of the independent variable 7


data_subset = data[data['ID']=='Chryseobacterium.balustinum_5_TSB_Bae, Y.M., Zheng, L., Hyun, J.E., Jung, K.S., Heu, S. and Lee, S.Y., 2014. Growth characteristics and biofilm formation of various spoilage bacteria isolated from fresh produce. Journal of food science, 79(10), pp.M2072-M2080.']
data_subset.head()

# plot
import seaborn as sns # You might need to install this (e.g., pip install seaborn)
import matplotlib.pylab as pl

sns.lmplot("Time", "PopBio", data = data_subset, fit_reg = False) # will give warning - you can ignore it
pl.show()

# note: Attempted this code to wrangle data but acted weird- 
## cols = ['Time', "PopBio"]
# data.drop(data[data[cols] > 0][cols].index, inplace = True)
