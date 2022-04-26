#!/bin/bash -l
#SBATCH -p short

module load matlab

matlab -nodisplay -nodesktop -r "var1=$1;var2=$2" < matlabCode.m

