# Basic Example

```
sbatch --parsable first_job.sh
5383495
sbatch --dependency=after:5383495 second_job.sh
```

# Scripted Example
One way to script dependencies is to nest submissions (a job submitting a job):

```bash
sbatch first_job.sh
```

Contents of `first_job.sh`:

```bash
#!/bin/bash
#SBATCH -p short
#SBATCH --mem=1G
#SBATCH --ntasks=1

sbatch -p short --mem=1G --ntasks=1 --dependency=after:$SLURM_JOB_ID second_job.sh

# Do some work
sleep 60

```

# Complex Example
This example is a simple linear chain of dependancies (max 3 jobs):

```batch
sbatch test_job.sh
```

