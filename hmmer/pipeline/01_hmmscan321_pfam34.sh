#!/usr/bin/bash

#SBATCH -p short -N 1 -n 4 --mem 2gb --out hmmscan321_pfam34.log

module load hmmer/3.2.1
module load db-pfam/34.0

mkdir -p results
hmmscan --cut_ga --domtbl results/hmmscan321_pfam34.domtbl $PFAM_DB/Pfam-A.hmm query/query.pep > results/hmmscan321_pfam34.hmmer
