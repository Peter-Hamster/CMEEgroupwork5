rm(list = ls())
graphics.off()

S_data <- seq(1,50,5)
S_data

V_data <- ((12.5 * S_data)/(7.1 + S_data))
plot(S_data, V_data)

set.seed(1456) # To get the same random fluctuations in the "data" every time
V_data <- V_data + rnorm(10,0,1) # Add 10 random fluctuations  with standard deviation of 0.5 to emulate error
plot(S_data, V_data)

# fitting the model using NLLS
MM_model <- nls(V_data ~ V_max * S_data / (K_M + S_data))

plot(S_data,V_data, xlab = "Substrate Concentration", ylab = "Reaction Rate")  # first plot the data 
lines(S_data,predict(MM_model),lty=1,col="blue",lwd=2) # now overlay the fitted model 

# another aproach 
coef(MM_model) # check the coefficients

Substrate2Plot <- seq(min(S_data), max(S_data),len=200) # generate some new x-axis values just for plotting

Predict2Plot <- coef(MM_model)["V_max"] * Substrate2Plot / (coef(MM_model)["K_M"] + Substrate2Plot) # calculate the predicted values by plugging the fitted coefficients into the model equation 

plot(S_data,V_data, xlab = "Substrate Concentration", ylab = "Reaction Rate")  # first plot the data 
lines(Substrate2Plot, Predict2Plot, lty=1,col="blue",lwd=2) # now overlay the fitted model