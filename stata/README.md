# STATA

Here is a basic example on how you can submit STATA code to the cluster.

Make sure your `submit.sh` and `test.do` files are in the same directory, and then submit your job from that directory:

1. Make example directory

```bash
mkdir ~/R_example
cd ~/R_example
```

2. Download example scripts

```bash
wget https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/STATA/submit.sh
wget https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/STATA/test.do
```

3. Submit job

```
sbatch submit.sh
```

> NOTE: When submitting a real STATA job will need to adjust the `#SBATCH` resource requests within the `submit.sh` before submitting it.
