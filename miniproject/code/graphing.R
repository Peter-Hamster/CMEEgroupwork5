####################
# Fitting the models
####################
rm(list = ls())
graphics.off()
set.seed(342)
library(ggplot2)


# Load in data
df <- read.csv("../data/model_stats.csv")

##########################
# phenomenological models
#########################

# Graph the predicted values of the models against the observed data points

# Quadratic
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



