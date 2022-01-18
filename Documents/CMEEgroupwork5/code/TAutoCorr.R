rm(list=ls()) # remove global environment
dev.off()
load("../data/KeyWestAnnualMeanTemperature.RData") # load the annual temperature dataset
ls()
new_ats <- data.frame(ats[1:nrow(ats)-1, ], ats[2:nrow(ats), ]) # create a new data frame to calculate the correlation coefficient between successive years
cc <- cor(x = new_ats[ ,2], y = new_ats[ ,4], use = "everything", method = "pearson")
# compute the appropriate correlation coefficient between successive years
n <- 10000
rcc <- c()
for (i in 1:n){
  new_ats[,4] <- sample(new_ats[,4])
  # repeat this calculation 200 times, each time randomly permuting the time series
  temp <- cor(x = new_ats[ ,2], y = new_ats[ ,4], use = "everything", method = "pearson")
  # recalculate the correlation coefficient and store it in the "temp" variable
  rcc <- append(rcc, temp) # append "temp" variable to rcc
} 

count <- 0

for (j in rcc){
  if(j > cc){ # if any element in rcc is greater than cc, count plus one
    count <- count + 1
  }
} 
p_value <- count / n # calculate the fraction of the random correlation coefficients greater than the previous one


print(paste("The approximate, asymptotic p-value is", p_value)) # print the p-value
hist(rcc, xlab = "Correlation Coefficient", xlim = c(-0.4, 0.4), ylim = c(0, 2000), col = "gold", main = "Histogram of correlation coefficients")

