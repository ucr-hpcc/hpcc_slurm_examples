#!/usr/bin/bash
#SBATCH --ntasks=24
#SBATCH -N 1 
#SBATCH --mem=48gb
#SBATCH --time=1-00:00:00
#SBATCH -p gpu
#SBATCH --gres=gpu:1
#SBATCH --out=logs/alphafold.%A.log
#SBATCH -J calp_alpha
##SBATCH --mail-type=END # notifications for job done & fail
##SBATCH --mail-user=cassande@ucr.edu # send-to address
##SBATCH -D /rhome/cassande/shared/projects/Caulerpa/alphafold_test/

# Path to directory of supporting data, the databases!
data_dir=/srv/projects/db/alphafold 
DOWNLOAD_DIR=$data_dir

# Path to a directory that will store the results
output_dir="${PWD}/CLENT_006666_model"

# Names of models to use (a comma separated list)
model_names=model_1 

# Path to a FASTA file containing one sequence
fasta_path="${PWD}/query.fasta"

# Last template date to consider in model in (ISO-8601 format - i.e. YYYY-MM-DD)
max_template_date=2020-08-12 

# Enable NVIDIA runtime to run with GPUs (default: True)
use_gpu=true 

# OpenMM threads (default: all available cores)
openmm_threads=24 

# Comma separated list of devices to pass to 'CUDA_VISIBLE_DEVICES' (default: 0)
gpu_devices=0 

# Choose preset model configuration - no ensembling and smaller genetic database config (reduced_dbs), no ensembling and full genetic database config  (full_dbs) or full genetic database config and 8 model ensemblings (casp14)
preset=full_dbs

# Run multiple JAX model evaluations to obtain a timing that excludes the compilation time, which should be more indicative of the time required for inferencing many proteins (default: 'False')
benchmark=false 

# Manually set CUDA devices
#export SINGULARITYENV_CUDA_VISIBLE_DEVICES=-1
#if [[ "$use_gpu" == true ]] ; then
#    export SINGULARITYENV_CUDA_VISIBLE_DEVICES=0

#    if [[ "$gpu_devices" ]] ; then
#        export SINGULARITYENV_CUDA_VISIBLE_DEVICES=$gpu_devices
#    fi
#fi

# OpenMM threads control
#if [[ "$openmm_threads" ]] ; then
#    export SINGULARITYENV_OPENMM_CPU_THREADS=$openmm_threads
#fi

# TensorFlow control
#export SINGULARITYENV_TF_FORCE_UNIFIED_MEMORY='1'

# JAX control
#export SINGULARITYENV_XLA_PYTHON_CLIENT_MEM_FRACTION='4.0'

# Path and user config (change me if required)
bfd_database_path=$data_dir/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt
small_bfd_database_path=$data_dir/small_bfd/bfd-first_non_consensus_sequences.fasta
mgnify_database_path=$data_dir/mgnify/mgy_clusters_2018_12.fa
template_mmcif_dir=$data_dir/pdb_mmcif/mmcif_files/
obsolete_pdbs_path=$data_dir/pdb_mmcif/obsolete.dat
pdb70_database_path=$data_dir/pdb70/pdb70
uniclust30_database_path=$data_dir/uniclust30/uniclust30_2018_08/uniclust30_2018_08
uniref90_database_path=$data_dir/uniref90/uniref90.fasta

# Binary path defaults should work within singularity
#hhblits_binary_path=$(which hhblits)
#hhsearch_binary_path=$(which hhsearch)
#jackhmmer_binary_path=$(which jackhmmer)
#kalign_binary_path=$(which kalign)

# Load alphafold
module load alphafold/2.1.2

# Load scratch
module load workspace/scratch
export SINGULARITY_BIND="${SCRATCH}:/tmp"

# Run alphafold container with nvidia support
singularity run --bind ${data_dir} --nv $ALPHAFOLD_SING \
    --bfd_database_path=$bfd_database_path \
    --mgnify_database_path=$mgnify_database_path \
    --template_mmcif_dir=$template_mmcif_dir \
    --obsolete_pdbs_path=$obsolete_pdbs_path \
    --pdb70_database_path=$pdb70_database_path \
    --uniclust30_database_path=$uniclust30_database_path \
    --uniref90_database_path=$uniref90_database_path \
    --data_dir=$data_dir \
    --output_dir=$output_dir \
    --fasta_paths=$fasta_path \
    --model_names=$model_names \
    --max_template_date=$max_template_date \
    --preset=$preset \
    --benchmark=$benchmark \
    --logtostderr

