#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0-00:15:00     # 15 minutes
##SBATCH --output=my.stdout
##SBATCH --mail-user=jhayes@ucr.edu
##SBATCH --mail-type=ALL
##SBATCH --job-name="just_a_test"

echo "Processing task ${SLURM_ARRAY_TASK_ID}"

# Get input value from file
input=$(sed -n "${SLURM_ARRAY_TASK_ID}p" inputs.txt)

# Run a command with input, replace "echo" with real command
echo $input
