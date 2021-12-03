rm(list = ls())
graphics.off()

# Load in data
df <- read.csv("../data/model_stats.csv")

#####################################################
# find difference between AIC values for each model:
#####################################################
  
# Comparing cubic to logistic
##############################

# Make a  new column to the df 
df$AIC_diff_cubic_logi = NA
df$selected_cubic_logi = NA

# Calculate the difference in AIC. If the absolute difference is greater than 2, then the model with the smaller AIC value will be selected
for (i in 1:length(df$ID)){ # for i in each row
  
  df$AIC_diff_cubic_logi[i] <- abs(df$AIC_cubic[i] - df$AIC_logistic[i]) # calculate the absolute difference in AIC between both models
  
  if ((df$AIC_diff_cubic_logi[i]) <= 2){ # If the absolute difference between both AIC values is <= 2...
    df$AIC_diff_cubic_logi[i] <- NA} # Fill column with NA
    
    else{ # otherwise
          if (df$AIC_cubic[i] > df$AIC_logistic[i]){ # If AIC cubic > AIC logistic
          df$selected_cubic_logi[i]<- "logistic"  # selected model is the logistic
        }
        
        else{ #  otherwise
          if (df$AIC_cubic[i] < df$AIC_logistic[i]){ # if AIC cubic < AIC logistic
          df$selected_cubic_logi[i] <- "cubic" # selected model is cubic
      }}}}
  

# Comparing quadratic to logistic
################################

# Make a  new column to the df 
df$AIC_diff_quad_logi = NA
df$selected_quad_logi = NA

# Calculate the difference in AIC. If the absolute difference is greater than 2, then the model with the smaller AIC value will be selected

for (i in 1:length(df$ID)){ # for i in each row
  
  df$AIC_diff_quad_logi[i] <- abs(df$AIC_quadratic[i] - df$AIC_logistic[i]) # calculate the absolute difference in AIC between both models
  
  if ((df$AIC_diff_quad_logi[i]) <= 2){ # If the absolute difference between both AIC values is <= 2...
    df$AIC_diff_quad_logi[i] <- NA} # Fill column with NA
  
  else{ # otherwise
    if (df$AIC_quadratic[i] > df$AIC_logistic[i]){ # If AIC quadratic > AIC logistic
      df$selected_quad_logi[i]<- "logistic"  # selected model is the logistic
    }
    
    else{ #  otherwise
      if (df$AIC_quadratic[i] < df$AIC_logistic[i]){ # if AIC quadratic < AIC logistic
        df$selected_quad_logi[i] <- "quadratic" # selected model is quadratic
      }}}}


# Comparing quadratic to cubic
###############################

# Make a  new column to the df 
df$AIC_diff_quad_cubic = NA
df$selected_quad_cubic = NA

# Calculate the difference in AIC. If the absolute difference is greater than 2, then the model with the smaller AIC value will be selected

for (i in 1:length(df$ID)){ # for i in each row
  df$AIC_diff_quad_cubic[i] <- abs(df$AIC_quadratic[i] - df$AIC_cubic[i]) # calculate the absolute difference in AIC between both models
  
  if(is.na(df$AIC_diff_quad_cubic[i])){
  df$AIC_diff_quad_cubic[i] <- NA
  
  }
  else if ((df$AIC_diff_quad_cubic[i]) <= 2){ # If the absolute difference between both AIC values is <= 2...
    df$AIC_diff_quad_cubic[i] <- NA} # Fill column with NA
  
  else{ # otherwise
    if (df$AIC_quadratic[i] > df$AIC_cubic[i]){ # If AIC quadratic > AIC cubic
      df$selected_quad_cubic[i]<- "cubic"  # selected model is the cubic
    }
    
    else{ #  otherwise
      if (df$AIC_quadratic[i] < df$AIC_cubic[i]){ # if AIC quadratic < AIC cubic
        df$selected_quad_cubic[i] <- "quadratic" # selected model is quadratic
      }}}}


#####################################################################
# Create a tally which counts all the best models for each comparison
#####################################################################

count_cubic_logistic <- count(df,selected_cubic_logi)
count_quadratic_logistic<- count(df,selected_quad_logi)
count_cubic_quadratic <- count(df,selected_quad_cubic) # note this is empty because there is no difference between AIC


# now do BIC

