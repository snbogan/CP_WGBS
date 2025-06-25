#!/bin/bash
#SBATCH --job-name=bis_map_array
#SBATCH --time=0-24:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=bis_map_array_%A_%a.out
#SBATCH --error=bis_map_array_%A_%a.err
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=48GB
#SBATCH --array=1-78

# Load Bismark
module load miniconda3
conda activate bismark

# Move to working directory
cd /hb/home/snbogan/WGBS/CrossPhox_WGBS/combined_trimmed_reads

genome_folder="/hb/home/snbogan/WGBS/CrossPhox_WGBS/genome/"
reads_dir="/hb/home/snbogan/WGBS/CrossPhox_WGBS/combined_trimmed_reads/repaired_reads/"

# Get the list of read pair prefixes
read_pairs=($(find ${reads_dir}*_1.repaired.fq.gz | xargs -n 1 basename | sed 's/_1.repaired.fq.gz//'))

# Get the prefix for the current task
prefix=${read_pairs[$SLURM_ARRAY_TASK_ID-1]}

# Run bismark
bismark \
  -genome ${genome_folder} \
  --parallel 8 \
  -score_min L,0,-0.6 \
  --non_directional \
  -1 ${reads_dir}${prefix}_1.repaired.fq.gz \
  -2 ${reads_dir}${prefix}_2.repaired.fq.gz \
  -o /hb/home/snbogan/WGBS/CrossPhox_WGBS/Spurp5_bismark_array


  

