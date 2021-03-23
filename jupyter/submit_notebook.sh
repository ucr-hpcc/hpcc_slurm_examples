#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --time=1:00:00
#SBATCH --job-name=jupyter-notebook
#SBATCH --output=jupyter-notebook-%J.log

# Jupyter vars
XDG_RUNTIME_DIR=""

####################################################
# Load modules or activate conda environments here #
####################################################
module unload miniconda2
module load miniconda3
conda activate jupyter

# Launch Jupyter lab or notebook
# Example below runs the notebook.ipynb and output to a file call notebook, it will append the .pdf suffix automatically
# To see a full list of option run 'jupyter nbconvert --help-all'
jupyter nbconvert --to pdf --execute notebook.ipynb --output notebook
