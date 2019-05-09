#!/bin/bash -l

#SBATCH --nodes=1                    # 1 intel node
#SBATCH --ntasks=16                  # 16 Cores
#SBATCH --mem-per-cpu=50G            # 50 GB of RAM
#SBATCH --time=7-00:00:00            # 7 days
#SBATCH --output=my.stdout           # Standard output file
#SBATCH --mail-user=email@domain.com # Your email
#SBATCH --mail-type=ALL              # Send mail on start,fail,complete
#SBATCH --job-name="Fluent Job"      # Name of Job
#SBATCH -p gpu                       # Use gpu nodes
#SBATCH --gres=gpu:1                 # Use 1 gpu

# Load ansys
module load ansys

# ToDo
# Need examples
# Here is a good reference:
#https://www.sharcnet.ca/Software/Ansys/16.2.3/en-us/help/flu_ug/flu_ug_sec_parallel_unix_command.html

# Usage
#fluent version -tnprocs [-gpgpu=ngpgpus ] [-pinterconnect ] [-mpi=mpi_type ] -cnf=hosts_file

