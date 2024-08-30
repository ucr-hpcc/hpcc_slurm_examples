#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --time=1-00:15:00     # 1 day and 15 minutes
#SBATCH --mail-user=useremail@address.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="R Example"
#SBATCH -p epyc # You can use any of the following; epyc, intel, batch, highmem, gpu

# The latest R is loaded by default
# However, if you want to use a diferent version, then do so here
#module load R

# Use Rscript to run R script
Rscript myRscript.R
