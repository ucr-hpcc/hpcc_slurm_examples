#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=16
#SBATCH --mem=10G
##SBATCH --mail-user=email@address.com
##SBATCH --mail-type=ALL
#SBATCH --time=7-00:00:00
#SBATCH --job-name="vasp"
#SBATCH -p intel

module -s load vasp/5.4.1_oneapi-2022.1.2.146
export OMP_NUM_THREADS=1
ulimit -s unlimited
mpirun -n 16 vasp_std

