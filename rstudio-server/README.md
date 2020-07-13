# RStudio Server
First review the following method, [HPCC Web Browser Access](https://hpcc.ucr.edu/manuals_linux-cluster_jobs.html#web-browser-access).
After you have read through that, you can procceed with this example.


## Basic Example

Request resource on a compute node:
```bash
srun -p batch --time=8:00:00 --mem=10gb --cpus-per-task=1 --pty bash -l
```

Download startup script:
```bash
wget https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/rstudio-server/start-rserver.sh
```

Allow execute permissions:
```bash
chmod u+x start-rserver.sh
```

Start RStudio with script
```bash
./start-rserver.sh
```

Follow instructions given on screen.
