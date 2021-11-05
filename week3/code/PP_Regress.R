# read in data
MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")
# open ggplot 
library(ggplot2)

# make ggplot graph which is the same as Samraat's
p <-
ggplot(MyDF, aes(x = (Prey.mass), y = (Predator.mass), colour = Predator.lifestage)) +
geom_point(shape=I(3)) + # sets points to crosses
facet_wrap(Type.of.feeding.interaction ~., ncol=1, strip.position=c("right")) + # facet by feeding interaction (Type.of.feeding.interaction ~.), set numver of columns to 1 so that there are 5 graphs stacked on top of each other (ncol=1) and set strip position to "right"
geom_smooth(method = "lm",fullrange = TRUE) + # add linear regression line, set full range to true so you can see the line properly
theme_bw() + # make the background white
scale_x_log10() + scale_y_log10() + # scale axes
labs(x= "Prey Mass in grams", y="Predator mass in grams") + # add labels 
theme(legend.position = "bottom", # put legend at the botom
      legend.key.height = unit(0.5, 'cm'), # resize legend
      legend.key.size = unit(0.5, 'cm'), # resize legend key
      legend.text = element_text(size=7), # change font size of legend text
      legend.title = element_text(face="bold", size = 7), # make legend title bold
      axis.text=element_text(size=7), # change font size of axis text
      axis.title=element_text(size=10), # change font size of axis title
      strip.text = element_text(size=5.5), # size labels in subplots
       aspect.ratio=0.5) + # set aspect ratio
guides(colour = guide_legend(nrow=1))  # nrow=1 sets the no of rows of 1

# Create .pdf file 
pdf("../results/PP_Regression.pdf")
print(p)
dev.off()

# Make linear regression model 
#dlpy- use to make function and apply tosubsets or make individual subsets 

#open plyr
require(plyr)
library(plyr)

# dlply Makes a list (lm_results) from a dataframe (MyDF)
# Mesures the relationship between prey and predator mass based off of types of feeding interation and predator lifestage
# predator.mass (x) ~ Prey.mass (y): x is predicted by y
lm_results<- dlply(MyDF,.(Type.of.feeding.interaction, Predator.lifestage), function(x) lm(Predator.mass~Prey.mass, data = MyDF))

#notes on how to find the right index values for r^2, p.value, slope, intercept, f-statistic
###########################################################
#> x <- lm_results[[1]] #run to rename lm_results as x
# > summary(x)$fstatistic #run to find summary of f-statistic (there is only one value so no need to index
#summary(x)$coefficient # this is where we will find the p-value ()Pr(>|t|) in output), slope (estimate of prey.mass) and intercept (estimate)
# summary(x)$coefficient[1] #this is the exact value we need (in this case, intercept), so we will add this to the function below 

# Use ldply to make list a DF
lm_df <- ldply(lm_results, function(x){
  r2 <- summary(x)$r.squared[1]
  p.value <- summary(x)$coefficients[8]
  slope <- summary(x)$coefficients[2]
  intercept <- summary(x)$coefficients[1]
  data.frame(r2, intercept, slope, p.value)
})

# need to make a new function for f stat as this has NA values
F.stat<- ldply(lm_results, function(x) summary(x)$fstatistic[1])

# merge lm_df with F.stat
lm <- merge(lm_df, F.stat, by = c("Type.of.feeding.interaction", "Predator.lifestage"))

# change column name to f-stat
names(lm)[7] <- "Fstat" # 7th column is just called value, so change to "Fstat

write.csv(lm, "../results/PP_Regress_results.csv")



