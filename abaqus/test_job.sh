#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --mem=10G
#SBATCH --time=1-00:15:00     # 1 day and 15 minutes
#SBATCH --mail-user=useremail@address.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="just_a_test"
#SBATCH -p epyc # You can use any of the following; epyc, intel, batch, highmem, gpu

# Unset this variable, since Abaqus errors when it is set
export SLURM_GTIDS=

# Load software
module load abaqus

# Run abaqus
abaqus job="Ball" input=./Balldrop_phillips_benchmark.inp interactive

# Other useful options for abaqus:
#   parallel_mode=MPI
#   mp_mode={mpi | threads}
#   gpus=number-of-gpgpus
#   memory=memory-size
#   interactive
#   scratch=scratch-dir
#   timeout=co-simulation timeout value in seconds

