#!/usr/bin/bash

#SBATCH -p short --ntasks 72 --mem 32gb --out hmmsearch_mpi_db.%A.log

module load hmmer/3.3-mpi
module load db-pfam/34.0

mkdir -p results

time srun hmmsearch --mpi --cut_ga --domtbl results/hmmsearch_MPI.domtbl $PFAM_DB/Pfam-A.hmm  query/query.pep > results/hmmsearch_MPI.hmmer
