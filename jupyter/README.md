# Jupyter Example
First review the following method, [https://hpcc.ucr.edu/manuals_linux-cluster_jobs.html#web-browser-access](HPCC Web Browser Access)
After you have read through that, you can procceed with this example.

Download the Jupter submission script:
```bash
wget https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/jupyter/submit_jupyter.sh
```

Edit script with proper Slurm resources:
```bash
vim submit_jupyter.sh
``` 

Submit the Jupyter job:
```bash
sbatch submit_jupyter.sh
```

Check for Jupyter job start time and log
```bash
squeue -u $USER --start
```

If your job has started, then check the log, which will contain the remainder of your instructions:
```
cat jupyter-notebook-*.log
```
