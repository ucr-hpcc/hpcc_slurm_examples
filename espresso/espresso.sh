#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=6
#SBATCH --mem-per-cpu=1G


export OMP_NUM_THREADS=1

module load espresso/6.3

mpirun pw.x -in input_file.in >& output_file.out
