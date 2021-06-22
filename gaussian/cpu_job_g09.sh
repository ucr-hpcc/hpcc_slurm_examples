#!/bin/bash -l

#SBATCH -c 10
#SBATCH --mem=10g
#SBATCH --time=2:00:00
#SBATCH -p short

# Load software
gaussian/9_SSE3

# Set scratch directory
module load workspace/scratch
export GAUSS_SCRDIR=${SCRATCH}

# Move to working directory 
cd ~/bigdata/Projects/gaussian/

# Run Gaussian
g09 ch4_opt.gjf
