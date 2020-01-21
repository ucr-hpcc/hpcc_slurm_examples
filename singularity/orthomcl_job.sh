#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=useremail@address.com
#SBATCH --time=4:00:00
#SBATCH --job-name=orthomcl
#SBATCH -p intel

module load singularity
module load orthomcl

# Go to database directory
cd ~/bigdata/mysql

# Start Database
PORT=$(singularity exec --writable-tmpfs -B db/:/var/lib/mysql mariadb.sif grep -oP '^port = \K\d{4}' /etc/mysql/my.cnf | head -1)
singularity instance start --writable-tmpfs -B db/:/var/lib/mysql mariadb.sif mysqldb
sleep 10

# Move to bigdata
cd ~/bigdata/

# Update Orthomcl.config
sed -i "s/^dbConnectString.*$/dbConnectString=dbi:mysql:orthomcl:${HOSTNAME}:${PORT}/" orthomcl/orthomcl.config

# Run orthomcl
orthomclInstallSchema orthomcl/orthomcl.config orthomcl/install_schema.log

# Stop Database
singularity instance stop mysqldb
