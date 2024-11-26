#!/bin/bash
#SBATCH --account=pi-jkoc
#SBATCH --partition=lab-colibri
#SBATCH --qos=pi-jkoc
#SBATCH --job-name=repair
#SBATCH --time=5-00:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=repair.out
#SBATCH --error=repair.err
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=36GB

# Load cutadapt
module load miniconda3
module load parallel
conda activate bbmap
    
# Set wd
cd /hb/home/snbogan/WGBS/CrossPhox_WGBS/combine_trimmed_reads/

# Define input and output directories
input_dir="/hb/home/snbogan/WGBS/CrossPhox_WGBS/combined_trimmed_reads/"
output_dir="/hb/home/snbogan/WGBS/CrossPhox_WGBS/combined_trimmed_reads/repaired_reads/"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Generate a list of commands for parallel
find "$input_dir" -name "*_1.combined.fq.gz" | while read -r file1; do
    # Derive the base name for the read pair
    base=$(basename "$file1" _1.combined.fq.gz)
    
    # Define paired read and output file names
    file2="${input_dir}/${base}_2.combined.fq.gz"
    out1="${output_dir}/${base}_1.repaired.fq.gz"
    out2="${output_dir}/${base}_2.repaired.fq.gz"
    singletons="${output_dir}/${base}_singletons.fq.gz"
    
    # Print the command to process the pair
    echo "repair.sh in1=\"$file1\" in2=\"$file2\" out1=\"$out1\" out2=\"$out2\" outs=\"$singletons\" repair"
done | parallel -j 2


  

