# R

Here is a basic example on how you can submit R code to the cluster.

Make sure your `job_wrapper.sh` and `myRscript.R` files are in the same directory, and then submit your wrapper from that directory:

```bash
# Make example directory
mkdir ~/R_example
cd ~/R_example

# Download example scripts
wget https://github.com/ucr-hpcc/hpcc_slurm_examples/blob/master/R/job_wrapper.sh
wget https://github.com/ucr-hpcc/hpcc_slurm_examples/blob/master/R/myRscript.R

# Submit wrapper
sbatch job_wrapper.sh
```
