# Gaussian

Here are various examples of job submission scripts for Gaussian 9 and 16.

More information regarding general job submission can be found [here](https://hpcc.ucr.edu/manuals/hpc_cluster/jobs/#submitting-jobs).

## CPU

```
# Download example
wget https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/gaussian/cpu_job.sh

# Make changes as needed
vim cpu_job.sh

# Submit job
sbatch cpu_job.sh
```

## GPU

For GPU jobs there ere are several hardware configurations:

| Type | Qty |
------|------
| P100 | 2 |
| K80 | 4 |
| K80 | 8 |

Choose the correct example submission script to match the hardware you wish to use.

```
# Download 2 x P100 example
wget https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/gaussian/gpu_2xp100_job.sh

# Make changes as needed
vim gpu_2xp100_job.sh

# Submit job
sbatch gpu_2xp100_job.sh
```
