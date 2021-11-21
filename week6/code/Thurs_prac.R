
# set wd
setwd("/home/kate121/Documents/CMEECourseWork/week6/code")

# read data from North
data_N <- as.matrix(read.csv("../data/killer_whale_North.csv", stringsAsFactors=F, header=F))
data_S <- as.matrix(read.csv("../data/killer_whale_South.csv", stringsAsFactors = F, header=F))

