#!/usr/bin/bash
curl -O https://www.uniprot.org/uniprot/Q8RXC8.fasta
curl -O https://www.uniprot.org/uniprot/P49791.fasta
curl -O https://www.uniprot.org/uniprot/A0A2H4MYE5.fasta

cat *.fasta > query.pep
