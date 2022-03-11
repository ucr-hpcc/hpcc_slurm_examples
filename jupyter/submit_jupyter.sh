#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --time=1:00:00
#SBATCH --job-name=jupyter-notebook
#SBATCH --output=jupyter-notebook-%J.log

# Change to HOME dir to give access to all folders within Jupyter-Lab
cd $HOME

# Jupyter vars
XDG_RUNTIME_DIR=""

# Get tunneling info
port=$(shuf -i8000-9999 -n1)
node=$(hostname -s)
user=$(whoami)
cluster=$(hostname -f | awk -F"." '{print $2}')

# Print tunneling instructions jupyter-log
echo -e "
MacOS or linux terminal command to create your ssh tunnel:
ssh -NL ${port}:${node}:${port} ${user}@cluster.hpcc.ucr.edu

MS Windows MobaXterm info:

Forwarded port:same as remote port
Remote server: ${node}
Remote port: ${port}
SSH server: cluster.hpcc.ucr.edu
SSH login: $user
SSH port: 22
"

####################################################
# Load modules or activate conda environments here #
####################################################

# You can activate your own conda env with Jupyter
#module load miniconda3
#conda activate jupyter
#OR
# Load the pre installed system version
module load jupyter

# Print instructions to user
echo -e "PLEASE USE GENERATED URL BELOW IN BROWSER\nYOU MUST REPLACE '${node}' with 'localhost'"

# Launch Jupyter lab or notebook
jupyter-lab --no-browser --port=${port} --ip=${node}
#jupyter-notebook --no-browser --port=${port} --ip=${node}
