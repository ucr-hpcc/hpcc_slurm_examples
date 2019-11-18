# Singularity Metaerg Container
Singularity container built from docker image: [https://github.com/xiaoli-dong/metaerg](https://github.com/xiaoli-dong/metaerg)

## Setup
Choose where you would like your analysis to be saved, typically a sub-directory under bigdata:

```bash
mkdir ~/bigdata/metaerg
cd ~/bigdata/metaerg
```

Ensure that you have a directory called `data` in the current directory:

```
mkdir data
```

Also ensure that you have a fasta file called `contig.fasta` in the `data` directory:

```bash
cp /path/to/contig.fasta data/contig.fasta
```

## Script
In order to submit this job in a non-interactive way, we will need to create a submission script.
Download the submission script and edit based on your needs:

```bash
wget https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/singularity/metaerg_job.sh
nano metaerg_job.sh # You could also use vim/emacs or other text editor
```

## Submit
Once you have setup your data directory and updated your submission script, you can submit your job to the cluster with the following command:

```bash
sbatch metaerg_job.sh
```

