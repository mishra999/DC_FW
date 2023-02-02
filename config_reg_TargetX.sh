#!/bin/bash
filename='TargetX_reg_values.txt'
# n=1
while read -r line; do
# reading each line
echo "$line"
# n=$((n+1))
done < $filename