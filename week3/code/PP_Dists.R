# load data
MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")

# Convert prey mass in kg to grams
# which" allows to check for a condition and return index value where condition is fulfilled 
MyDF$Prey.mass[which(MyDF$Prey.mass.unit == "mg")] <- MyDF$Prey.mass[which(MyDF$Prey.mass.unit == "mg")]/1000

# # Also can do in a for loop
#  for (i in which(MyDF$Prey.mass.unit == "mg")) { # for every observation with the index value specified (where Prey.mass.unit == "mg")
#   MyDF$Prey.mass[i] <- MyDF$Prey.mass[i] /1000 # overwrite DF$Prey.mass with converted values, i.e. prey mass (prey.mass) which is given in mg (prey.mass.unit) divided by 1000
# }

# Make a new column ("Size_ratio") to the DF
MyDF$Size_ratio <- NA

# Make a loop which calculates the size ratios of prey mass over predator mass
for (i in 1:nrow(MyDF)){ # for i in each row of the DF
  MyDF$Size_ratio <- MyDF$Prey.mass/MyDF$Predator.mass # Divide prey mass by predator mass, and populate the new column "Size_ratio" with these values
}

# #unique(MyDF$Type.of.feeding.interaction) #check feeding types

# create subsets for each feeding type
predacious_piscivorous <- subset(MyDF, Type.of.feeding.interaction == "predacious/piscivorous")
predacious  <- subset(MyDF, Type.of.feeding.interaction == "predacious")
piscivorous <- subset(MyDF, Type.of.feeding.interaction == "piscivorous")
planktivorous <- subset(MyDF, Type.of.feeding.interaction == "planktivorous")
insectivorous <- subset(MyDF, Type.of.feeding.interaction == "insectivorous")

# Make boxplots to show distribution of log(body mass) of predators in grams 
pdf("../results/Pred_Subplots.pdf", # Open blank pdf page using a relative path
    11.7, 8.3) # These numbers are page dimensions in inches
par(mfcol=c(2,3)) #initialize multi-paneled plot
par(mfg = c(1,1)) # specify which sub-plot to use first 
boxplot(log(predacious$Predator.mass) , # make boxplot of the log of "predacious" predator mass
        xlab = "Predacious", ylab = "log(Predator Mass) g",
        main = "Predator mass",
        col = rgb(1,0,0.5,0.5)) # customise colour (red, green, blue, transparency). This makes a nice pink colour
par(mfg = c(1,2)) # Second sub-plot
boxplot(log(piscivorous$Predator.mass) , # make boxplot of the log of "piscivorous" predator mass
        xlab = "Piscivorous", ylab = "log(Predator Mass) g",
        main = "Predator mass",
        col = rgb(0.3,0,1,0.4)) # customise colour (red, green, blue, transparency). This makes a nice lavender colour
par(mfg = c(1,3)) # Second sub-plot
boxplot(log(predacious_piscivorous$Predator.mass) , # make boxplot of the log of "predacious/piscivorous" predator mass
        xlab = "Predacious/piscivorous", ylab = "log(Predator Mass) g",
        main = "Predator mass",
        col = rgb(0,0.3,1,0.5)) # customise colour (red, green, blue, transparency). This makes a nice blue colour
par(mfg = c(2,1)) # Second sub-plot
boxplot(log(planktivorous$Predator.mass) , # make boxplot of the log of "Planktivorouss" predator mass
        xlab = "Planktivorous", ylab = "log(Predator Mass) g",
        main = "Predator mass",
        col = rgb(0.2,1,0,0.5)) # customise colour (red, green, blue, transparency). This makes a nice mint green colour
par(mfg = c(2,2)) # Second sub-plot
boxplot(log(insectivorous$Predator.mass) , # make boxplotof the log of "Insectivorous" predator mass
        xlab = "Insectivorous", ylab = "log(Predator Mass) g",
        main = "Predator mass",
        col = "khaki1") #customise colour (red, green, blue, transparency). This makes a pastel yellow 
dev.off() 

# Make boxplots to show distribution of log(body mass) of prey in grams 
pdf("../results/Prey_Subplots.pdf", # Open blank pdf page using a relative path
    11.7, 8.3) # These numbers are page dimensions in inches
par(mfcol=c(2,3)) #initialize multi-paneled plot
par(mfg = c(1,1)) # specify which sub-plot to use first 
boxplot(log(predacious$Prey.mass) , # make boxplot of the log of "predacious" prey mass
        xlab = "Predacious", ylab = "log(Prey Mass) g",
        main = "Prey mass",
        col = rgb(1,0,0.5,0.5)) # customise colour (red, green, blue, transparency). This makes a nice pink colour
par(mfg = c(1,2)) # Second sub-plot
boxplot(log(piscivorous$Prey.mass) , # make boxplot of the log of "piscivorous" prey mass
        xlab = "Piscivorous", ylab = "log(Prey Mass) g",
        main = "Prey mass",
        col = rgb(0.3,0,1,0.4)) # customise colour (red, green, blue, transparency). This makes a nice lavender colour
par(mfg = c(1,3)) # Second sub-plot
boxplot(log(predacious_piscivorous$Prey.mass) , # make boxplot
        xlab = "Predacious/piscivorous", ylab = "log(Prey Mass) g",
        main = "Prey mass",
        col = rgb(0,0.3,1,0.5)) # customise colour (red, green, blue, transparency). This makes a nice blue colour
par(mfg = c(2,1)) # Second sub-plot
boxplot(log(planktivorous$Prey.mass) , # make boxplot of the log of "planktivorous" prey mass
        xlab = "Planktivorous", ylab = "log(Prey Mass) g",
        main = "Prey mass",
        col = rgb(0.2,1,0,0.5)) # customise colour (red, green, blue, transparency). This makes a nice mint green colour
par(mfg = c(2,2)) # Second sub-plot
boxplot(log(insectivorous$Prey.mass) , # make boxplot of the log of "insectivorous" prey mass
        xlab = "Insectivorous ", ylab = "log(Prey Mass) g",
        main = "Prey mass",
        col = "khaki1") # customise colour (red, green, blue, transparency). This makes a pastel yellow 
dev.off() 

# Make boxplots to show distribution of size ratios of prey mass over predator 
pdf("../results/SizeRatio_Subplots.pdf", # Open blank pdf page using a relative path
    11.7, 8.3) # These numbers are page dimensions in inches
par(mfcol=c(2,3)) #initialize multi-paneled plot
par(mfg = c(1,1)) # specify which sub-plot to use first 
boxplot(log(predacious$Size_ratio), # make boxplot of the log of "predacious" prey mass
        xlab = "Predacious", ylab = "Size ratio",
        main = "Size ratio of prey mass over predator mass ",
        col = rgb(1,0,0.5,0.5)) # customise colour (red, green, blue, transparency). This makes a nice pink colour
par(mfg = c(1,2)) # Second sub-plot
boxplot(log(piscivorous$Size_ratio), # make boxplot of the log of "piscivorous" prey mass
        xlab = "Piscivorous", ylab = "Size ratio",
        main = "Size ratio of prey mass over predator mass",
        col = rgb(0.3,0,1,0.4)) # customise colour (red, green, blue, transparency). This makes a nice lavender colour
par(mfg = c(1,3)) # Second sub-plot
boxplot(log(predacious_piscivorous$Prey.mass), # make boxplot
        xlab = "Predacious/piscivorous", ylab = "Size ratio",
        main = "Size ratio of prey mass over predator mass ",
        col = rgb(0,0.3,1,0.5)) # customise colour (red, green, blue, transparency). This makes a nice blue colour
par(mfg = c(2,1)) # Second sub-plot
boxplot(log(planktivorous$Size_ratio), # make boxplot of the log of "planktivorous" prey mass
        xlab = "Planktivorous", ylab = "Size ratio",
        main = "Size ratio of prey mass over predator mass ",
        col = rgb(0.2,1,0,0.5)) # customise colour (red, green, blue, transparency). This makes a nice mint green colour
par(mfg = c(2,2)) # Second sub-plot
boxplot(log(insectivorous$Size_ratio), # make boxplot of the log of "insectivorous" prey mass
        xlab = "Insectivorous ", ylasb = "Size ratio",
        main = "Size ratio of prey mass over predator mass ",
        col = "khaki1") # customise colour (red, green, blue, transparency). This makes a pastel yellow 
dev.off() 

# Making a df with results 
##########################
# make a vector of mean log prey mass
# note: tapply function (tapply(x,y,z)) allows functions (z) to be applied to some value (x) categorised by some other value (y)
Mean_log_prey_mass <- tapply(log(MyDF$Prey.mass), MyDF$Type.of.feeding.interaction, mean)

# make a vector of median log prey mass
Median_log_prey_mass <- tapply(log(MyDF$Prey.mass), MyDF$Type.of.feeding.interaction, median)

# make a vector of mean log predator mass
Mean_log_pred_mass <-tapply(log(MyDF$Predator.mass), MyDF$Type.of.feeding.interaction, mean)
  
# make a vector of median log predator mass
Median_log_pred_mass <- tapply(log(MyDF$Predator.mass), MyDF$Type.of.feeding.interaction, median)
  
# make a vector of mean  size ratio
Mean_size_ratio <- tapply(log(MyDF$Size_ratio), MyDF$Type.of.feeding.interaction, mean)
  
# make a vector of median size ratio
Median_size_ratio <- tapply(log(MyDF$Size_ratio), MyDF$Type.of.feeding.interaction, median)

# Make a dataframe where each vector made above is a column 
PP_Results <-data.frame(Mean_log_prey_mass, Median_log_prey_mass, Mean_log_pred_mass, Median_log_pred_mass, Mean_size_ratio, Median_size_ratio)

# note to self: wrangle data when theres time 

# Export results as a .csv file
write.csv(PP_Results, "../results/PP_Results.csv")

############
#rough work
############
# try with density plots 
# Open ggplot 
# ######
# library(ggplot2)
# 
# qplot(log(prey.mass), data = predacious, geom =  "density", 
#       fill = Type.of.feeding.interaction, 
#       alpha = I(0.5))
# 
# qplot(Size_ratio, data = predacious, geom =  "density", 
#       fill = Type.of.feeding.interaction, 
#       alpha = I(0.5))
