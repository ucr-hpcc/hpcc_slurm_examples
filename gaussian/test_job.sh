#!/bin/bash -l

#SBATCH -c 10
#SBATCH --mem=10g
#SBATCH --time=2:00:00
#SBATCH -p short

# Load software
module load gaussian/16

# Create temp directory
export GAUSS_SCRDIR=/scratch/${SLURM_JOB_ID}
mkdir ${GAUSS_SCRDIR}

# Move to working directory 
cd ~/bigdata/Projects/gaussian/

# Run Gaussian
g16 ch4_opt.gjf

# Delete old temp files
rm -rf ${GAUSS_SCRDIR}
