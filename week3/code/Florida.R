rm(list=ls())

load("../data/KeyWestAnnualMeanTemperature.RData")

class(ats)

head(ats)

plot(ats)

#reassign Year as a character 
as.character(ats$Year)

# Calculate the Pearson's coefficient
coeff <- cor(x= ats$Year, y=ats$Temp, method = "pearson")

#set seed for reproducible results
set.seed(2349)

# no. of observations in ats dataset 
n <- length(ats$Temp)

# No. of permutation samples 
P <- 1000

# Initialise an empty matrix to store permutation data
PermSamp <- matrix(0, nrow=n, ncol=P)

# Make permutation samples using  loop
# Makes 1000 (1:P) permutations of the data and store each one 
# replace= FALSE: sampling without replacement allows for a reordering (permutation) of the data

for (i in 1:P){ # Each loop is a permutation 
  PermSamp[,i] <- sample(ats$Temp, size=n, replace=FALSE) # for each column [,i], resample (reorders) the temperature values from the original datasert. The number of rows is equal to n (the number of variables in the original dataset)

}

# make an empty vector  to store coefficients
Perm.test.stat <-  rep(0, P)

# Loop through and calculate the test statistics 
# calculates correlation between permutated temp values and "Year"..
for (i in 1:P){
  Perm.test.stat[i]<-cor(x= ats$Year, y= PermSamp[,i], method= "pearson") #for each column, 
}

# x = ats$year: this calculates the coefficient between years (in its original order in ats dataset) with each permutation (i.e. each randomly shuffled column of temp values)
# each coeff calculated from the step above is populated into an empty matrix 

# calculate fraction of permuted coefficients were greater than the originally calculated 
# sum function will count the number of "TRUE" values (where the coeff calculated for permutation test is greater than the originally calculated)
perm_coeff <- sum(Perm.test.stat > coeff)

# Calculate what fraction of the random correlation coefficients were greater than the observed one (i.e. p-value)
pvalue <- perm_coeff/P

# Graph distribution of permutated coefficients 
hist(Perm.test.stat, 
     breaks = 50,
     main= "Distribution of permuted coefficients", 
     xlab = "Correlation coefficient", #between temp and years
     ylab="frequency",
     xlim = c(-0.4,0.6),
     col="pink2")
abline(v=0.5, col="blue", lwd=2)
text(0.3,50,"Observed correlation coefficient", col = "black")

#Interpret and present the results: Present your results and their interpretation in a pdf document written in latex (include the the document’s source code in the submission) (Keep the writeup, including any figures, to one A4 page).



# reference video (good explanation of permutation tests in R)
# https://youtu.be/xRzEWLfEEIA

