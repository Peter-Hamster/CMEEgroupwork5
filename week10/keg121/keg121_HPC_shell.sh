#!/bin/bash 

#PBS -l walltime=12:00:00

#PBS -l select=1:ncpus=1:mem=1gb

cp $HOME/keg121_HPC_2021_main.R .

module load anaconda3/personal

echo "R is about to run"

R --vanilla < $HOME/keg121_HPC_2021_cluster.R

mv keg121_*.rda $HOME/

echo "R has finished running"

# this is a comment at the end of the file