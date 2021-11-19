
## Simple Method: Submitting Job Script

To submit a job from the cluster, you can use [submission_script.sh](submission_script.sh) or [submission_script2.sh](submission_script2.sh) as a starting point.

## Copy examples

This involved you copying the text inside the [submission_script.sh](submission_script.sh) and pasting it into a file on the cluster.
1. [Login to the cluster](https://hpcc.ucr.edu/manuals_linux-basics_intro#how-to-get-access)
2. Once logged in you can run
```bash
wget https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/matlab/submission_script.sh
```

## Advance Method: Submitting Job From Matlab

To submit a job from your matlab program to the cluster, you can view [Getting_Started_With_Serial_And_Parallel_MATLAB.pdf](Getting_Started_With_Serial_And_Parallel_MATLAB.pdf)
If you are getting an error when running **configCluster**, run **rehash toolboxcache** and then run **configCluster** again.
