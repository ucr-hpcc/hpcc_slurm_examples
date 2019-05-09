#!/bin/bash -l

#SBATCH -c 10
#SBATCH --mem=10g
#SBATCH --time=2:00:00
#SBATCH -p short

module load ncbi-blast
cd ~/bigdata/Projects/blast_fasta/
blastp -num_threads 10 dsg sdgsdg dhfdh

