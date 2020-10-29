# Galaxy

> TODO: Note that this is a work in progress.

## Prep Workspace

Since `Galaxy` requires write access to the `config` and `database` direcotries we need to copy them out of the container.
Once we have copies of these directories we will then mount them inside the container.

#### Copy Files from Container

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

```
sbatch -p short -c 24 --mem=100gb --job-name='galaxy' --wrap='module load galaxy; galaxy'
```

## SSH Tunnel

After the galaxy job has started collect the node and port details and follow these instructions [Web Browser Access](https://hpcc.ucr.edu/manuals_linux-cluster_jobs.html#web-browser-access).
