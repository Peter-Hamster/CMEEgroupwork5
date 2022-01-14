rm(list=ls()) # remove global environment
load("../data/KeyWestAnnualMeanTemperature.RData") # load the annual temperature dataset
ls()
new_ats <- data.frame(ats[1:nrow(ats)-1, ], ats[2:nrow(ats), ])
cc <- cor(x = new_ats[ ,2], y = new_ats[ ,4], use = "everything", method = "pearson")
# compute the appropriate correlation coefficient between years and Temperature
n <- 200
rcc <- c()
for (i in 1:n){
  new_ats <- new_ats[sample(nrow(new_ats)), ]
  # repeat this calculation 100 times, each time randomly reshuffling the temperatures
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
p_value <- count / n # calculate the fraction of the random correlation coefficients greater than the observed one


print(paste("The approximate, asymptotic p-value is", p_value)) # print the p-value

