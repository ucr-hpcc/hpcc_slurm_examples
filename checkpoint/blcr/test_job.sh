#!/bin/bash -l

module load blcr

count=0
while [ 1 -eq 1 ]; do
    count=$(($count+1))
    sleep $count
    srun_cr
    echo "$count"
done

echo "Completed $count"
