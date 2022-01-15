rm(list = ls())

### Load the RData file ###
load("../data/KeyWestAnnualMeanTemperature.RData")
plot(ats)

firstYear <- c()
secondYear <- c()

### pair the years ###
for(i in 1:(length(ats$Year)-1)){
  firstYear <- append(firstYear,ats$Temp[i])
  secondYear <- append(secondYear,ats$Temp[i+1])
}

correlationCoff <- cor(firstYear,secondYear)

tempVect <- ats$Temp
correlationCoffVector <- c()

### iterate for a significant amount of times ###
for (i in 1:10000){
  tempVect <- sample(tempVect,length(ats$Year), replace = FALSE)
  firstYear <- c()
  secondYear <- c()
  for(j in 1:(length(tempVect)-1)){
    firstYear <- append(firstYear,tempVect[j])
    secondYear <- append(secondYear,tempVect[j+1])
  }
  correlationCoffVector <- append(correlationCoffVector,cor(firstYear,secondYear))
}

### Compare the correlation coefficient ###
correlationCoffBoolean <- correlationCoffVector[correlationCoffVector>correlationCoff]
fractionCorrCoff <- length(correlationCoffBoolean) / 10000
print (fractionCorrCoff)
