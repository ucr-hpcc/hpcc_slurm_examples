#!/bin/bash
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --time=1:00:00
#SBATCH --job-name=jupyter-notebook
#SBATCH --output=jupyter-notebook-%J.log

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

# load modules or conda environments here
module unload miniconda2
module load anaconda3

echo -e "PLEASE USE GENERATED URL BELOW IN BROWSER\nYOU MUST REPLACE '${node}' with 'localhost'"
jupyter-lab --no-browser --port=${port} --ip=${node}

