#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --time=00:05:00
#SBATCH --mail-user=useremail@address.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="workshop_test"
#SBATCH -p short

module purge
module load hpcc_workshop/2.0
module load miniconda3

mkdir -p output
rm -rf output/secret_message.txt
create_output_file > output/secret_message.txt

chmod 000 output/secret_message.txt

