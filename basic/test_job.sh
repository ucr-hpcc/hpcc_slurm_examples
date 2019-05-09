#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --cpus-per-task=1
#SBATCH -p batch
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0-00:15:00     # 15 minutes
##SBATCH --output=my.stdout
##SBATCH --mail-user=jhayes@ucr.edu
##SBATCH --mail-type=ALL
##SBATCH --job-name="just_a_test"

srun date
srun sleep 60
srun hostname
