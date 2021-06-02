#!/bin/bash -l

#SBATCH -c 48                             # Request all CPUs, use only: floor(AVAIL_RAM_GB/9)
#SBATCH --mem=432g                        # Request RAM, calculated by: floor(AVAIL_RAM_GB/9)*9
#SBATCH --time=2-00:00:00                 # Run for 2 days
#SBATCH -p gpu                            # Submit to GPU partition
#SBATCH --gpus=8                          # Request 4 GPUs
##SBATCH --nodelist=gpu01                  # Request specific node
#SBATCH --exclude=gpu[01-02],gpu05        # Exclude heterogeneous nodes
#SBATCH --exclusive                       # This job gets whole node

# Load software
module load gaussian/16_AVX2

# Use auto temp directory
module load workspace/scratch
export GAUSS_SCRDIR=${SCRATCH}

# Move to working directory 
cd ~/bigdata/Projects/gaussian/gpu/

# Run Gaussian on specific CPUs
g16 -c="0-48" -m="432GB" -g="0-7=0-1,24-25,12-13,36-37" ch4_opt.gjf
