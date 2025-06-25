#!/bin/bash
#SBATCH --job-name=bis_extr
#SBATCH --time=2-00:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=bis_extr_out/bis_extr_%A_%a.out
#SBATCH --error=bis_extr_err/bis_extr_%A_%a.err
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=48GB
#SBATCH --array=1-74

# Load Bismark
module load miniconda3
conda activate bismark

# Define working directory and Bismark path (set your actual path)
WORKDIR="/hb/home/snbogan/WGBS/CrossPhox_WGBS/Spurp5_bismark_array"
OUTDEDUP="/hb/home/snbogan/WGBS/CrossPhox_WGBS/Spurp5_bismark_array/dedup_bams"
OUTDIR="${WORKDIR}/methyl_extract"

cd $WORKDIR

# Create a list of BAM files
BAM_FILES=(*.bam)
INPUT_BAM="${BAM_FILES[$SLURM_ARRAY_TASK_ID-1]}"
SAMPLE_NAME=$(basename "$INPUT_BAM" .bam)

# Step 1: Deduplicate
deduplicate_bismark \
    --bam \
    --paired \
    --output "$OUTDEDUP" \
    "${INPUT_BAM}"

# Step 2: Methylation extraction
bismark_methylation_extractor \
    --bedGraph \
    --counts \
    --comprehensive \
    --merge_non_CpG \
    --multicore 8 \
    --buffer_size 75% \
    --output "$OUTDIR" \
    "$OUTDEDUP/${SAMPLE_NAME}.deduplicated.bam"


  

