#!/bin/bash -l

#SBATCH -c 64                  # Request all CPUs, use only: floor(AVAIL_RAM_GB/9)
#SBATCH --mem=180g             # Request RAM, calculated by: floor(AVAIL_RAM_GB/9)*9
#SBATCH --time=2-00:00:00      # Run for 2 days
#SBATCH -p gpu                 # Submit to GPU partition
#SBATCH --gpus=2               # Request 4 GPUs
##SBATCH --nodelist=gpu01       # Request specific node
#SBATCH --exclude=gpu[01-04]   # Exclude heterogeneous nodes
#SBATCH --exclusive            # This job gets whole node

# Load software
module load gaussian/16_AVX2

# Create temp directory
module load workspace/scratch
export GAUSS_SCRDIR=${SCRATCH}

# Move to working directory 
cd ~/bigdata/Projects/gaussian/gpu/

# Run Gaussian on specific CPUs
g16 -c="0-20" -m="189GB" -g="0-1=0,16" ch4_opt.gjf
