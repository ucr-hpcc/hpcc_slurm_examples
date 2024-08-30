#!/bin/bash -l

#SBATCH --nodes=1             # 1 node
#SBATCH --ntasks=16           # 16 Cores
#SBATCH --mem-per-cpu=50G    # 50 GB of RAM
#SBATCH --time=7-00:00:00     # 7 days
#SBATCH --output=my.stdout    # Standard output file
#SBATCH --mail-user=useremail@address.com # Your email
#SBATCH --mail-type=ALL       # Send mail on start,fail,complete
#SBATCH --job-name="CFX Job"  # Name of Job
#SBATCH -p epyc              # Use epyc nodes 

# Load samtools
module load ansys

# Do work 
cfx5solve -partition 16 -s 51200M -scat 1.5x -def Transient.def -ini Transient.res

