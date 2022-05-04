# Dedalus

> NOTE: This assumes you already know the basics of job managment.
> If not then please take the time to read through [HPC Cluster Jobs](https://hpcc.ucr.edu/manuals/hpc_cluster/jobs/).
> And/Or review the `Intro to HPCC` video from our [Events](https://hpcc.ucr.edu/events/small/) page.

Running Dedalus on the cluster is similar to any other software, you need to create a job submission script that acts as a wrapper for your Python code.
Look at the [job.sh](ivp_2d_rayleigh_benard/job.sh) submission script as an example.

You can see that when running Dedalus on the cluster you need to use mpiexec, however you do not need to pass the number of parallel proceses to `mpiexec`, since this is determined by your `Slurm` resouce request.

For example, we run Dedalus Python code, like so:

```bash
mpiexec python3 rayleigh_benard.py
```

Notice the omission of the `-n` flag above, compared to the below:

```bash
mpiexec -n 4 python3 rayleigh_benard.py
```

We do not need the `-n` MPI flag becuase our version of `OpenMPI` is compiled against `Slurm`.
Thus, the `--ntasks` or `-n` Slurm flag determines the number of parallel MPI processes and is automatically passed to `mpiexec`.

To scale this to more parallel processes, we just increase the number of tasks:

```
#SBATCH --ntasks=32
```

Since most nodes are capaible of 64 parallel processes we could request up to 64 tasks max.
However, requesting more than 32 tasks may increase the queue wait time, the trade off here is up to you.

If you need more than 64 parallel processes, you can increase the number of nodes:

```bash
#SBATCH -N 2
#SBATCH --ntasks=64
```

The above would request 64 total parallel processes, but it would distribute them across 2 nodes.

The maximum number of parallel processes you can request is determined by your Slurm limits.
You can check your Slurm limits with the following command:

```bash
slurm_limits
```

Look for the `cpu=X` notation corresponding to the partition you are submitting to.
Where `X` is the maximum number of parallel processes for your account on a particular parition.

Lastly, do not forget to disable threading before calling `mpiexec`:

```bash
export OMP_NUM_THREADS=1
```
