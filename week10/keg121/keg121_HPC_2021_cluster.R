# CMEE 2021 HPC exercises R code HPC run code pro forma

rm(list=ls()) # good practice 
source("keg121_HPC_2021_main.R")


iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

# iter <- 1


# Set seed to i in iter
set.seed(iter)

# set community size based on seed
if(iter >= 0 && iter <= 25){
  size = 500 }
if(iter >=26 && iter <= 50){
  size = 1000 }
if(iter >= 51 && iter <= 75){
  size = 2500}
if (iter >= 76 && iter <= 100){
  size = 5000}

# Create a filename to store results
output_file_name  <- paste0("keg121_", iter, ".rda")
 
# run function 
cluster_run(speciation_rate = 0.0064808, size, wall_time =690, interval_rich = 1, interval_oct = size/10, burn_in_generations = 8*size, output_file_name) 

# speciation rate should be: 0.0031674
# accidentally ran with speciation rate of : 0.0064808



