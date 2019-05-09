#!/bin/bash

# These bash and R script examples came from here
#  https://rcc.uchicago.edu/docs/software/environments/R/index.html#snow

#SBATCH --job-name=snow-test
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --time=10

module load R/3.4.0
module load openmpi

# Always use -n 1 for the snow package. It uses Rmpi internally to spawn
# additional processes dynamically
mpirun -np 1 Rscript snow-test.R

