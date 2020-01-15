# MariaDB & MySQL
The easiest way to create a SQL database is to run the following script:

```bash
create_mysql_db
```
This will walk you through the steps to create your own database using a singularity container.

Once you have completed that, you should be able to submit a job to start your databases.

First download the startup job script from here: [start_mariadb.sh](start_mariadb.sh) and modify where necessary.

Then submit this just like any other job, like so:

```bash
sbatch start_mariadb.sh
```

