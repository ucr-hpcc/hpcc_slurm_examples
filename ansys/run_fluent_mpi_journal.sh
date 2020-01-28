#!/bin/bash -l
#SBATCH --ntasks=64
#SBATCH -t 20:00:00
#SBATCH --mem-per-cpu=6000

module load intel
module load ansys

#Get an unique temporary filename to use for our nodelist
FLUENTNODEFILE=$(mktemp)

#Output the nodes to our nodelist file
scontrol show hostnames > $FLUENTNODEFILE

#Display to us the nodes being used
echo "Running on nodes:"
cat $FLUENTNODEFILE

#Run fluent with the requested number of tasks on the assigned nodes
fluent 3ddp -g -t $SLURM_NTASKS -mpi=intel -ssh -cnf="$FLUENTNODEFILE" -i YOUR_JOU_FILE

#Clean up
rm $FLUENTNODEFILE
