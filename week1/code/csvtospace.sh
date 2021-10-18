#!/bin/sh
# Author: Kate Griffin kate.griffin21@imperial.ac.uk
# Script: shell scripting practical shell script
# Desc: a new shell script
# Arguments: none
# Date: Oct 2021

# Gives error message ("argument not filled") if the right number of inputs (1) is not given
if [ -z $1 ];
then 
echo "argument 1 not filled"
exit
fi

if [ -z $2 ];
then 
echo "argument 2 not filled"
exit
fi

# Print text which will be displayed in the terminal when the shell script is ran
echo "Create a space deliminated file $2 from $1 ..."

# Print variable 1 (an argument), and replace commas with spaces. Puts output in a new file ($2)
cat $1 | tr -s "," " " >> $2

# Print text which will be displayed once the process is complete
echo "Done!"


# Exit 
exit