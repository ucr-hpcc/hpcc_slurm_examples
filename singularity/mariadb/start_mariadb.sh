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
cd ~/bigdata/mysql/

# Get port and host name info and save it to a file
PORT=$(singularity exec --writable-tmpfs -B db/:/var/lib/mysql mariadb.sif grep -oP '^port = \K\d{4}' /etc/mysql/my.cnf | head -1)
echo $HOSTNAME $PORT > db_host_port.txt

# Start your mariadb like a service
singularity exec --writable-tmpfs -B db/:/var/lib/mysql mariadb.sif /usr/bin/mysqld_safe
