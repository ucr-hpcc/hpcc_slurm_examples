#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --time=1:00:00
#SBATCH --job-name=jupyter-notebook
#SBATCH --output=jupyter-notebook-%J.log

# Load and base conda
module load miniconda3

# Load jupyterlab
module load jupyterlab
# OR activare your own conda environment
#conda activate myCondaEnv

# Execute the notebook and generate HTML (notebook.html) as output file
jupyter nbconvert --to html --execute notebook.ipynb
# OR execute the notebook and generate another notebook (notebook.nbconvert.ipynb) as output file
#jupyter nbconvert --to notebook --execute notebook.ipynb

# There are many output formats, list all possible options with this
#jupyter nbconvert --help-all
