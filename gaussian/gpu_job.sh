#!/bin/bash -l

#SBATCH -c 32              # Request all CPUs
#SBATCH --mem=108g         # RAM is calculated: 9GB x #CPUs
#SBATCH --time=2-00:00:00  # Run for 2 days
#SBATCH -p gpu             # Submit to GPU partition
#SBATCH --gpus=4           # Request 4 GPUs
#SBATCH --nodelist=gpu02   # Request specific node
#SBATCH --exclusive        # This job gets whole node

# Load software
module load gaussian/16

# Create temp directory
export GAUSS_SCRDIR=/scratch/${USER}/${SLURM_JOB_ID}
mkdir -p ${GAUSS_SCRDIR}

# Move to working directory 
cd ~/bigdata/Projects/gaussian/gpu/

# Run Gaussian on specific CPUs
g16 -c="0-5,8-13" -m="108GB" -g="0-3=1-2,8-9" ch4_opt.gjf

# Delete old temp files
rm -rf ${GAUSS_SCRDIR}
