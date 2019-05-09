
# Basic usage works
sbatch -d after:<JOB_ID> test_job.sh

# However in order to script things, you might need to nest submissions
sbatch job_test.sh

# job_test.sh contents
sbatch -N 1 --export $job_num -d after:$SLURM_JOB_ID hostname

# This method is a linear chain of dependancies and may not be the best example.
