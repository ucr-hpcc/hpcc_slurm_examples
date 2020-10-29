# DeepVariant

Load the module

```bash
module load deepvariant
```

Execute run_deepvariant script within the singularity container

```bash
singularity exec \
  -B "YOUR_INPUT_DIR":"/input" \
  -B "YOUR_OUTPUT_DIR:/output" \
  $DEEPVARIANT_IMG \
  /opt/deepvariant/bin/run_deepvariant \
  --model_type=WGS \ **Replace this string with exactly one of the following [WGS,WES,PACBIO]**
  --ref=/input/YOUR_REF \
  --reads=/input/YOUR_BAM \
  --output_vcf=/output/YOUR_OUTPUT_VCF \
  --output_gvcf=/output/YOUR_OUTPUT_GVCF \
  --num_shards=$(nproc) **This will use all your cores to run make_examples. Feel free to change.**
```

