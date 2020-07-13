# ToDo

# Basic example

``` bash
wget https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/rstudio-server/start-rserver.sh
chmod u+x start-rserver.sh
sbatch -p batch --time=8:00:00 --mem=10gb --cpus-per-task=1 --wrap="./start-rserver.sh"
cat slurm-JOBID.out
```

Remember to replace JOBID with the real JOBID from `squeue -u $USER` command.

