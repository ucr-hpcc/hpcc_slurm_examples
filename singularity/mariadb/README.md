# MariaDB & MySQL
## Initialize Database
The easiest way to create a SQL database is to run the following script:

```bash
create_mysql_db
```

Or you can download the latest version from here: [create_mysql_db.sh](create_mysql_db.sh)
This will walk you through the steps to create your own database using a singularity container.

## Starting Database
Once you have completed that, you should be able to submit a job to start your databases.

First download the startup job script from here: [start_mariadb.sh](start_mariadb.sh) and modify where necessary.

Then submit this just like any other job, like so:

```bash
sbatch start_mariadb.sh
```

After running the startup job you should have a log file called `mariadb.log` in the directory where you created your `mariadb.sif` file.
This log file should contain the host and the port where your job is running, which can be used for your database connections.
