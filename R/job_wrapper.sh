#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=10G
#SBATCH --time=1-00:15:00     # 1 day and 15 minutes
#SBATCH --mail-user=useremail@address.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="R Example"
#SBATCH -p intel # This is the default partition, you can use any of the following; intel, batch, highmem, gpu

# The latest R is loaded by default
# However, if you want to use a diferent version, then do so here
#module load R

Rscript myRscript.R
