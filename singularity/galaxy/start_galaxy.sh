#!/bin/bash -l
module load singularity

singularity exec \
    -B /YOUR_COPY_OF_GALAXY/database:/opt/galaxy/20.05/database \
    -B /YOUR_COPY_OF_GALAXY/config:/opt/galaxy/20.05/config galaxy.sing \
    /opt/galaxy/20.05/run.sh

