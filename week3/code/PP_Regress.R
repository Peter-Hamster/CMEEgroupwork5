# read in data
MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")

library(ggplot2)
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


#dlpy- to make subsets or make individual subsets 


# Create .pdf file 
pdf("../results/PP_Regression.pdf")
print(p)
dev.off()



