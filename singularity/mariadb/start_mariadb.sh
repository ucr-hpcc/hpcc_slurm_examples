#!/bin/bash -l
#SBATCH -p batch,intel
#SBATCH --time=7-00:00:00
#SBATCH -c 2
#SBATCH --mem=10g

############################################################################
# NOTE:                                                                    #
# Make sure you have already run and completed the create_mysql_db command #
############################################################################

# Load singularity
module load singularity

# Move to where your mariadb.sif image lives
cd ~/bigdata/mariadb/

# Save file to indicate where mariadb is running
echo $HOSTNAME > mariadb.log
ps aux | grep "$USER.*mysql.*port.*" | grep -Po 'port=[0-9]{4}' | cut -d '=' -f2 >> mariadb.log

# Start your mariadb like a service
singularity instance start --writable-tmpfs -B db/:/var/lib/mysql mariadb.sif mysqldb
