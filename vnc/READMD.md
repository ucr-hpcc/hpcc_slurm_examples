# VNC

Submit this job like so:

```bash
sbatch vnc_job.sh
```

Then check to see if the job is running:

```bash
squeue -u $USER
```

Once the job has started check the slurm log to see which port and compute node is used:

```bash
cat vnc_job-*.out
```

