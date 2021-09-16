# Folddock

## Running

### Cluster

In order to run Folddock, you need to utilize the installed workflow under a `Singularity` container.

The [run_folddock.sh](run_folddock.sh) file is an example running AlphaFold on the HPCC.

Once downoaded and altered to your preferences, then you can just submit this script as a job, like so:

```bash
# Download
wget https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/folddock/run_folddock.sh

# Edit
vim run_folddock.sh

# Submit
sbatch run_folddock.sh
```
