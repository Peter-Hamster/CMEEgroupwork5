#!/bin/bash
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

if [ -z $3 ];
then 
echo "argument 3 not filled"
exit
fi

cat $1 > $3
cat $2 >> $3
echo "Merged File is"
cat $3
