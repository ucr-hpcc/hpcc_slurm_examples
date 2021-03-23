#!/usr/bin/bash

#SBATCH -p short -N 1 -n 4 --mem 2gb --out hmmscan33_pfam31.log

module load hmmer/3.3
module load db-pfam/31.0

mkdir -p results
hmmscan --cut_ga --domtbl results/hmmscan33_pfam31.domtbl $PFAM_DB/Pfam-A.hmm query/query.pep > results/hmmscan33_pfam31.hmmer
