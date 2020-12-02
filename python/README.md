# Python

This is a basic example on how to submit Python code to the cluster.

Make sure your `job_wrapper.sh` and `myPyscript.py` files are in the same directory, and then submit your wrapper from that directory:

```
# Make example directory
mkdir ~/py_example
cd ~/py_example

# Download example scripts
wget https://github.com/ucr-hpcc/hpcc_slurm_examples/blob/master/python/job_py_wrapper.sh
wget https://github.com/ucr-hpcc/hpcc_slurm_examples/blob/master/python/myPyscript.py

# Submit wrapper
sbatch job_py_wrapper.sh
```
