#!/bin/bash -l
#SBATCH -N 1
#SBATCH -c 1
#SBATCH -n 4
#SBATCH -p short
#SBATCH --time=10:00

# Ensure cleanworking dir
rm -rf ~/bigdata/Projects/castep
mkdir -p ~/bigdata/Projects/castep

# Move to working dir
cd ~/bigdata/Projects/castep

# Get data
wget http://www.castep.org/files/Si2.tgz

# Extract data
tar -xf Si2.tgz

# Move to data
cd Si2

# Clear default modules
module purge
# Load common modules
module load slurm hpcc_user_utils

# Load module based on CPU type
if [[ $(cpu_type) == "intel" ]] || [[ $(cpu_type) == "xeon" ]]; then
    echo "Loading intel"
    module load castep/19.11_intel-2017
else
    echo "Loading gcc"
    module load castep/19.11_gcc-8.3.0
fi

# Run with mpi
mpirun -n 4 castep.mpi Si2
