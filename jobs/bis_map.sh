#!/bin/bash
#SBATCH --account=pi-jkoc
#SBATCH --partition=lab-colibri
#SBATCH --qos=pi-jkoc
#SBATCH --job-name=bis_map
#SBATCH --time=14-00:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=bis_map.out
#SBATCH --error=bis_map.err
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64GB

# Load Bismark
module load miniconda3
conda activate bismark

# Move to working directory
cd /hb/home/snbogan/WGBS/CrossPhox_WGBS/combined_trimmed_reads

genome_folder="/hb/home/snbogan/WGBS/CrossPhox_WGBS/genome/"
reads_dir="/hb/home/snbogan/WGBS/CrossPhox_WGBS/combined_trimmed_reads/"

# Run bismark
find ${reads_dir}*_1.combined.fq.gz \
| xargs basename -s _1.combined.fq.gz | xargs -I{} bismark \
-genome ${genome_folder} \
-p 16 \
-score_min L,0,-0.2 \
--non_directional \
-1 ${reads_dir}{}_1.combined.fq.gz \
-2 ${reads_dir}{}_2.combined.fq.gz \
-o /hb/home/snbogan/WGBS/CrossPhox_WGBS/Spurp5_bismark


  

