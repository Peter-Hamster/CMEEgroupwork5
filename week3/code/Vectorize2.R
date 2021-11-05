# Runs the stochastic Ricker equation with gaussian fluctuations
# makes a model which simulates  population density over 100 years 

rm(list = ls()) # Clears working environment 

stochrick <- function(p0 = runif(1000, .5, 1.5), r = 1.2, K = 1, sigma = 0.2,numyears = 100) # makes a function with arguments: p0 (1000 randomly generated numbers between 0.5 to 1.5), r, K, sigma
{

  N <- matrix(NA, numyears, length(p0))  #initialize empty matrix (each row is a year (from 1 to 100 years- which was defined in the function- numyears=100) each column is a population)
# NA: value applying to matrix 
  # numyears- defined as 100 in function 
  # length(p0)- not a simple value, so must get the length (1000) to specify how many columns to add
  
  N[1, ] <- p0 # takes 1000 randomly generated numbers (made with "runif" function) and places into the first row of the empty matrix

  # for (pop in 1:length(p0)) { #loop through the populations (p0)
 

    for (yr in 2:numyears){ # loop through each year (row)) after the second year (2:numyears) 
      # Do not want to populate the first row because it has already been filled in (N[1,]<- p0)
      # For each loop, apply calculations (take value from previous year, i.e. take values from year 2 and apply calculations on those values to fill in year 3)
      
      

     N[yr, ] <- N[yr-1, ] * exp(r * (1 - N[yr - 1, ] / K) + rnorm(length(p0), 0, sigma)) # add one fluctuation from normal distribution
     # removed "pop" from index (previously "N[yr, pop]")- now that column is not specified, it will apply calculations to every column 
     # changed rnorm(1,0, sigma) to rnorm(length(p0), 0, sigma)- so rather than calculate the normal distribution for each observation, calculates the normal distribution for all 1000 populations (length(p0))
     
    
     }
  
  
 return(N) # return gives back values which were worked out within the function

}

stochrick()

# Edit: makes a for loop which loops through each year (or row) rather than individual cell

# Now write another function called stochrickvect that vectorizes the above to
# the extent possible, with improved performance: 

# print("Vectorized Stochastic Ricker takes:")
# print(system.time(res2<-stochrickvect()))

### personal notes###
# to add row eg
# i <-1 #sets i as 1
# pop <- N[i,] # defines pop as the ith row (will be "1" for first loop) of the matrix
# i+1 # adds new row: after first loop (1st row) adds +1 to i, so when it loops again it will go through the second row 
