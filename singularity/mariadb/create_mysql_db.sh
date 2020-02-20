#!/bin/bash -l

module load singularity

# Get path to db files
echo -en "\nEnter path for new database files [${PWD}/mysql]: "
read db_path
if [[ -z $db_path ]]; then
    db_path=${PWD}/mysql
fi
echo -e "Using DB path: ${db_path}\n"

# Check if db_path is valid
if [[ -d $db_path ]]; then
    echo -e "ERROR: Database path ${db_path} already exists\n"
    exit 1
else
    echo -e "Creating directory ${db_path}\n"
    mkdir -p ${db_path} && cd ${db_path}
fi

echo -n "Enter name for database [workdb]: "
read db_name
if [[ -z $db_name ]]; then
    db_name="workdb"
fi
echo -e "Using DB name: ${db_name}\n"

# Get DB pasnamed
echo -n "Enter MySQL Password: "
read -s db_pass
echo -e "\n"

# Get port (hope it is not used)
db_port=$(shuf -i3000-3999 -n1)

# Make sure a password was given (Add more robust checks here)
if [[ -z $db_pass ]]; then
    echo "ERROR: You cannot have an empty MySQL password."
    exit 1
fi

# Remote login so that sudo is not required for build
echo "Attempting remote login..."
if [[ ! -f ~/.singularity/remote.yaml ]] || [[ ! -s ~/.singularity/remote.yaml ]]; then
    singularity remote login; EXITCODE=$?
fi

# If remote login failed, advise user
if [[ $EXITCODE -ne 0 ]]; then
    echo -e "\n
ERROR: singularity remote login failed.
Delete ~/.singularity/remote.yaml.
Then generate new access token here https://cloud.sylabs.io/auth.
Then try this script again with the new token.\n"
    exit 1
fi

# Create singularity definition
cat << EOF > mariadb.def
Bootstrap: docker
From: mariadb:10.3.9

%post
# Your username
YOUR_USERNAME="${USER}"

sed -ie "s/^#user.*/user = ${USER}/" /etc/mysql/my.cnf
sed -ie "s/^port.*/port = ${db_port}/" /etc/mysql/my.cnf
chmod 1777 /run/mysqld

%runscript
exec "mysqld" "$@"

%startscript
exec "mysqld_safe"
"""
EOF

# Build singularity image
singularity build --remote mariadb.sif mariadb.def

# Create directory where db files live
mkdir db

# Initialize db
singularity exec --writable-tmpfs -B db/:/var/lib/mysql mariadb.sif 'mysql_install_db' &> /dev/null
ERROR_CODE=$?
if [[ $ERROR_CODE -ne 0 ]]; then
    echo "ERROR: Database failed to initialize."
    exit 1
fi

# Create newuser script
cat << EOF > newuser.sh
#!/bin/sh

# Start mysql
mysqld_safe --datadir=/var/lib/mysql &
MYSQL_PID=\$!

# Give mysql time to startup
sleep 10

# Create work db and new user
mysql -u root mysql < newuser.sql

# Secure mysql
#mysql_secure_installation

# Update root password
mysqladmin -u root --port ${db_port} password "${db_pass}"

# Stop mysql
echo \$(date "+%y%m%d %T") "mysqld_safe Shutting down"
mysqladmin -u root --port=${db_port} --password="${db_pass}" shutdown 2>/dev/null || kill -9 \$MYSQL_PID
echo \$(date "+%y%m%d %T") "mysqld_safe Shutdown"

EOF

# Create newuser SQL file
cat << EOF > newuser.sql
CREATE DATABASE ${db_name};
CREATE USER '${USER}'@'%' IDENTIFIED BY "${db_pass}";
GRANT ALL PRIVILEGES ON *.* TO ${USER}@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# Make sure this is executable
chmod u+x newuser.sh

# Create newuser
singularity exec --writable-tmpfs -B db/:/var/lib/mysql mariadb.sif "${PWD}/newuser.sh"
rm -f newuser.sh newuser.sql

# Stop mysql service
#mysqladmin -u $USER -h $HOSTNAME --password="$db_pass" shutdown

# Create service instance
echo -e "\n
##########################################################################################
# IMPORTANT NOTES !!!
##########################################################################################

# Make sure you have loaded singularity:
     module load singularity

# To start your service, do the following:
     cd ${PWD}
     singularity instance start --writable-tmpfs -B db/:/var/lib/mysql mariadb.sif mysqldb

# To list your running services, run the following:
     singularity instance list

# To connect to your running service, run the following:
     mysql -u ${USER} -h ${HOSTNAME} -P ${db_port} -p ${db_name}

# To stop your service, run the following:
     singularity instance stop mysqldb

# To get a debug shell into your service, do the following:
     cd ${PWD}
     singularity instance stop mysqldb
     singularity shell --writable-tmpfs -B db/:/var/lib/mysql mariadb.sif

##########################################################################################\n"

