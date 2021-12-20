# CMEE 2021 HPC excercises R code main pro forma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything yourself from scratch please ensure you use EXACTLY the same function and parameter names and beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Kate Griffin"
preferred_name <- "Kate"
email <- "kate.griffin21@imperial.ac.uk"
username <- "keg121"

# please remember *not* to clear the workspace here, or anywhere in this file. If you do, it'll wipe out your username information that you entered just above, and when you use this file as a 'toolbox' as intended it'll also wipe away everything you're doing outside of the toolbox.  For example, it would wipe away any automarking code that may be running and that would be annoying!

library(ggplot2)

# Question 1
species_richness <- function(community){
  return(length(unique(community))) # counts species richness of a community
}

# Question 2
init_community_max <- function(size){
  return(seq(from = 1, to = size, by = 1)) # generate the max number of species within the community (i.e., every individual in the community is its own species). Eg. if init_community_max(3), then should return a vector of (1,2,3) (each value between 1-3 represents a species, and each different number represents an individual)
}

# Question 3
init_community_min <- function(size){
  return(seq(1, 1, length.out = size)) # Generate min number of species within the community (1). I.e., init_community_min(5) -> a community of 5 individuals of the same species, and should return a vector (1,1,1,1,1)
}

# Question 4
choose_two <- function(max_value){
  return(sample(max_value, 2, replace = F)) # This function first chooses a random number according to a uniform distribution between 1 and max_value (inclusive of the endpoints). It also choses a second random number also between 1 and max_value, but not equal to the first number. 
}

# Question 5
neutral_step <- function(community){ # Performs a single step of a simple neutral model simulation, without speciation, on a community vector. 
  rand <- choose_two(length(community)) # Takes two random values from community (and stores as "rand")
  community[rand[1]] <- community[rand[2]] # overwrite the first value of rand (the dead individual) with the second one (the reproducing individual)
  return(community) # Overwrite community with changes applied
}


# Question 6
neutral_generation <- function(community){ # A function which simulates several neutral_steps on a community so that a generation has passed. If the community consists of x individuals, then x/2 individual neutral steps will correspond to a complete generation f
  generation <-length(community) # set generation to the length of the community
  if ((generation %% 2) != 0){ # if the generation is an odd number...
    if (runif(1) <0.5){ # generate a random number and do a "coin flip" (runif randomly generates numbers, this way you can use it as like a "coin flip". Runif(1) generates one random number between 0 to 1...) If this random number is less than 0.5, then....
      generation <- generation + 1} # add 1 to generation
      else { # otherwise
      generation <- generation - 1 # subtract 1
    }
  }
 generation <- generation /2 # divide generation by 2
  for (i in 1:generation){  # for i in 1 to the size of the generation
    community <- neutral_step(community) # perform the neutral steps calculation. Overwrite community with values calculated by running neutral_steps
  }
 return(community) # return community
}

# Question 7
neutral_time_series <- function(community,duration)  { # A function which will do a neutral theory simulation and return a time series of species richness in the system. 
  time_series <- c(species_richness(community)) # initialize a list with the initial species richness of the community
  for (i in 1:duration){  # for i in the duration of time specified
    community <- neutral_generation(community) # perform the neutral generation calculation. Overwrite community with values calculated by running neutral_generation
    time_series <-c(time_series, species_richness(community)) # returns a list of species richness for each generation
    }
  return(time_series) # return time series
}

# Question 8
question_8 <- function() { # A function which plots a time series graph of a neutral model simulation from an initial condition of maximal diversity in a system size of 100 individuals
  # clear any existing graphs and plot your graph within the R window
  # dev.off() 
  
  # Plot
    plots <- plot(neutral_time_series((init_community_max(100)), 200),main = "Neutral model simulation", sub= " Simulation of 100 individuals, with an initial maximal diversity, for 200 generations.", type = "l", col = "red", lwd = 3, ylab="Species richness (n)", xlab="Generations")
  return("The system will always converge to 1 species after enough time, because the neutral theory model accounts for extinction (i.e., replacement), but not for speciation")
}


# Question 9
neutral_step_speciation <- function(community,speciation_rate)  { # A function neutral_step_speciation which will perform a step of a neutral model with speciation. 
    if (runif(1) > speciation_rate){ # If probability is greater than the rate of speciation 
      community <- neutral_step(community) # perform neutral_steps function on community
    }
  else{ # Otherwise...
    dead <- sample(length(community), 1, replace = F) # Randomly sample from community
    community[dead] <- max(community)+1 # Replace dead species with new one by overwriting the randomly sampled (the dead individual, i.e., "dead") with a random number not in list (take the max value of the list and add 1 to ensure its unique)
    
    return(community) # Overwrite community with changes applied
  }
}

# Question 10
neutral_generation_speciation <- function(community,speciation_rate)  { # A function which simulates several neutral_steps_speciation on a community so that a generation has passed.
    generation <-length(community) # set generation to the length of the community
    if ((generation %% 2) != 0){ # if the generation is an odd number...
      if (runif(1) <0.5){ # generate a random number and do a "coin flip" (runif randomly generates numbers, this way you can use it as like a "coin flip". Runif(1) generates one random number between 0 to 1...) If this random number is less than 0.5, then....
        generation <- generation + 1} # add 1 to generation
      else { # otherwise
        generation <- generation - 1 # subtract 1
      }
    }
    generation <- generation /2 # divide generation by 2
    for (i in 1:generation){  # for i in 1 to the size of the generation
      community <- neutral_step_speciation(community, speciation_rate) # perform the neutral steps calculation. Overwrite community with values calculated by running neutral_steps
    }
    return(community) # return community
  }

# Question 11
neutral_time_series_speciation <- function(community,speciation_rate,duration)  { #  # A function which will do a neutral theory simulation and return a time series of species richness in the system, which takes speciation into account 
  time_series <- c(species_richness(community)) # initialize a list with the initial species richness of the community
  for (i in 1:duration){  # for i in the duration of time specified
    community <- neutral_generation_speciation(community, speciation_rate) # perform the neutral generation calculation. Overwrite community with values calculated by running neutral_generation
    time_series <-c(time_series, species_richness(community)) # returns a list of species richness for each generation
  }
  return(time_series) # return time series
}


# Question 12
question_12 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  # dev.off() 
  
  # Plot
  plots <- plot(neutral_time_series_speciation((init_community_max(100)), 0.1, 200),main = "Neutral model simulation with speciation", sub= " Simulation of 100 individuals, with an initial maximal and minimal diversity, for 200 generations. Speciation is taken into account", type = "l", col = "red", lwd = 3, ylab="Species richness (n)", xlab="Generations",  ylim=c(0,100))
  lines(neutral_time_series_speciation((init_community_min(100)), 0.1, 200), type = "l", col = "blue", lwd = 3)

  # Add a legend
  legend("topright", 
         legend = c("Initial state: maximum diversity", "Initial state: minimum diversity"),
         col = c("red", 
                 "blue"), 
         pch = c(19,19), 
         bty = "n", 
         pt.cex = 2, 
         cex = 1.2, 
         text.col = "black", 
         horiz = F , 
         inset = c(0.1, 0.1))
         
  return("The initial conditions of this model does not affect the final result (i.e., does not affect when the population converges). The graph is showing the change in species richness over time for a population with 100 indiiduals over 200 generations, for both an initial maximum and minimum diversity. Now that speciation is accounted for, the simulated population will reach a dynamic equilibrium (rate of speciation is equal to the rate of extinction)")
}

# Question 13
species_abundance <- function(community)  { # Count species abundance
  count <- as.data.frame(sort(table(community), decreasing = T)) # Creates a count of each species (numbers) and puts into a data frame. Sort by decreasing order.
  if (length(unique(community)) == 1){ # if there is only 1 species in the community
    abun <- count[,1]} # Extract the frequncy value (this is because having only 1 species reformats the df)
  else{
  abun <- count$Freq # Extract the frequency column as a vector ("abun")
}
  return(abun) 
 }

# Question 14
octaves <- function(abundance_vector) { # Create a vector which calculates
  octave_classes <- tabulate(floor(log(abundance_vector, base = 2))+1) # calculate log base 2 of each species abundance (vector of species abundance calculated  in the last question) and use floor to round down to the nearest integer. This will return a list of which "bin" each value will go in (e.g., log2(100) = 6, so hypothetically it should be put in the 6th bin). However, log2(1) is 0, so we must add 1 to each logged value (i.e., log2(10)=6, 6+1=7: so it will be put in bin 7) Then use tabulate to create the bins themselves by counting how many of each logged values there are (see question for more detail)
  return(octave_classes)
}

# Question 15
sum_vect <- function(x, y) {
  if (length(x) > length(y)){
    y <- append(y, rep(0, length(x) - length(y)))
  }
  if (length(y) > length(x)){
    x <- append(x, rep(0, length(y) - length(x)))
  }
  sum <- x + y 
  
  return(sum)
}

# Question 16 

# run 1 simulation for 2200 years 
# first 200 years: burn in period. 
# use neutral_generation_speciation function to find community after 1 generation 
# record species abundance octaves for 20 year intervals 
# dev.off() 

question_16 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  # dev.off() 
  
  ########################################
  # 100 individuals with maximal diversity
  #########################################
  
  community1 <- init_community_max(100) # Community of 100 individuals with maximal diversity
  counter <- 0 # Initiaise counter (starting at 0)
  Oct_vec <- c() # Initialise empty octave vector
  
  # use a repeat loop 
  # use counter <- counter + 1 to count generations 
  
  repeat{ # Loop which will run a series of neutral steps on a community over generations
    community1 <- neutral_generation_speciation(community1, 0.1) # run neutral_generation_speciation on community. The speciation rate = 0.1
    counter <- counter + 1 # Generation counter which starts at 0, and adds 1 for each loop
    if (counter%%20 == 0 & counter >= 200){ # if generation is divisable by 20 and is also more than the burn period (after 200 generations)...
     Oct_vec <- sum_vect(Oct_vec, octaves(species_abundance(community1))) # calculate species abundance of the community and find octave vectors of abundances. Sum every element of each octave vector (calculated from each additional intervals). At the end ->  will have a vector will the species abundance calculated over the whole simulation. Next step is to find the mean (so the whole species abundance/no. of intervals of the simulation)....
     # Note: This calculates the octave vectors for every 20 generations, and overwrites Oct_vec with every additional calculation. so Oct_vec= sum of previous Oct_vect + each newly calculated octave vector (octaves(species_abundance(community))
    }
    if (counter == 2200) break # when the counter reaches 2200 then the simulation stops
  }
    
    mean_max = Oct_vec/100 #  Calculate mean of octave vectors. The mean is : mean=oct1+oct2+oct3/num_octaves. We have calculated the first part (0ct1+oct2_oct3..) in the step above. For the denominator: 2000 generations/ interval time 20 years= 100
   
    ########################################
    # 100 individuals with minimal diversity
    ########################################
    
    community2 <- init_community_min(100) # Community of 100 individuals with maximal diversity
    counter <- 0 # Initiaise counter (starting at 0)
    Oct_vec <- c() # Initialise empty octave vector
    
    
    # use a repeat loop 
    # use counter <- counter + 1 to count generations 
    
    repeat{ # Loop which will run a series of neutral steps on a community over generations
      community2 <- neutral_generation_speciation(community2, 0.1) # run neutral_generation_speciation on community. The speciation rate = 0.1
      counter <- counter + 1 # Generation counter which starts at 0, and adds 1 for each loop
      if (counter%%20 == 0 & counter >= 200){ # if generation is divisable by 20 and is also more than the burn period (after 200 generations)...
        Oct_vec <- sum_vect(Oct_vec, octaves(species_abundance(community2))) # calculate species abundance of the community and find octave vectors of abundances. Sum every element of each octave vector (calculated from each additional intervals). At the end ->  will have a vector will the species abundance calculated over the whole simulation. Next step is to find the mean (so the whole species abundance/no. of intervals of the simulation)....
        # Note: This calculates the octave vectors for every 20 generations, and overwrites Oct_vec with every additional calculation. so Oct_vec= sum of previous Oct_vect + each newly calculated octave vector (octaves(species_abundance(community))
      }
      if (counter == 2200) break # when the counter reaches 2200 then the simulation stops
    }
      
      mean_min = Oct_vec/100 #  Calculate mean of octave vectors. The mean is : mean=oct1+oct2+oct3/num_octaves. We have calculated the first part (0ct1+oct2_oct3..) in the step above. For the denominator: 2000 generations/ interval time 20 years= 100
     
      ########
      # Plot
      ########
      # Create bin widths vector
      # Note: first bin is just 1, so only loop through 2:length of the octave
      abundance_bins <- c(1) # start with bin number "1", then add on the other bin values with the loop...
      for (i in 2:max(c(length(mean_min), length(mean_max)))){ # find the max length of the octaves between both communities
        abundance_bins <- append(abundance_bins, paste(2^(i-1),"-", (2^i)-1))} # 2^n-1 to 2^n: note, the -1 is to avoid overlap (i.e., instead of "2-4", "4-8"... etc. it returns: "2- 3", "4-7"...)         
 
      # Vector with all means (from max diversity and min diversity communities)
      means <- c(mean_max, mean_min)
      
      # Make a vector which will correspond to whether the above is a max or min diversity community
      max_or_min <- c("Max", "Max", "Max", "Max", "Max", "Max", "Min", "Min", "Min", "Min", "Min", "Min")
      
      # Put bin_widths and species abundance means into a df 
      abundance_means_df <- data.frame(abundance_bins, means, max_or_min)
      
      plot <- 
        ggplot(abundance_means_df, aes(fill=max_or_min, y=means, x=abundance_bins)) + 
        geom_bar(position="dodge", stat="identity") +
        scale_x_discrete(limits=abundance_bins) +
        labs(y= "Mean frequency", x = "Number of individuals per species") +
        theme_bw() +
        theme(legend.position = c(.95, .95),
              legend.justification = c("right", "top"),
              legend.box.just = "right",
              legend.margin = margin(6,6,6,6), 
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank())
      
        print(plot)
  
  return("The initial conditions of this model does not matter (i.e., does not affect the mean frequency of individuals per species). As speciation is accounted for, the simulated population will reach a dynamic equilibrium (rate of speciation is equal to the rate of extinction)")
       }
  

  # Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
  
  community <- init_community_min(size) # initialise community with a minimal diversity
  duration <- wall_time*60 # gives wall time in seconds
  start <- as.numeric(proc.time()[3]) # Start time: gives elapsed time in seconds
  # proc time measures how much time it takes to run something. this can be used to set the amount of time we want function to run.
  Oct_vec <- list() # initialise empty list for octaves
  counter = 0
  time_series = c() # initialise empty list for time series 
  
  while((as.numeric(proc.time()[3]) - start) < duration){  # while the current time- starting time < duration...
    community <- neutral_generation_speciation(community, speciation_rate)# apply neutral generation to the community
    counter <- counter + 1 # Generation counter which starts at 0, and adds 1 for each loop
    
    # Recording species richness during the burn in period
    if (counter%%interval_rich == 0 & counter <= burn_in_generations){ # if generation is dividable by interval_rich and is also less than the burn period ...
      time_series <- c(time_series, species_richness(community))} # calculate species richness
      

    # recording the species abundance as octaves 
    if(counter%%interval_oct){ # if generation is dividable by interval_oct
      Oct_vec <- append(Oct_vec, list(octaves(species_abundance(community))))} # Calculate species abundance as octaves for the community, adding each octave vector to the list
      } 

  end <- as.numeric(proc.time()[3]) # End time
  time_taken <- end - start
  save(time_series, Oct_vec, community, time_taken, speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, file = output_file_name) # save file, with output_file_name as the file name
  
  }
  

# Questions 18 and 19 involve writing code elsewhere to run your simulations on the cluster

# Question 20 
process_cluster_results <- function()  {
  sum <- c() # initialise empty vector to store the sum of the octaves 
  den <- c() # initialise empty vector to store denomenator for mean calculation
  
  # Loop through .rda files where size = 500 (no. 1 to 25 of all keg121_x.rda files)
  for (i in 1:25){
    load(paste0("keg121_", i, ".rda"))
    # for(i in 80:length(Oct_vec)){ # loop though each octave vector ... 80: size*8/(size/10)
    # for(i in size*8:length(Oct_vec)){ # edit*
    starti <- min(length(Oct_vec)-1, size*8) 
    for(i in starti :length(Oct_vec)){
        
      sum <- sum_vect(sum, Oct_vec[[i]]) # adds octaves together and adds to "sum"
    }
   #den <- sum(den, (length(Oct_vec) - 79)) # calculate running total for denominator
   # den <- sum(den, (length(Oct_vec) - (size*8)-1)) # edit*
   den <- sum(den, (length(Oct_vec) - starti - 1))
   
     }

  mean500 = sum/den # calculates the mean by dividing sum by the length of the octave
  
  #... Size = 1000
  for (i in 26:50){
    load(paste0("keg121_", i, ".rda"))
    
    starti <- min(length(Oct_vec)-1, size*8) 
    for(i in starti :length(Oct_vec)){
      sum <- sum_vect(sum, Oct_vec[[i]]) # adds octaves together and adds to "sum"
    }
   
    den <- sum(den, (length(Oct_vec) - starti - 1))
  }
  mean1000 = sum/den # calculates mean
  
  # ... Size = 2500
  for (i in 51:75){
    load(paste0("keg121_", i, ".rda"))

    starti <- min(length(Oct_vec)-1, size*8) 
    for(i in starti :length(Oct_vec)){
      sum <- sum_vect(sum, Oct_vec[[i]]) # adds octaves together and adds to "sum"
    }
    den <- sum(den, (length(Oct_vec) - starti - 1))
  }
  mean2500 = sum/den # calculates mean 
  
  # ... Size = 5000
  for (i in 76:100){
    load(paste0("keg121_", i, ".rda"))

    starti <- min(length(Oct_vec)-1, size*8) 
    for(i in starti :length(Oct_vec)){
      sum <- sum_vect(sum, Oct_vec[[i]]) # adds octaves together and adds to "sum"
    }
    den <- sum(den, (length(Oct_vec) - starti - 1))
    
    
  }
  mean5000 = sum/den  # calculates mean
  
  combined_results <- list(mean500, mean1000, mean2500, mean5000) #create your list output here to return
  
  save(combined_results, file = "question_20_combined_means.rda")
}



plot_cluster_results <- function()  {
    # clear any existing graphs and plot your graph within the R window
    #dev.off() 
  
    # load combined_results from your rda file
    load("question_20_combined_means.rda")
  
  
  size_500 <- c(combined_results[[1]])
  size_1000 <-c(combined_results[[2]])
  size_2500 <- c(combined_results[[3]])
  size_5000 <- c(combined_results[[4]])
 
   # plot the graphs
  par(mfrow=c(2,2))
  size_500_plot <- barplot(size_500, main = "Size = 500", ylab = "Mean species abundance", ylim = c(0, 10), col = rgb(1,0,0.5,0.5)) 
  size_1000_plot <- barplot(size_1000, main = "Size = 1000", ylab = "Mean species abundance", ylim= c(0, 10), col = rgb(0.3,0,1,0.4))
  size_2500_plot <- barplot(size_2500, main= "Size = 2500", ylab = "Mean species abundance", ylim = c(0, 10), col = rgb(0,0.3,1,0.5))
  size_5000_plot <- barplot(size_5000, main= "Size = 5000", ylab = "Mean species abundance", ylim = c(0, 10), col = "khaki1")
  mtext("Results for each simulation size", side=1, outer=TRUE, line=-1.2) 

      return(combined_results)
}

# Question 21
question_21 <- function()  {
    x <- log(8)/log(3)
  return(list(x, "To increase the width by 3, you would need x8 of the material"))
}

# Question 22
question_22 <- function()  {
  x <- log(20)/log(3)
  return(list(x, "To increase the width by 3, you would need x20 of the material"))
}

# Question 23

chaos_game <- function()  {
  # clear any existing graphs and plot your graph within the R window
  #dev.off() 
  

  # Make df for coordinates 
  point <- c("A", "B", "C")
   x_cor<- c(0, 3, 4)
   y_cor<-c(0, 4, 1)
   
   # Make DF for coordinates
   coordinates <- data.frame(point, x_cor, y_cor)
   
   # Make point vector X
   X <- c(0,0)

   # plot coordinates
   p <- ggplot(coordinates, aes(x=x_cor, y=y_cor)) +
   geom_point(aes(x = X[1], y= X[2]), size = 1, shape = 4, col = "red")

  mean_x <- c(X[1])
  mean_y <- c(X[2])

   for (i in 1:10000){
     rand <- sample(coordinates$point, size = 1) # randomly sample from points ABC
     x_rand <-  coordinates$x_cor[coordinates$point == rand] # Select x coordinate based on the randomly selected points value
     y_rand <- coordinates$y_cor[coordinates$point == rand] # Select y coordinates based on the randomly selected point value
     
     
     X <- c(mean(c(X[1], x_rand)), mean(c(X[2], y_rand))) # calculate the mean (or halfway point) of X and the random points (overwrite X with these points- so that when the loop runs again it will take from this point and the randomly selected point)
     mean_x <- c(mean_x, X[1]) # populate mean_x with the x coordinates calculated above
     mean_y <- c(mean_y, X[2]) # populate mean_y with the y coordinates calculated above
   } 
  
  df <- data.frame(mean_x, mean_y) # Make a df with all the mean x and y coordinators 
  
    p <- #plot
        ggplot(df, aes(x=mean_x, y=mean_y)) +
        geom_point()
    
    print(p)
   
  
  return("This makes a fractal called the Sierpiński gasket")
}

# Question 24
# dev.off() # clear plots
plot(0, type= 'n', xlim = c(-4,4), ylim = c(-4,4)) # make plot

turtle <- function(start_position, direction, length)  {
opposite <- length*sin(direction) # opp = hyp(or "length) x sin(angle)
adjacent <- length*cos(direction) # adj = hyp x cos(angle)
endpoint <- c(start_position[1] + adjacent, start_position[2] + opposite) # end point is x coordinate of start_position +  adjacent, y coordinate of start_position + opp 


segments(x0= start_position[1], y0= start_position[2], x1= endpoint[1], y1= endpoint[2])  # plot line
return(endpoint) # you should return your endpoint here.
}


# Question 25
#dev.off() # clear plots and graph
plot(0, type= 'n', xlim = c(-4,4), ylim = c(-4,4)) # plot for test

elbow <- function(start_position, direction, length)  {

  line1 <- turtle(start_position, direction, length)

  start<- line1
  dir <- direction - pi/4
  l =  length*0.95
  
  if (direction < 0 ){
    direction <- 2*pi + direction # if the direction is negative then make positive
  }
 
  line2 <- turtle(start, dir, l)
  
}

# test
# elbow(c(0,0), pi/4, 2)

# Question 26
# dev.off() 
plot(0, type= 'n', xlim = c(-4,4), ylim = c(-4,4)) # plot for test

spiral <- function(start_position, direction, length)  {
 if(length >0.05){ # Edit (add this conditional statement to prevent the function just endlessly looping)
   line1 <- turtle(start_position, direction, length)
  
  start<- line1
  dir <- direction - pi/4
  l =  length*0.95
  
  if (direction < 0 ){
    direction <- 2*pi + direction # if the direction is negative then make positive
  }
  
  line2 <- spiral(start, dir, l)
}
  # line2 <- elbow(start, dir, l)
  
  return("The function is recurssive, i.e., it is calling on itself")
}


# Question 27
draw_spiral <- function()  {
  # clear any existing graphs and plot your graph within the R window
  # dev.off() 
  
  # plot spiral with given arguments
  plot(0, type= 'n', xlim = c(-4,4), ylim = c(-4,4)) # plot for test
  spiral(c(0,0), pi, 1)
}

# Question 28
# dev.off()
tree <- function(start_position, direction, length)  {
  if(length >0.003){ # Edit (add this conditional statement to prevent the function just endlessly looping)
    line1 <- turtle(start_position, direction, length)
    
    #line 2
    start<- line1
    dir <- direction - pi/4
    l =  length*0.65

    line2 <- tree(start, dir, l)
    
    # Line 3
    dir2 <- direction + pi/4
    line3 <- tree(start, dir2, l)
  }}

draw_tree <- function()  {
  # clear any existing graphs and plot your graph within the R window
  
  plot(0, type= 'n', xlim = c(-4,4), ylim = c(-1,6)) # plot for test
  tree(c(0,0), direction = pi/2, length = 2)

}

# Question 29
fern <- function(start_position, direction, length)  {
  if(length >0.003){ # Edit (add this conditional statement to prevent the function just endlessly looping)
   
    #Line 1
    line1 <- turtle(start_position, direction, length)
    
    #Line 2
    start<- line1
    l <- length*0.87
    
    line2 <- fern(start, direction, l)
   
     # Line 3
    dir <- direction - pi/4
    l2 <-  length *0.38
    
    line3 <- fern(start, dir, l2)

  }
}

draw_fern <- function()  {
  
  # clear any existing graphs and plot your graph within the R window
  plot(0, type= 'n', xlim = c(-4,4), ylim = c(-1,8)) # plot for test
  fern(c(0,0), direction = pi/2, length = 1)
}

# Question 30
fern2 <- function(start_position, direction, length, dir)  {
  if(length >0.003){ # Edit (add this conditional statement to prevent the function just endlessly looping)
    
    #Line 1
    line1 <- turtle(start_position, direction, length)
    
    #Line 2
    dir <- -dir
    start<- line1
    
    line2 <- fern2(start, direction, length*0.87, dir)
    
    # Line 3
    
    line3 <- fern2(start, (direction+(dir*(pi/4))), length*0.38, -dir)
  
  }
  }


draw_fern2 <- function()  {
  plot(0, type= 'n', xlim = c(-4,4), ylim = c(-1,8)) # plot for test
  fern2(c(0,0), direction = pi/2, length = 1, dir = -1)
  
  # clear any existing graphs and plot your graph within the R window

}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
Challenge_A <- function() {
  # clear any existing graphs and plot your graph within the R window

}

# Challenge question B
Challenge_B <- function() {
  # clear any existing graphs and plot your graph within the R window

}

# Challenge question C
Challenge_C <- function() {
  # clear any existing graphs and plot your graph within the R window

}

# Challenge question D
Challenge_D <- function() {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Challenge question E
Challenge_E <- function() {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Challenge question F
Challenge_F <- function() {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


