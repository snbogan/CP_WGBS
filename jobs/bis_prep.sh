#!/bin/bash
#SBATCH --account=pi-jkoc
#SBATCH --partition=lab-colibri
#SBATCH --qos=pi-jkoc
#SBATCH --job-name=bis_prep
#SBATCH --time=4-00:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=bis_prep.out
#SBATCH --error=bis_prep.err
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64GB

# Load Bismark
module load miniconda3
conda activate bismark

# Move to working directory
cd /hb/home/snbogan/WGBS/CrossPhox_WGBS/genome

# Directories and programs
genome_dir="/hb/home/snbogan/WGBS/CrossPhox_WGBS/genome"

bismark_genome_preparation \
--verbose \
--parallel 8 \
${genome_dir}


  

