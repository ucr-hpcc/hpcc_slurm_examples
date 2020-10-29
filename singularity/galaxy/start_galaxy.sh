#!/bin/bash -l

# Load Galaxy
module load galaxy

# Set Galaxy Home
GALAXY_HOME=~/bigdata/galaxy/20.05

singularity exec \
    -B $GALAXY_HOME/database:/opt/galaxy/20.05/database \
    -B $GALAXY_HOME/config:/opt/galaxy/20.05/config \
    $GALAXY_IMG \
    /opt/galaxy/20.05/run.sh
