# Folddock

## Installation
You will need to clone the folddock using
```
git clone git@gitlab.com:ElofssonLab/FoldDock.git
```
## Running
### Databases and Input information
Due to optimized MSA usage in the **FoldDock** protocol, it is sufficient to run only two iterations of HHblits against uniclust30_2018_08 with the options: -E 0.001 -all -oa3m -n 2

Get Uniclust30 here: http://wwwuser.gwdg.de/~compbiol/uniclust/2018_08/

We recommend running this step on CPU and the actual folding on GPU.

1. For each of the two chains, run HHblits against Uniclust30 using
```
FASTAFILE=#Path to fasta file of chain \
HHBLITS=#Path to hhblits version 3.1.0 \
UNICLUST30=#Path to Uniclust30 \
OUTNAME="CHAINID.a3m" \
$HHBLITS -i $FASTAFILE -d $UNICLUST30 -E 0.001 -all -oa3m $OUTNAME
```
2. Create two input MSAs (paired and fused) from the HHblits results for each chain

**Paired** 
```
A3M1=#Path to a3m from chain 1 (from step 1)\
A3M2=#Path to a3m from chain 2 (from step 1) \
MGF=0.9 #The max gap fraction allowed in the sequences \
OUTNAME="CHAINID1-CHAINID2_paired.a3m" \
python3 ./data/marks/hhblits/oxmatch.py --a3m1 $A3M1 --a3m2 $A3M2 --max_gap_fraction $MGF --outname $OUTNAME
```

**Fused**
```
A3M1=#Path to a3m from chain 1 (from step 1) \
A3M2=#Path to a3m from chain 2 (from step 1) \
MGF=0.9 #The max gap fraction allowed in the sequences \
OUTNAME="CHAINID1-CHAINID2_fused.a3m" \
python3 ./data/marks/hhblits/fuse_msas.py --a3m1 $A3M1 --a3m2 $A3M2 --max_gap_fraction $MGF --outname $OUTNAME
```

## Predicting

**Chain Break and Fasta**
```
CB=100 #Get chain break: Length of chain 1 \
# E.g. seq1='AAA', seq2='BBB', catseq=AAABBB (the sequence that should be in the fasta file) and CB=3 \
FASTAFILE=#Path to file with concatenated fasta sequences.
```

**MSA paths**
```
PAIREDMSA=#Path to paired MSA \
FUSEDMSA=#Path to fused MSA \
MSAS="$PAIREDMSA,$FUSEDMSA" #Comma separated list of msa paths
```

**AF2 CONFIGURATION**
```
# This is inside the folder of FoldDock that you clone in the Installation section
AFHOME='./Alphafold2/alphafold/' # Path of alphafold directory in FoldDock \
PARAM=#Path to AF2 params \
OUTFOLDER=# Path where AF2 generates its output folder structure

PRESET='full_dbs' #Choose preset model configuration - no ensembling (full_dbs) and (reduced_dbs) or 8 model ensemblings (casp14). \
MAX_RECYCLES=10 #max_recycles (default=3) \
MODEL_NAME='model_1'
```

**Run AF2**
This step is recommended to run on GPU as the folding will be much more efficient. \
NOTE! Depending on your structure, large amounts of RAM may be required \
The run mode option here is "--fold_only"

```
pushd $AFHOME \
cd $AFHOME

# Load Scratch
module load workspace/scratch
export SINGULARITY_BIND="/scratch:/tmp"

# Path to directory of supporting data, the databases!
data_dir=/srv/projects/db/alphafold 

# Load Alphafold
singularity exec --nv --bind ${data_dir} $ALPHAFOLD_SING \
        python3 $AFHOME/run_alphafold.py \
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
                --max_recycles=$MAX_RECYCLES
popd
```
