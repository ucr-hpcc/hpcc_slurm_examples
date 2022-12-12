# RStudio Server

First review the following method, [HPCC Web Browser Access](https://hpcc.ucr.edu/manuals_linux-cluster_jobs.html#web-browser-access).
After you have read through that, you can procceed with this example.

## Interactive

The easist method is to run the RStudio Server launcher interactivly.

First request an interactive job:

```bash
srun --partition=short --mem=8gb --cpus-per-task=2 --ntasks=1 --time=2:00:00 --pty bash -l
```
   
Then load the latest versions of `R` and `RStudio Server` from module system:

```bash
module unload R
module load R/4.1.2 # Or latest version
module load rstudio-server/2022.02.0-443 # Or latest version
```

Lastly, start the RStudio Server by running the launcher script:
   
```sh
start-rserver.sh
```

## Non-Interactive

Alternativly as you can start an RStudio Server under a non-interactive job, like so:

```bash
sbatch -p short -c 4 --time=2:00:00 --mem=10g --wrap='module unload R; module load R/4.1.2; module load rstudio-server/2022.02.0-443; start-rserver.sh' --output='rstudio-%J.out'
```

These are minimal resources, for only 2 hours, so you may need to adjust them.
When the job starts, you can look at the slurm log to check which node it is running on and how to setup your SSH tunnel:

```bash
cat rstudio*.out
```

## Custom Launcher (EXPERT)

If you want to modify the RStudio Server launch script, you can download a copy from here and modify it.

Request resource on a compute node:

```bash
srun -p batch --time=8:00:00 --mem=10gb --cpus-per-task=1 --pty bash -l
```

Download startup script:

```bash
wget https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/rstudio-server/start-rserver.sh
```

Allow execute permissions and then modify as needed:

```bash
chmod u+x start-rserver.sh
vim start-rserver.sh
```

Start RStudio with script:

```bash
./start-rserver.sh
```

Follow instructions given on screen.
