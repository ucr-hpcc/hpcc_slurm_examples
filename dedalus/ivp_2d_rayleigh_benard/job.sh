#!/bin/bash -l

#SBATCH -N 1
#SBATCH -n 4
#SBATCH -c 1
#SBATCH -p short
#SBATCH --mem=50gb

# Load dedalus
module load dedalus

# Disable threading
export OMP_NUM_THREADS=1

# Run dedalus code
mpiexec python3 rayleigh_benard.py
mpiexec python3 plot_snapshots.py snapshots/*.h5
