#!/bin/bash
#SBATCH --job-name=bis_merge
#SBATCH --time=2-00:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=bis_merge_out/bis_merge_%A_%a.out
#SBATCH --error=bis_merge_err/bis_merge_%A_%a.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=48GB
#SBATCH --array=1-74

# Load Bismark
module load miniconda3
conda activate bismark

# Define working directory and output directory
WORKDIR="/hb/home/snbogan/WGBS/CrossPhox_WGBS/Spurp5_bismark_array/methyl_extract"
OUTDIR="/hb/home/snbogan/WGBS/CrossPhox_WGBS/Spurp5_bismark_array/merged_covs"

cd "$WORKDIR"

# Create a list of cov.gz files and get the one for this task
BED_GRAPHS=(*.repaired_bismark_bt2_pe.deduplicated.bismark.cov.gz)
INPUT_GRAPH="${BED_GRAPHS[$SLURM_ARRAY_TASK_ID-1]}"
SAMPLE_NAME=$(basename "$INPUT_GRAPH" .repaired_bismark_bt2_pe.deduplicated.bismark.cov.gz)

# Merge strands with coverage2cytosine
coverage2cytosine \
  --genome_folder /hb/home/snbogan/WGBS/CrossPhox_WGBS/genome \
  -o "$OUTDIR/${SAMPLE_NAME}.CpG.merged.cov" \
  --merge_CpG \
  --zero_based \
  "$INPUT_GRAPH"



  

