#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH -p short,batch
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0-00:15:00     # 15 minutes
##SBATCH --mail-user=emailaddress@mail.com
##SBATCH --mail-type=ALL
#SBATCH --job-name="=Metaerg_Sing"

# Load Modules
module load metaerg # This auto loads singularity

# Execute script in singularity container
singularity exec -B data:/data $METAERG_IMG metaerg.pl --dbdir /data/db --outdir /data/my_metaerg_output /data/contig.fasta

