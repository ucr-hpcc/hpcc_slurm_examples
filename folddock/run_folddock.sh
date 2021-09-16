#!/usr/bin/bash
#SBATCH --ntasks=24
#SBATCH -N 1 
#SBATCH --mem=48gb
#SBATCH --time=1-00:00:00
#SBATCH -p gpu
#SBATCH --gres=gpu:1
#SBATCH --out=logs/folddock.%A.log
#SBATCH -J calp_alpha

# Path to directory of supporting data, the databases!
data_dir=/srv/projects/db/alphafold 

## Chain Break and Fasta 
CB=100 #Get chain break: Length of chain 1 
# E.g. seq1='AAA', seq2='BBB', catseq=AAABBB (the sequence that should be in the fasta file) and CB=3 
FASTAFILE=#Path to file with concatenated fasta sequences.

## MSA paths 
PAIREDMSA=#Path to paired MSA 
FUSEDMSA=#Path to fused MSA 
MSAS="$PAIREDMSA,$FUSEDMSA" #Comma separated list of msa paths

## AF2 CONFIGURATION 
AFHOME='./Alphafold2/alphafold/' # Path of alphafold directory in FoldDock 
PARAM=#Path to AF2 params 
OUTFOLDER=# Path where AF2 generates its output folder structure
PRESET='full_dbs' #Choose preset model configuration - no ensembling (full_dbs) and (reduced_dbs) or 8 model ensemblings (casp14). 
MAX_RECYCLES=10 #max_recycles (default=3) 
MODEL_NAME='model_1'

## Run AF2 
# This step is recommended to run on GPU as the folding will be much more efficient. 
#NOTE! Depending on your structure, large amounts of RAM may be required 
# The run mode option here is "--fold_only"

# Load scratch
module load workspace/scratch
export SINGULARITY_BIND="/scratch:/tmp"

singularity run --bind ${data_dir} --nv $FOLDDOCK_SING \
  /app/run_alphafold.sh \
  --fasta_paths=$FASTAFILE \
  --msas=$MSAS \
  --chain_break_list=$CB \
  --output_dir=$OUTFOLDER \
  --model_names=$MODEL_NAME \
  --data_dir=$PARAM \
  --fold_only \
  --uniref90_database_path='' \
  --mgnify_database_path='' \
  --bfd_database_path='' \
  --uniclust30_database_path='' \
  --pdb70_database_path='' \
  --template_mmcif_dir='' \
  --obsolete_pdbs_path='' \
  --preset=$PRESET \
  --max_recycles=$MAX_RECYCLES \
  popd


