#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=2:00:00
##SBATCH --mail-user=youremail@address.com
##SBATCH --mail-type=ALL
#SBATCH --job-name="just_a_test"
#SBATCH -p short # This is the default partition, you can use any of the following; intel, batch, highmem, gpu


# Load matlab
module load matlab

# Send Matlab code to Matlab
matlab -nodisplay -nodesktop < my_matlab_program.m

# You can also capture the output in a log, like this
#matlab -nodisplay -nosplash < my_matlab_program.m > matlab_run.log

