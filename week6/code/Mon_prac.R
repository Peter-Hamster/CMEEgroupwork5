# set wd
setwd("/home/kate121/Documents/CMEECourseWork/week6/code")

# load in data
# specify the option strings AsFactors as FALSE and colClasses as a vector of characters (otherwise the T nucleotide will be read as a boolean variable)
# Note: each column is a site on a chromosome and each row is a different chromosome 
data <- read.csv("../data/bears.csv", stringsAsFactors=F, header=F, colClasses=rep("character", 10000))

dim(data)
data[,5]
data[1,(c(1:100))]

# Note: each row is a 

### SNPs are positions where you observed more than one allele
### the easiest thing is to loop over all sites and record the ones with two alleles
data[,3]
data[,262]
unique(data[,3])
length(unique(data[,3]))
length(unique(data[,3]))==2
unique(data[,262])
length(unique(data[,262]))
length(unique(data[,262]))==2

# 1. identify which positions are SNPs (polymorphic, meaning that they have more than one allele)

# Make a list of SNPS (i.e., where there is more than 1 allele ) 
# SNPs: if the number of unique alleles is more than 1, that represents a SNP
snps <- c() #make an empty vector called "snps"
for (i in 1:ncol(data)) { # for ever column of "data"...
  if (length(unique(data[,i]))==2){ # if the number of unique values in each row [,i] is equal to 2 (i.e. there is a divergence)...
    snps <- c(snps, i) # add column number to "snps" (overwrite empty list)
  }
}

### this works to retain the indexes of SNPs; a smartest way would not involve doing a loop but using `apply` functions
## Find the number of SNPs
cat("\nNumber of SNPs is", length(snps))

### reduce the data set 
## only columns containing SNPs
data <- data[,snps]
dim(data)

# 2. calculate, print and visualize allele frequencies for each SNP
### alleles in this SNP
alleles <- unique(data[,1])
cat("\nSNP", "with alleles", alleles)

## frequencies of the alleles
freq_a1<-length(which(data[,1]==alleles[1]))/nrow(data)
freq_a2<-length(which(data[,1]==alleles[2]))/nrow(data)

### the minor allele is the one in lowest frequency
minor_allele<-alleles[which.min(c(freq_a1,freq_a2))]
freq_minor_allele<-c(freq_a1,freq_a2)[which.min(c(freq_a1,freq_a2))]

cat(" the minor allele is",minor_allele ,"and the minor allele frequency (MAF) is", freq_minor_allele)


### again we can loop over each SNP and easily calculate allele frequencies
frequencies <- c()
for (i in 1:ncol(data)) {
  
  ### alleles in this SNP
  alleles <- sort(unique(data[,i]))
  cat("\nSNP", i, "with alleles", alleles)
  
  ## frequencies of the alleles
  freq_a1<-length(which(data[,i]==alleles[1]))/nrow(data)
  freq_a2<-length(which(data[,i]==alleles[2]))/nrow(data)
  
  ### the minor allele is the one in lowest frequency
  minor_allele<-alleles[which.min(c(freq_a1,freq_a2))]
  freq_minor_allele<-c(freq_a1,freq_a2)[which.min(c(freq_a1,freq_a2))]
  
  cat(" the minor allele is",minor_allele ,"and the minor allele frequency (MAF) is", freq_minor_allele)
  
  frequencies <- c(frequencies, freq_minor_allele)
}

### we can plot is as a histogram
hist(frequencies)
### or simply the frequencies at each position
plot(frequencies, type="h")

#tip use unique function to 
unique()

# question 4: calculate and print genotype frequencies for each SNP
# ### alleles in the first SNP
# alleles <- unique(data[,1])
# cat("\nSNP", i, "with alleles", alleles)
# 
# ## frequencies of the alleles
# freq_a1<-length(which(data[,1]==alleles[1]))/nrow(data)
# freq_a2<-length(which(data[,1]==alleles[2]))/nrow(data)
# 
# ### the minor allele is the one in lowest frequency
# minor_allele<-alleles[which.min(c(freq_a1,freq_a2))]
# freq_minor_allele<-c(freq_a1,freq_a2)[which.min(c(freq_a1,freq_a2))]

genotype_counts <- c(0, 0, 0)

nsamples <- 20
for (j in 1:nsamples) {
  ### indexes of haplotypes for individual j (haplotype indices)
  haplotype_index <- c( (j*2)-1, (j*2) )
  ### count the minor allele instances
  genotype <- length(which(data[haplotype_index, 1]==minor_allele)) 
  ##
  genotype_index=genotype+1
  ### increase the counter for the corresponding genotype
  genotype_counts[genotype_index] <- genotype_counts[genotype_index] + 1
}
cat(" and genotype frequencies", genotype_counts)



### again, we can loop over each SNPs and each individual and print the genotype frequencies
# nsamples <- nrow(data)/2
# for (i in 1:ncol(data)) {
#   
#   alleles <- sort(unique(data[,i]))
#   cat("\nSNP", i, "with alleles", alleles)
#   
#   ## frequencies of the alleles
#   freq_a1<-length(which(data[,i]==alleles[1]))/nrow(data)
#   freq_a2<-length(which(data[,i]==alleles[2]))/nrow(data)
#   
#   ### as before, as there is no "reference" allele, we calculate the frequencies of the minor allele
#   ### the minor allele is the one in lowest frequency
#   minor_allele<-alleles[which.min(c(freq_a1,freq_a2))]
#   freq_minor_allele<-c(freq_a1,freq_a2)[which.min(c(freq_a1,freq_a2))]
#   
  ### genotypes are major/major major/minor minor/minor
  genotype_counts <- c(0, 0, 0)
  
  for (j in 1:nsamples) {
    ### indexes of haplotypes for individual j (haplotype indices)
    haplotype_index <- c( (j*2)-1, (j*2) )
    ### count the minor allele instances
    genotype <- length(which(data[haplotype_index, i]==minor_allele)) 
    ##
    genotype_index=genotype+1
    ### increase the counter for the corresponding genotype
    genotype_counts[genotype_index] <- genotype_counts[genotype_index] + 1
  }
  cat(" and genotype frequencies", genotype_counts)
# }

# question 4 
cat(" and heterozygosity", genotype_counts[2]/nsamples)
cat(" and homozygosity", 1-genotype_counts[2]/nsamples)



