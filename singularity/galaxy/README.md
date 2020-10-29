# Galaxy

> Deprecated: Singularity is not required to install Galaxy, use conda instead [Galaxy via Conda](../../galaxy).

## Prep Workspace

Since `Galaxy` requires write access to the `config` and `database` direcotries we need to copy them out of the container.
Once we have copies of these directories we will then mount them inside the container.

### Create Galaxy Home

Create a home base for Galaxy:

```
mkdir -p bigdata/galaxy/20.05
cd bigdata/galaxy/20.05
```

#### Copy Files from Container

Copy databases and configs from in the container to Galaxy home:

```
module load galaxy
singularity exec $GALAXY_IMG rsync -r /opt/galaxy/config/ $PWD/config
singularity exec $GALAXY_IMG rsync -r /opt/galaxy/database/ $PWD/config
```

#### Configure Galaxy

Now that we have a writable copy of the configuration files and databases, we can make some changes.
Open the config and modify the port and IP address where Galaxy will start:

```
PORT=$(shuf -i8000-9999 -n1)
sed -i "s/^\s*http: .*/  http: 0.0.0.0:$PORT/" config/galaxy.yml
grep '^\s*http:' config/galaxy.yml
```

Also we want to want to add a our HPCC username for the administrator of Galaxy:

```
sed -i "s/^\s*#*admin_users: .*/  admin_users: ${USER}/" config/galaxy.yml
grep '^\s.*admin_users' config/galaxy.yml
```

## Run Galaxy Job

### Startup Script

Download startup script:

```
wget https://github.com/ucr-hpcc/hpcc_slurm_examples/blob/master/singularity/galaxy/start_galaxy.sh
```

Use nano or vim to edit script to use proper paths:

```
vim start_galaxy.sh
```

Then submit the script like so:

```
sbatch -p short -c 24 --mem=100gb start_galaxy.sh
```

## SSH Tunnel

After the galaxy job has started collect the node and port details and follow these instructions [Web Browser Access](https://hpcc.ucr.edu/manuals_linux-cluster_jobs.html#web-browser-access).
