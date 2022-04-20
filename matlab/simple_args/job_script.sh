#!/bin/bash -l
#SBATCH -p short

module load matlab

matlab -nodisplay -nodesktop -r 'var1="'$var1'"' < matlabCode.m

