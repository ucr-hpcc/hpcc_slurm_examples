# Array Job

You can consider using an array job if you want to submit many jobs that look identical, except for the input.


First write a job script that would work for a single input, removing a bash loop for example.
Then Use the `${SLURM_ARRAY_TASK_ID}` environment variable to control which input you should be processing.

After that you need to submit the job using the `array` option, like so:

```bash
sbatch --array=1-10 test_job.sh
```

This will copy the job into 10 tasks and the numbers 1 through 10 will each be used for the `$SLURM_ARRAY_TASK_ID` varaible within each task.

You can also control how many tasks are processed at the same time with the following syntax:

```bash
sbatch --array=1-10%2 test_job.sh
```

This will only allow 2 out of 10 tasks to run at the same time.

# Examples

Here is an example of a [test_job.sh](test_job.sh) submission script and an [inputs.txt](inputs.txt) file to demonstrate how the `{SLURM_ARRAY_TASK_ID}` environment variable can be used to pull the correct input.

