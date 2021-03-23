#!/usr/bin/bash

#SBATCH -p short -N 1 -n 4 --mem 2gb --out hmmsearch_COX1.log

module load hmmer/3.3
module load db-pfam/34.0

hmmfetch $PFAM_DB/Pfam-A.hmm COX1 > COX1.hmm
mkdir -p results
hmmsearch --cut_ga --domtbl results/hmmsearch_COX1.domtbl COX1.hmm query/query.pep > results/hmmsearch_COX1.hmmer
