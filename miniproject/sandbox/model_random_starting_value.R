####################
# Fitting the models
####################
rm(list = ls())
graphics.off()
set.seed(342)

require(minpack.lm)
require(plyr)
library(rollRegres)

# Load in data
df <- read.csv("../data/miniproject_data.csv")

##########################
# phenomenological models
##########################

# A function which subsets data by unique ID and then runs a quadratic model on each subset
quadratic_results<- dlply(df,.(ID), function(x) lm(PopBio ~ poly(Time,2), data= x)) # dlply takes a dataframe, performs a set of operations (i.e., runs the model) on the data (in this case- runs the model on each subset) and returns a list of statistical values

quadratic_df <- ldply(quadratic_results, function(x){ # ldply takes a list and returns a dataframe with specified values
  AIC_quadratic <- AIC(x) # Calculates AIC
  BIC_quadratic <- BIC(x) # Calculates BIC
  data.frame(AIC_quadratic, BIC_quadratic) # Create dataframe
})

# A function which subsets data by unique ID and then runs a cubic polynomial model on each subset
cubic_results<- dlply(df,.(ID), function(x) lm(PopBio ~ poly(Time,2), data= x))

cubic_df <- ldply(cubic_results, function(x){
  AIC_quadratic <- AIC(x)
  BIC_quadratic <- BIC(x)
  data.frame(AIC_quadratic, BIC_quadratic)
})


##############
# Mechanistic
#############
# Rolling regression to find r max
#################################

# Note: r max is the maximum growth rate. The point of a rolling regression is to calculate the growth rate (i.e. the gradient) at different intervals of time. The interval with the steepest gradient (or the highest coeff value) represents the most accelerated growth rate

# Create subsets based off unique IDs
rmax_df <- data.frame(rmax=rep(NA, length(unique(df$ID)))) # Create an empty dataframe with column "rmax" and fill with NA values 

# Rolling regression
for (i in 1:length(unique(df$ID))){ # Loop through unique IDs
  subs <- subset(df, ID==i) # Create subset for each unique ID
  
  if (length(subs$ID) < 6 ){ # If there are less than 6 observations in the subset..
    rmax_df$rmax[i] <- NA # Define as an NA value
  }
  
  else{ # Otherwise...
    
    roll <- roll_regres(PopBio ~ Time, subs, width = 6, do_downdates = TRUE) # Perform a rolling regression on each subset. Set window size to 6 (as anything smaller will return an error)
    roll_data <- data.frame(roll$coefs) # Create a dataframe and fill it with coefficient values (i.e. the gradient) calculated by the rolling regression
    r_max <- max(roll_data$Time, na.rm = TRUE) # Find the maximum value calculated above (for each subset). i.e. r_max
    
    rmax_df$rmax[i] <- r_max # Populate the rolling_reg_df with each r_max value for every subset
  }}

# Logistic model 
################

# Define the logistical model as a function with 3 parameters: r max (maximum growth rate), K (carrying capacity) and N0 (initial population)
logistic_model <- function(t, r_max, K, N_0){ # The classic logistic equation
  return(N_0 * K * exp(r_max * t)/(K + N_0 * (exp(r_max * t) - 1)))
}

# Create empty lists
AIC_logistic <- c()
BIC_logistic <- c()

# Fit logistic model with starting parameters 
for (i in 1:length(unique(df$ID))){ # loop through unique IDs
  subs <- subset(df, ID==i) # create subsets based off unique IDs
  
  # Set parameters
  N_0_start <- min(subs$PopBio) # lowest population size
  K_start <- max(subs$PopBio) # highest population size
  r_max_start <- 0.0001
  
  # Fit model
  fit_logistic <- try(nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), subs, # fit model using NLLS
                            list(r_max=r_max_start, N_0 = N_0_start, K = K_start)),silent = T)
  
  AIC_logistic[i] <- AIC(fit_logistic) # Calculate AIC
  BIC_logistic[i] <- BIC(fit_logistic) # Calculate BIC  
  logistic_df <- data.frame(AIC_logistic, BIC_logistic) # Create data frame with AIC and BIC values
}

# Make a DF with all AIC and BIC values produced by the models
logistic_df$ID = unique(df$ID) # Add column "ID" to logistic_df
model_stats <- merge(cubic_df, quadratic_df, by = "ID" )
model_stats <- merge(model_stats, logistic_df, by = "ID")

# Export AIC and BIC results as a .CSV file
write.csv(model_stats, "../data/model_stats.csv")

###################
# Check for errors 
##################
# logistic model 
##################
# for (i in 1:length(unique(df$ID))){ 
#   print(i)
#   tryCatch(
#   expr = {subs <- subset(df, ID==i) # create subsets based off unique IDs
#   N_0_start <- min(subs$PopBio) # lowest population size
#   K_start <- max(subs$PopBio) # highest population size
#   r_max_start <- 0.0001
#   
#   fit_logistic <- nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), subs, # fit model using NLLS
#                         list(r_max=r_max_start, N_0 = N_0_start, K = K_start))
#   
#   AIC_logistic[i] <- AIC(fit_logistic) # Calculate AIC
#   BIC_logistic[i] <- BIC(fit_logistic) # Calculate BIC  
#   logistic_df <- data.frame(AIC_logistic, BIC_logistic) },
#   error = function(x){
#   message("error")
#   print(x)
# },
# warning =function(y){
#   message("warning")
#   print(y)
# },
# finally = {
#   message("done")
# })
# }
