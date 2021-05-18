
## Simpler method: Submitting job from the cluster
To submit a job from the cluster, you can use [submission_script.sh](submission_script.sh) or [submission_script2.sh](submission_script2.sh) as a starting point.
### How to login to the cluster
You can use this guide on how to login to the cluster https://hpcc.ucr.edu/manuals_linux-basics_intro#how-to-get-access

### How to copy the submission_script to the cluster
There are multiple ways of doing this

#### Copy and paste
This involved you copying the text inside the [submission_script.sh](submission_script.sh) and pasting it into a file on the cluster.
1. [Login to the cluster](https://hpcc.ucr.edu/manuals_linux-basics_intro#how-to-get-access)
2. Once logged in you can run
```bash
nano submission_script.sh
```
3. Right click on the terminal (mobaxterm, Terminal, or item2) and click on paste.
4. If you are on windows, press **Ctrl+x** on windows, or **Command+x** on mac, and then press **y** and finally press **Enter**  to save.
5. If you want to edit the file again, just run **nano** command on the file again.
6. If you want to rename the file you can run
```bash
mv submission_script.sh some_new_name
```
7. if you want to delete the file you can run
```bash
rm submission_script.sh
```
#### Using a file transfer client
1. Download [submission_script.sh](submission_script.sh) or [submission_script2.sh](submission_script2.sh) to your computer, and modify it to your need. You can view [Linux Cluster - Managing Jobs](https://hpcc.ucr.edu/manuals_linux-cluster_jobs.html) for more information.
2. Download [Filezilla](https://filezilla-project.org/) and install it on your computer.
3. Start the Filezilla program on your computer.
4. On top, there are a few area you can type in, set the **host** to **sftp://cluster.hpcc.ucr.edu**, and fill out username and password on the appropriate boxes.
5. It might ask you if you want to save your password, I recommend that you don't save your password, by clicking on **Do not save passwords**
6. On the left half of the Filezilla program are location on your computer, navigate to where you have downloaded [submission_script.sh](submission_script.sh) or [submission_script2.sh](submission_script2.sh).
7. Once you have found the file [submission_script.sh](submission_script.sh) or [submission_script2.sh](submission_script2.sh) on your computer, you can drag it to the right side of Filezilla to transfer it over. You can do the same with your matlab script.

### Submitting a job
#### What is a Job?
Submitting and managing jobs is at the heart of using the cluster. A ‘job’ refers to the script, pipeline or experiment that you run on the nodes in the cluster.
#### Submitting Jobs

There are 2 basic ways to submit jobs; non-interactive, interactive. Slurm will automatically start within the directory where you submitted the job from, so keep that in mind when you use relative file paths. Non-interactive submission of a SBATCH script:
```bash
sbatch submission_script.sh
```

Here is an example of an SBATCH script:

```bash
#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=10G
#SBATCH --time=1-00:15:00     # 1 day and 15 minutes
#SBATCH --mail-user=useremail@address.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="just_a_test"
#SBATCH -p intel # This is the default partition, you can use any of the following; intel, batch, highmem, gpu

# Load matlab
module load matlab

# Send Matlab code to Matlab
matlab -nodisplay -nodesktop < my_matlab_program.m

# You can also capture the output in a log, like this
#matlab -nodisplay -nosplash < my_matlab_program.m > matlab_run.log
```
The above job will request 1 node, 10 cores (parallel threads), 10GB of memory, for 1 day and 15 minutes. An email will be sent to the user when the status of the job changes (Start, Failed, Completed). For more information regarding parallel/multi core jobs refer to [Parallelization](https://hpcc.ucr.edu/manuals_linux-cluster_jobs.html#parallelization).

Interactive submission:
```bash
srun --pty bash -l
```
If you do not specify a partition then the intel partition is used by default.
Here is a more complete example:
```bash
srun --x11 --mem=1gb --cpus-per-task 1 --ntasks 1 --time 10:00:00 --pty bash -l
```
The above example enables X11 forwarding and requests, 1GB of memory, 1 cores, for 10 hours within an interactive session.

#### Monitoring Jobs
To check on your jobs states, run the following:
```bash
squeue -u $USER --start
```
To list all the details of a specific job, run the following:
```bash
scontrol show job JOBID
```
To view past jobs and their details, run the following:
```bash
sacct -u $USER -l
```
You can also adjust the start `-S` time and/or end `-E` time to view, using the YYYY-MM-DD format. For example, the following command uses start and end times:

```bash
sacct -u $USER -S 2020-01-01 -E 2020-08-30 -l | less -S # Type 'q' to quit
```
#### Canceling Jobs

In cancel/stop your job run the following:
```bash
scancel <JOBID>
```
You can also cancel multiple jobs:

```bash
scancel <JOBID1> <JOBID2> <JOBID3>
```
If you want to cancel/stop/kill ALL your jobs it is possible with the following:

```bash
# Be very careful when running this, it will kill all your jobs.
squeue --user $USER --noheader --format '%i' | xargs scancel
```
For more information please refer to [Slurm scancel documentation](https://slurm.schedmd.com/scancel.html "Slurm scancel doc").

#### Advanced Jobs

There is a third way of submitting jobs by using steps. Single Step submission:

```bash
srun <command>
```
Under a single step job your command will hang until appropriate resources are found and when the step command is finished the results will be sent back on STDOUT. This may take some time depending on the job load of the cluster. Multi Step submission:

```bash
salloc -N 4 bash -l
srun <command>
...
srun <command>
exit
```
Under a multi step job the salloc command will request resources and then your parent shell will be running on the head node. This means that all commands will be executed on the head node unless preceeded by the srun command. You will also need to exit this shell in order to terminate your job.

#### Highmem Jobs

The highmem partition does not have a default amount of memory set, however it does has a minimum limit of 100GB per job. This means that you need to explicity request at least 100GB or more of memory.
Non-Interactive:
```bash
sbatch -p highmem --mem=100g --time=24:00:00 SBATCH_SCRIPT.sh
```
Interactive
```bash
srun -p highmem --mem=100g --time=24:00:00 --pty bash -l
```

Of course you should adjust the time argument according to your job requirements.

#### GPU Jobs

GPU nodes have multiple GPUs, and very in type (K80 or P100). This means you need to request how many GPUs and of what type that you would like to use.

To request a gpu of any type, only indicate how many GPUs you would like to use.

Non-Interactive:

```bash
sbatch -p gpu --gres=gpu:1 --mem=100g --time=1:00:00 SBATCH_SCRIPT.sh
```

Interactive

```bash
srun -p gpu --gres=gpu:4 --mem=100g --time=1:00:00 --pty bash -l
```

Since the HPCC Cluster has two types of GPUs installed (K80s and P100s), GPUs can be requested explicitly by type.

Non-Interactive:

```bash
sbatch -p gpu --gres=gpu:k80:1 --mem=100g --time=1:00:00 SBATCH_SCRIPT.sh
sbatch -p gpu --gres=gpu:p100:1 --mem=100g --time=1:00:00 SBATCH_SCRIPT.sh
```

Interactive

```bash
srun -p gpu --gres=gpu:k80:1 --mem=100g --time=1:00:00 --pty bash -l
srun -p gpu --gres=gpu:p100:1 --mem=100g --time=1:00:00 --pty bash -l
```

Of course you should adjust the time argument according to your job requirements.

Once your job starts your code must reference the environment variable “CUDA_VISIBLE_DEVICES” which will indicate which GPUs have been assigned to your job. Most CUDA enabled software, like MegaHIT, will check this environment variable and automatically limit accordingly.

For example, when reserving 4 GPUs for a NAMD2 job:

```bash
echo $CUDA_VISIBLE_DEVICES
0,1,2,3
namd2 +idlepoll +devices $CUDA_VISIBLE_DEVICES MD1.namd
```
Each group is limited to a maximum of 8 GPUs on the gpu partition. Please be respectful of others and keep in mind that the GPU nodes are a limited shared resource. Since the CUDA libraries will only run with GPU hardward, development and compiling of code must be done within a job session on a GPU node.

Here are a few more examples of jobs that utilize more complex features (ie. array, dependency, MPI etc): [Slurm Examples](https://github.com/ucr-hpcc/hpcc_slurm_examples)
## Advance method: Submitting job from matlab to the cluster
To submit a job from your matlab program to the cluster, you can view [Getting_Started_With_Serial_And_Parallel_MATLAB.pdf](Getting_Started_With_Serial_And_Parallel_MATLAB.pdf)
If you are getting an error when running **configCluster**, run **rehash toolboxcache** and then run **configCluster** again.
