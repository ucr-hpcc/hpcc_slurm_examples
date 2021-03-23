
# DESCRIPTION

Show how to use HMMER, and MPI hmmer on the HPCC system

# EXAMPLES

Query files are in the `query` directory - there is a script `download.sh` which demonstrates how the data were downloaded from UniProt db.

All the scripts are in the [pipeline](pipeline) folder so you can browse the working code.

## Basic usage for Pfam DB searching

1. Run hmmscan of a db of proteins against the Pfam database using the default Pfam, defaults to using the default hmmer software (3.2.1).

Note that latest version is 3.3 so it is a good idea to also specify a version in your module load to be explicit about the version you want

```
sbatch -p short pipeline/01_hmmscan321_pfam34.sh
```

2. Run hmmscan as above but use a specific version of HMMer so we can use 3.3

```
sbatch -p short pipeline/01_hmmscan33_pfam34.sh
```

3. Run hmmscan with an older version of Pfam (eg let's use version 31.0)

```
sbatch -p short pipeline/01_hmmscan33_pfam31.sh
```

If you compare these results you'll see the E-values and result in the `domtbl` files are not different between HMMer versions (that's good!) but if you compare different DB versions values will have changed slighted.

```
# compare the diff Pfam DB versions
diff results/hmmscan33_pfam31.domtbl results/hmmscan33_pfam34.domtbl

# compare the diff HMMer versions - only things different are the version numbers and date run
diff results/hmmscan321_pfam34.domtbl results/hmmscan33_pfam34.domtbl
```

## Fetch an HMM

Let's get a specific HMM module from the DB and also search that HMM against a database of proteins using hmmsearch.
This can be some cut and paste cmdline below

```
module load hmmer/3.3
module load db-pfam/34.0

hmmfetch $PFAM_DB/Pfam-A.hmm COX1 > COX1.hmm
```

1. Here's a script which requests a specific HMM from Pfam DB and then searches it against a db of proteins

```
sbatch -p short pipeline/02_hmmsearch_COX1.sh
```

## Run MPI HMMscan

Following Sean Eddy's input on ways to take advantage of MPI speedup and ways to maximize fast running of HMMer
http://cryptogenomicon.org/hmmscan-vs-hmmsearch-speed-the-numerology.html

Here is a script which will startup an MPI job, we are going to run hmmsearch instead of hmmscan and show how MPI can be used.
This example is for a few proteins only, but the real speedup would be seen with a large genome or translated metagenome.

See the script [pipeline/03_hmmsearch_MPI.sh](pipeline/03_hmmsearch_MPI.sh) for more details but it uses the `srun` command when launching the hmmsearch but the resources requested are in the `#SBATCH` or cmdline requested options which set the number of CPUs to use.

The current example is a bit of a toy one but if you want to compare you can try running against a large protein DB and see the performance differences to standard multithreaded runs of hmmsearch or hmmscan searches.
```
sbatch -p short pipeline/03_hmmsearch_MPI.sh
```

AUTHORS
======
Jason Stajich - jason.stajich[AT]ucr.edu
