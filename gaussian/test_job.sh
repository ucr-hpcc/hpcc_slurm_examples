#!/bin/bash -l

#SBATCH -c 10
#SBATCH --mem=10g
#SBATCH --time=2:00:00
#SBATCH -p short

module load gaussian
cd ~/bigdata/Projects/gaussian/
g09 ch4_opt.gjf

