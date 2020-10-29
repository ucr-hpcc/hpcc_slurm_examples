# Galaxy

Install Galaxy using conda

## Prep

Since Galaxy can get very large, configure conda to install environments under your bigdata described here [Conda Configure](https://hpcc.ucr.edu/manuals_linux-cluster_package-manage.html#configure)

## Request Job

We need to do the install from a job, so lets request one:

```
srun -p short -c 4 --mem=10g --pty bash -l
```

## Install

Now that we have a job, run the following to install Galaxy:

```
mkdir -p ~/bigdata/galaxy/
cd ~/bigdata/galaxy/
git clone -b release_20.05 https://github.com/galaxyproject/galaxy.git 20.05
cd 20.05
sh scripts/common_startup.sh
```
