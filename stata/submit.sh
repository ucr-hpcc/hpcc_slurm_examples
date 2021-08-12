#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=15:00     # 15 minutes
#SBATCH --mail-type=ALL
#SBATCH --job-name="just_a_test"
#SBATCH -p short # This is the default partition, you can use any of the following; intel, batch, highmem, gpu

# Load modules
module load stata

# do work
stata < test.do

