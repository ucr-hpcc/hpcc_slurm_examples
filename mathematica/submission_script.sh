#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --time=1-00:15:00     # 1 day and 15 minutes
##SBATCH --mail-user=useremail@address.com
##SBATCH --mail-type=ALL
#SBATCH --job-name="just_a_test"
#SBATCH -p intel # This is the default partition, you can use any of the following; intel, batch, highmem, gpu                                                                              

module load mathematica/11.3

math -noprompt -run '<<test.m'
