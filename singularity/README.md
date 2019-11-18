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

## Submit
Once you have setup you job you can submit it to the cluster with the following command:

```bash
wegt https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/singularity/metaerg_job.sh 
sbatch metaerg_job.sh
```

