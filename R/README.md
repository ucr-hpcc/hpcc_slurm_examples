# R

Here is a basic example on how you can submit R code to the cluster.

Make sure your `job_wrapper.sh` and `myRscript.R` files are in the same directory, and then submit your wrapper from that directory:

Make example directory

```bash
mkdir ~/R_example
cd ~/R_example
```

Download example scripts

```bash
wget https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/R/job_wrapper.sh
wget https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/R/myRscript.R
```

Submit wrapper
```
sbatch job_wrapper.sh
```

> NOTE: When using a real analysis you will may need to adjust the SBATCH resource requests within the `job_wrapper.sh` before submitting it.
