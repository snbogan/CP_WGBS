#!/bin/bash
#SBATCH --account=pi-jkoc
#SBATCH --partition=lab-colibri
#SBATCH --qos=pi-jkoc
#SBATCH --job-name=cutadapt_cp
#SBATCH --time=5-00:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=cutadapt_cp.out
#SBATCH --error=cutadapt_cp.err
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=36GB

# Load cutadapt
module load cutadapt
module load parallel
    
# Set wd
cd /hb/home/snbogan/WGBS/CrossPhox_WGBS/

# Run cutadapt in parallel
find /hb/home/snbogan/WGBS/CrossPhox_WGBS/01.RawData -name "*_2.fq.gz" | parallel -j 2 --link '
    reverse_read={}
    forward_read="${reverse_read/_2.fq.gz/_1.fq.gz}"
    output_forward="trimmed_data_polya/$(basename "${forward_read/.fq.gz/.trimmed.fq.gz}")"
    output_reverse="trimmed_data_polya/$(basename "${reverse_read/.fq.gz/.trimmed.fq.gz}")"
    
    cutadapt \
        -u 0 -U 8 \
        -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
        -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
        -o "$output_forward" \
        -p "$output_reverse" \
        -q 0,0 \
        -Q 0,0 \
        -m 1 \
        "$forward_read" "$reverse_read"
'
  

