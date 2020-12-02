#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --time=1-00:15:00     # 1 day and 15 minutes
#SBATCH --mail-user=useremail@address.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="Python Example"
#SBATCH -p intel              # This is the default partition, you can use any of the following; intel, batch, highmem, gpu

# A version of Python from miniconda2 is loaded by default
# However, if you want to use a diferent version, then do so here
#module unload miniconda2; module load anaconda3

# Optionaly you can activate a conda environment if you have created one
#conda activate python3

# Use Python3 to run Python script
python3 myPyscript.py
