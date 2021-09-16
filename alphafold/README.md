# AlphaFold

## Running

### Cluster

In order to run AlphaFold, you need to utilize the installed workflow under a `Singularity` container.

The [run_alphafold_cle.sh](run_alphafold_cle.sh) file is an example running AlphaFold on the HPCC.

Once downoaded and altered to your preferences, then you can just submit this script as a job, like so:

```bash
# Download
wget https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/alphafold/run_alphafold_cle.sh

# Edit
vim run_alphafold_cle.sh

# Submit
sbatch run_alphafold_cle.sh
```

## Jupyter

The `Singularity` container can also be used within our [Jupyter](https://jupyter.hpcc.ucr.edu) service.

All that is required is that you download the [kernal.json](kernal.json) file and place it under the following directory:

```bash
# Download
wget https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/alphafold/kernal.json

# Create directory
mkdir -p ~/.local/share/jupyter/kernels/alphafold

# Move kernel
mv kernel.json ~/.local/share/jupyter/kernels/alphafold/kernel.json
```
