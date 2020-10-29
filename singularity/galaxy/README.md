# Galaxy

## Prep Workspace

Since `Galaxy` requires write access to the `config` and `database` direcotries we need to copy them out of the container.
Once we have copies of these directories we will then mount them inside the container.

#### Copy Files from Container

```
module load galaxy
singularity exec $GALAXY_IMG rsync -r /opt/galaxy/config/ $PWD/config
singularity exec $GALAXY_IMG rsync -r /opt/galaxy/database/ $PWD/config
```

## Run Galaxy Job

```
sbatch -p short -c 24 --mem=100gb --job-name='galaxy' --wrap='module load galaxy; galaxy'
```

## SSH Tunnel

After the galaxy job has started collect the node and port details and follow these instructions [Web Browser Access](https://hpcc.ucr.edu/manuals_linux-cluster_jobs.html#web-browser-access).
