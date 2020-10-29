#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH -p intel,batch
#SBATCH --mem-per-cpu=8G
#SBATCH --time=1-00:15:00     # 1 Day and 15 minutes
##SBATCH --mail-user=emailaddress@mail.com
##SBATCH --mail-type=ALL
#SBATCH --job-name="Metaerg_Sing"

# Load Modules
module load metaerg # This auto loads singularity

# Create DB, this only needs to be done once
singularity exec -B data:/data $METAERG_IMG setup_db.pl -o /data -v 132

# Execute script in singularity container
singularity exec -B data:/data $METAERG_IMG metaerg.pl --dbdir /data/db --outdir /data/my_metaerg_output /data/contig.fasta

