#!/bin/bash -l

#SBATCH -c 12
#SBATCH --mem=108g          # 
#SBATCH --time=2-00:00:00
#SBATCH -p gpu
#SBATCH --gpus=4
#SBATCH --nodelist=gpu02

# Load software
module load gaussian/16

# Create temp directory
export GAUSS_SCRDIR=/scratch/${USER}/${SLURM_JOB_ID}
mkdir -p ${GAUSS_SCRDIR}

# Move to working directory 
cd ~/bigdata/Projects/gaussian/gpu/

# Run Gaussian on specific CPUs
srun --cpu-bind=0-5,8-13 g16 -c="0-5,8-13" -m="108GB" -g="0-3=1-2,8-9" ch4_opt.gjf

# Delete old temp files
rm -rf ${GAUSS_SCRDIR}
