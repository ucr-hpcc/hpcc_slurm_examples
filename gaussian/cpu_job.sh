#!/bin/bash -l

#SBATCH -c 10
#SBATCH --mem=10g
#SBATCH --time=2:00:00
#SBATCH -p short

# Load software based on CPU
if [[ $(cpu_type) == "intel" ]] || [[ $(cpu_type) == "xeon" ]]; then
    module load gaussian/16_AVX2
else
    module load gaussian/16_SSE4
fi

# Set scratch directory
module load workspace/scratch
export GAUSS_SCRDIR=${SCRATCH}

# Move to working directory 
cd ~/bigdata/Projects/gaussian/

# Run Gaussian
g16 ch4_opt.gjf
