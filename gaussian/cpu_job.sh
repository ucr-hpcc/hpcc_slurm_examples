#!/bin/bash -l

#SBATCH -c 10
#SBATCH --mem=10g
#SBATCH --time=2:00:00
#SBATCH -p short

# Load software
module load gaussian/16

# Set scratch directory
module load workspace/scratch
export GAUSS_SCRDIR=${SCRATCH}

# Move to working directory 
cd ~/bigdata/Projects/gaussian/

# Run Gaussian
g16 ch4_opt.gjf
