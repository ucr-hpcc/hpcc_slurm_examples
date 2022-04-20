#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=100G
#SBATCH --time=5-00:00:00     # 5 day and 00 minutes
#SBATCH --output=my.stdout
##SBATCH --mail-user=youremail@address.com
##SBATCH --mail-type=ALL
#SBATCH --job-name="HT_QOptica_1e3"
#SBATCH -p intel # This is the default partition, you can use any of the following; intel, batch, highmem, gpu


# Print current date
date

# Load matlab
module load matlab/r2018a
matlab -nodisplay -nosplash <ssfres_normal_thermal_resonance_shift_trans_adapt_04_QingOptica_1e3.m> run.log
