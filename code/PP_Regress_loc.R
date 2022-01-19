# read in data
MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")

# Make linear regression model 
#dlpy- use to make function and apply tosubsets or make individual subsets 

#open plyr
require(plyr)
library(plyr)

# dlply Makes a list (lm_results) from a dataframe (MyDF)
# Measure the relationship between prey and predator mass based off of types of feeding interaction, predator life stage and location
# predator.mass (x) ~ Prey.mass (y): x is predicted by y
lm_results<- dlply(MyDF,.(Type.of.feeding.interaction, Predator.lifestage, Location), function(x) lm(Predator.mass~Prey.mass, data = x)) 


#notes on how to find the right index values for r^2, p.value, slope, intercept, f-statistic
###########################################################
#> x <- lm_results[[1]] #run to rename lm_results as x
# > summary(x)$fstatistic #run to find summary of f-statistic (there is only one value so no need to index
#summary(x)$coefficient # this is where we will find the p-value ()Pr(>|t|) of prey.mass in output), slope (estimate of prey.mass) and intercept (estimate of intercept)
# summary(x)$coefficient[1] #this is the exact value we need (in this case, intercept), so we will add this to the function below 

# Use ldply to make list a DF
lm_df <- ldply(lm_results, function(x){
  r2 <- summary(x)$r.squared[1]
  p.value <- summary(x)$coefficients[8]
  slope <- summary(x)$coefficients[2]
  intercept <- summary(x)$coefficients[1]
  data.frame(r2, intercept, slope, p.value)
})

# need to make a new function for f stat as this has NA values
F.stat<- ldply(lm_results, function(x) summary(x)$fstatistic[1])

# merge lm_df with F.stat
lm <- merge(lm_df, F.stat, by = c("Type.of.feeding.interaction", "Predator.lifestage", "Location"))

# change column name to f-stat
names(lm)[8] <- "Fstat" # 7th column is just called value, so change to "Fstat

write.csv(lm, "../results/PP_Regress_loc_results.csv")

