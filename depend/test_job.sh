#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0-00:15:00     # 15 minutes
##SBATCH --output=my.stdout
##SBATCH --mail-user=jhayes@ucr.edu
##SBATCH --mail-type=ALL
##SBATCH --job-name="just_a_test"

: ${job_number:="1"}           # set job_nubmer to 1 if it is undefined
job_number_max=3

echo "hi from ${SLURM_JOB_ID}"

if [[ ${job_number} -lt ${job_number_max} ]]
then
  (( job_number++ ))
  next_jobid=$(sbatch --export=job_number=${job_number} -d afterok:${SLURM_JOB_ID} test_job.sh | awk '{print $4}')
  echo "submitted ${next_jobid}"
fi

sleep 15
echo "${SLURM_JOB_ID} done"
