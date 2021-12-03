rm(list = ls())
graphics.off()

require(dplyr)
library(ggplot2)

# Load in data
df <- read.csv("../data/model_stats.csv")
df_original <- read.csv("../data/miniproject_data.csv")


############################################################
# find difference between AIC and BIC values for each model:
#############################################################
  
# Comparing quadratic AIC to logistic AIC
#########################################

# Make a  new column to the df 
df$AIC_diff = NA
df$AIC_selected = NA

# Calculate the difference in AIC. If the absolute difference is greater than 2, then the model with the smaller AIC value will be selected

for (i in 1:length(df$ID)){ # for i in each row
  
  df$AIC_diff[i] <- abs(df$AIC_quadratic[i] - df$AIC_logistic[i]) # calculate the absolute difference in AIC between both models
  
  if ((df$AIC_diff[i]) <= 2){ # If the absolute difference between both AIC values is <= 2...
    df$AIC_diff[i] <- NA} # Fill column with NA
  
  else{ # otherwise
    if (df$AIC_quadratic[i] > df$AIC_logistic[i]){ # If AIC quadratic > AIC logistic
      df$AIC_selected[i]<- "logistic"  # selected model is the logistic
    }
    
    else{ #  otherwise
      if (df$AIC_quadratic[i] < df$AIC_logistic[i]){ # if AIC quadratic < AIC logistic
        df$AIC_selected[i] <- "quadratic" # selected model is quadratic
      }}}}


# Create a tally which counts all the best models for each comparison
#####################################################################
count_AIC <- count(df, AIC_selected)

# Comparing quadratic BIC to logistic BIC
#########################################

# Make a  new column to the df 
df$BIC_diff = NA
df$BIC_selected = NA

# Calculate the difference in BIC. If the absolute difference is greater than 2, then the model with the smaller BIC value will be selected

for (i in 1:length(df$ID)){ # for i in each row
  
  df$BIC_diff[i] <- abs(df$BIC_quadratic[i] - df$BIC_logistic[i]) # calculate the absolute difference in BIC between both models
  
  if ((df$BIC_diff[i]) <= 2){ # If the absolute difference between both BIC values is <= 2...
    df$BIC_diff[i] <- NA} # Fill column with NA
  
  else{ # otherwise
    if (df$BIC_quadratic[i] > df$BIC_logistic[i]){ # If BIC quadratic > BIC logistic
      df$BIC_selected[i]<- "logistic"  # selected model is the logistic
    }
    
    else{ #  otherwise
      if (df$BIC_quadratic[i] < df$BIC_logistic[i]){ # if BIC quadratic < BIC logistic
        df$BIC_selected[i] <- "quadratic" # selected model is quadratic
      }}}}


# Create a tally which counts all the best models for each comparison
#####################################################################
count_BIC <- count(df, BIC_selected)

# make a df with the results 
test <- c("AIC", "AIC", "AIC", "BIC", "BIC", "BIC")
model <- c(count_AIC[,1], count_BIC[,1])
n<- c(count_AIC[,2], count_BIC[,2])

fit <- data.frame(test, model, n)


 # Make a bar plot
####################
fit_plot <-
  ggplot(fit, aes(fill=model, y=n, x=test)) + 
  geom_bar(position="fill", stat="identity")



#######################
# Graphing the results
#######################


# Define the logistic model
logistic_model <- function(t, r_max, K, N_0){ 
  return(N_0 * K * exp(r_max * t)/(K + N_0 * (exp(r_max * t) - 1)))
}

# Create a loop which plots the predicted values of both models agaist the observed data points
for (i in 1:length(unique(df_original$ID))){ # loop through unique IDs
  subs <- subset(df_original, ID==i) # create subsets based off unique IDs
  
  # Quadratic
  test <-
    ggplot(subs, aes(x = (Time), y = (PopBio))) +
    geom_point(shape=I(1)) + # sets points to 
    theme_bw() + # make the background white
    labs(x= "Time (hours)", y="Population size") + # add labels 
    theme(aspect.ratio=0.5) +  # set aspect ratio
    stat_smooth(data = subs, geom = "smooth", colour="blue",
                position = "identity", method = "lm",
                formula = y ~ poly(x,2), se = TRUE, fullrange = TRUE,
                level = 0.95, na.rm = FALSE) +
  ggtitle(paste0("ID=",i))
  
  # Add logistic
  timepoints <- seq(0, max(length(subs), 0.1))
  
  logistic_points <- logistic_model(t = timepoints,
                                   r_max = df$r_max[i],
                                   K = df$r_max[i],
                                   N_0 = df$N_0)
  # Fit model
  fit_logistic <- try(nlsLM(PopBio ~ logistic_model(t = timepoints, r_max = subs$r_max[i], K = subs$K[i], N_0 = subs$N_0[i])), silent = T)
  
  test <- test + geom_line(data = subs, aes(x = Time, y = N, col = model), size = 1) 
  
 ggsave(test, file=paste0("../results/plot", i, "pdf"), width = 10, height=10)

}




# 1 / define our model 

# 2/ set the starting values 

# run the model to get the best values for the paramters

# each subset


