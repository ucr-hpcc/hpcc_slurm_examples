# Galaxy

Outlined below is how to install Galaxy using conda and then run subsequent jobs.
Please note that differring version of conda may cause issues, please stay with the default `miniconda2`.

## Prep

Since Galaxy can get very large, configure conda to install environments under your bigdata described here [Conda Configure](https://hpcc.ucr.edu/manuals_linux-cluster_package-manage.html#configure).

## Request Job

We need to do the install from a job, so lets request one:

```bash
srun -p short -c 4 --mem=10g --pty bash -l
```

## Install

Now that we have a job, run the following to install Galaxy:

```bash
mkdir -p ~/bigdata/galaxy/
cd ~/bigdata/galaxy/
git clone -b release_20.05 https://github.com/galaxyproject/galaxy.git 20.05
cd 20.05
sh scripts/common_startup.sh
exit
```

## Run Galaxy

To run we will need to submit a new job, like this:

```bash
sbatch -p short -c 4 --mem=10g --wrap='cd ~/bigdata/galaxy/20.05; ./run.sh start; sleep infinity;'
```
