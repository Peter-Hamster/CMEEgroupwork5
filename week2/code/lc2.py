# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.

# If rainfall in mm (i.e., the second element of each tuple [1]) in "rainfall" is greater than 100mm, return value
rain_more_than_100mm = [i for i in rainfall if i[1] > 100] 
print (rain_more_than_100mm)


# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

# If  rainfall in mm (i.e., the second element of each tuple [1]) in "rainfall" is less than 50mm, then print month (i.e., the first element of each tuple [0])
lesss_than_50m = [i[0] for i in rainfall if i[1] < 50] 
print (lesss_than_50m)


# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

# Create a loop which returns values for rainfall in mm (i.e., the second element of each tuple [1]) and month (i.e., the first element of each tuple [0]) if rainfall is greater than 100mm.
for i in rainfall:
    if i[1] > 100:
        print(i)

# Create a loop which returns values for month (i.e., the first element of each tuple [0]) if rainfall in mm (i.e., the second element of each tuple [1]) is less than 50mm.
for i in rainfall:
    if i[1] < 50:
        print(i[0])

# A good example output is:
#
# Step #1:
# Months and rainfall values when the amount of rain was greater than 100mm:
# [('JAN', 111.4), ('FEB', 126.1), ('AUG', 140.2), ('NOV', 128.4), ('DEC', 142.2)]
# ... etc.

