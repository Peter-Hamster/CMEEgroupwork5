# No preallocated vector
# Here, in each repetition of the for loop, you can see that R has to re-size the vector and re-allocate (more) memory. It has to find the vector in memory, create a new vector that will fit more data, copy the old data over, insert the new data, and erase the old vector. This can get very slow as vectors get big.
NoPreallocFun <- function(x){
  a <- vector() # empty vector
  for (i in 1:x) {
    a <- c(a, i) # concatenate
    #print(a)
    #print(object.size(a))
  }
}

system.time(NoPreallocFun(10000))

# Preallocated vector 
# if you “pre-allocate” a vector that fits all the values, R doesn’t have to re-allocate memory each iteration. 
PreallocFun <- function(x){
  a <- rep(NA, x) # pre-allocated vector
  for (i in 1:x) {
    a[i] <- i # assign
    #print(a)
    #print(object.size(a))
  }
}

system.time(PreallocFun(10000))

