#!/usr/bin/bash

#SBATCH -p short -N 1 -n 4 --mem 2gb --out hmmscan33_pfam34.log

module load hmmer/3.3
module load db-pfam/34.0

mkdir -p results
hmmscan --cut_ga --domtbl results/hmmscan33_pfam34.domtbl $PFAM_DB/Pfam-A.hmm query/query.pep > results/hmmscan33_pfam34.hmmer
