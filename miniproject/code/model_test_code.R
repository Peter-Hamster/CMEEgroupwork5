####################
# Fitting the models
####################
rm(list = ls())
graphics.off()
set.seed(342)
require("minpack.lm")
require(plyr)
library(plyr)
library(ggplot2)
library(rollRegres)
library(zoo)

# Load in data
df <- read.csv("../data/miniproject_data.csv")

##########################
# phenomenological models
#########################

# Fit a quadratic model
quadratic_model <- lm(ID1$PopBio ~ poly(ID1$Time,2))
summary(quadratic_model)
predicted_quadratic <- predict(quadratic_model)

# Fit a cubic polynomial model
cubic_model <- lm(ID1$PopBio ~ poly(ID1$Time,3))
summary(cubic_model)
predicted_cubic <- predict(cubic_model)


ID1 = subset(df, ID ==1)
# Graph the predicted values of the models against the observed data points
p <-
  ggplot(ID1, aes(x = (Time), y = (PopBio))) +
  geom_point(shape=I(1)) + # sets points to 
  theme_bw() + # make the background white
  labs(x= "Time (hours)", y="Population size") + # add labels 
  theme(aspect.ratio=0.5) +  # set aspect ratio
  stat_smooth(data = ID1, geom = "smooth", colour="blue",
              position = "identity", method = "lm",
              formula = y ~ poly(x,2), se = TRUE, fullrange = TRUE,
              level = 0.95, na.rm = FALSE) +
  stat_smooth(data = ID1, geom = "smooth", colour="red",
            position = "identity", method = "lm",
            formula = y ~ poly(x,3), se = TRUE, fullrange = TRUE,
            level = 0.95, na.rm = FALSE, ) 

# Lines overlap- this means that R predicted x^3 value as 0.
# note: 
# cubic -> b = bx^3+bx^2+bx+b
# quadratic -> b = bx^2+bx+b
# in this case, bx^3 = 0, so there is no point in usin the cubic model

##################################
# repeat again with another subset
##################################
ID2 <- subset(df, ID== "2")

# Plot population over time
plot(ID2$Time, ID2$PopBio, pch=16)

# Fit a quadratic model
quadratic_model <- lm(ID2$PopBio ~ poly(ID2$Time,2))
summary(quadratic_model)

# Fit a cubic polynomial model
cubic_model <- lm(ID2$PopBio ~ poly(ID2$Time,3))
summary(cubic_model)

# Graph the predicted values of the models against the observed data points
q <-
  ggplot(ID2, aes(x = (Time), y = (PopBio))) +
  geom_point(shape=I(1)) + # sets points to 
  theme_bw() + # make the background white
  labs(x= "Time (hours)", y="Population size") + # add labels 
  theme(aspect.ratio=0.5) +  # set aspect ratio
  stat_smooth(geom = "smooth", colour="blue",
              position = "identity", method = "lm",
              formula = y ~ poly(x,2), se = TRUE, fullrange = TRUE,
              level = 0.95, na.rm = FALSE) +
  stat_smooth(geom = "smooth", colour="red",
              position = "identity", method = "lm",
              formula = y ~ poly(x,3), se = TRUE, fullrange = TRUE,
              level = 0.95, na.rm = FALSE, ) 
# for ID2, cubic model best fits the data


# A function which subsets data by unique ID and then runs a quadratic model on each subset
quadratic_results<- dlply(df,.(ID), function(x) lm(PopBio ~ poly(Time,2), data= x)) # dlply takes a dataframe, performs a set of operations (i.e., runs the model) on the data (in this case- runs the model on each subset) and returns a list of statistical values

quadratic_df <- ldply(quadratic_results, function(x){ # ldply takes a list and returns a dataframe with specified values
  AIC_quadratic <- AIC(x) # Calculates AIC
  BIC_quadratic <- BIC(x) # Calculates BIC
  data.frame(AIC_quadratic, BIC_quadratic) # Create dataframe
})

# A function which subsets data by unique ID and then runs a cubic polynomial on each subset
cubic_results<- dlply(df,.(ID), function(x) lm(PopBio ~ poly(Time,3), data= x))

cubic_df <- ldply(cubic_results, function(x){
  AIC_quadratic <- AIC(x)
  BIC_quadratic <- BIC(x)
  data.frame(AIC_quadratic, BIC_quadratic)
})


##############
# Mechanistic
#############
# Perform a rolling regression
# Load in the package
# Library(rollRegres)
# Roll_rolling <- roll_regres(df$PopBio ~ df$Time, df, width = 25L, do_downdates = TRUE)

stats <- function(x) {
       fm <- lm(df$Time ~ df$PopBio, as.data.frame(x))
       c(coef(fm), unlist(glance(fm)))
   }
rollapplyr(df, width = 24, FUN = stats, by.column = FALSE)


logistic_model <- function(t, r_max, K, N_0){ # The classic logistic equation
  return(N_0 * K * exp(r_max * t)/(K + N_0 * (exp(r_max * t) - 1)))
}

# Fit logistic model with starting parameters 
for (i in 1:length(unique(df$ID))){ # loop through unique IDs
  subs <- subset(df, ID==i) # create subsets based off unique IDs
  N_0_start <- min(subs$PopBio) # lowest population size
  K_start <- max(subs$PopBio) # highest population size
  r_max_start <- 0.0001

  fit_logistic <- nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), subs, # fit model using NLLS
                        list(r_max=r_max_start, N_0 = N_0_start, K = K_start))

  AIC_logistic[i] <- AIC(fit_logistic) # Calculate AIC
  BIC_logistic[i] <- BIC(fit_logistic) # Calculate BIC  
  logistic_df <- data.frame(AIC_logistic, BIC_logistic)
}

summary(fit_logistic)

############
# 




gompertz_model <- function(t, r_max, K, N_0, t_lag){ # Modified gompertz growth model (Zwietering 1990)
  return(N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((K - N_0) * log(10)) + 1)))
}

N_0_start <- min(df$PopBio) # lowest population size, note log scale
K_start <- max(df$PopBio) # highest population size, note log scale
r_max_start <- 0.62 # use our previous estimate from the OLS fitting from above
t_lag_start <- df$Time[which.max(diff(diff(df$PopBio)))] # find last timepoint of lag phase
nlsLM()


######################
# Personal notes#####
#####################

# two good ones to start with: phenomenological quadratic and linear regression then try complicated Least squares model
# biryani model and quadratic


##
################################################
# roughly putting together rr and logistic model
################################################
# Fit logistic model with starting parameters 
logistic_df <- data.frame()
rmax_df <- data.frame(rmax=rep(NA, length(unique(df$ID)))) # Create an empty dataframe with column "rmax" and fill with NA values 

for (i in 1:length(unique(df$ID))){ # loop through unique IDs
  subs <- subset(df, ID==i) # create subsets based off unique IDs
  
  # rolling regression
  roll <- roll_regres(PopBio ~ Time, subs, width = as.integer(length(subs$ID)*0.48), do_downdates = TRUE) # Perform a rolling regression on each subset. Set window size to 6 (as anything smaller will return an error)
  roll_data <- data.frame(roll$coefs) # Create a dataframe and fill it with coefficient values (i.e. the gradient) calculated by the rolling regression
  r_max <- max(roll_data$Time, na.rm = TRUE) # Find the maximum value calculated above (for each subset). i.e. r_max
  
  # try to run rr on each subset, but if it doesn't work then just default 0.0001
  
  # Set parameters
  N_0_start <- min(subs$PopBio) # lowest population size
  K_start <- max(subs$PopBio) # highest population size
  r_max_start <- r_max
  
  # Fit model
  fit_logistic <- try(nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), subs, # fit model using NLLS
                            list(r_max=r_max_start, N_0 = N_0_start, K = K_start)), silent = T)
  
  
  AIC_logistic[i] <- try(AIC(fit_logistic), silent= T) # Calculate AIC
  BIC_logistic[i] <- try(BIC(fit_logistic), silent = T) # Calculate BIC  
  logistic_df <- data.frame(AIC_logistic, BIC_logistic) # Create data frame with AIC and BIC values
}

# Make a DF with all AIC and BIC values produced by the models
logistic_df$ID = unique(df$ID) # Add column "ID" to logistic_df
model_stats <- merge(cubic_df, quadratic_df, by = "ID" )
model_stats <- merge(model_stats, logistic_df, by = "ID")

# Export AIC and BIC results as a .CSV file
write.csv(model_stats, "../data/model_stats.csv")

######################################################################
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
###############

# attempt at cubic model 
# cubic_results <- NA
# 
# cubic_results <- list()

cubic_results <- vector(mode = "list", length = length(unique(df$ID)))

AIC_cubic <- c()

for (i in 1:length(unique(df$ID))){ # loop through unique IDs
  subs <- subset(df, ID==i) # create subsets based off unique IDs
  subs
  if (nrow(subs) > 5 ){
    cubic_results[[i]] <- lm(PopBio ~ poly(Time,3), data = subs)
  }
  else {
    cubic_results[[i]]<- NA
  }}


cubic_df <- ldply(cubic_results, function(x){ # ldply takes a list and returns a dataframe with specified values
  AIC_cubic<- AIC(x) # Calculates AIC
  BIC_cubic <- BIC(x) # Calculates BIC
  data.frame(AIC_cubic, BIC_cubic) # Create dataframe
})


for (i in length(cubic_results)){
  AIC_cubic[i] <- try(AIC(cubic_results[[i]]), silent = T)
  BIC_cubic <- try(BIC(cubic_results[[i]]), silent = T)

  if (class(BIC_cubic) == "try-error"){
    BIC_cubic = NA
  }
  if (class(BIC_cubic) == "try-error"){
    BIC_cubic = NA
  }
   test <- data.frame(AIC_cubic, BIC_cubic)
}
  

