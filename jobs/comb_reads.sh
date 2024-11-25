#!/bin/bash
#SBATCH --account=pi-jkoc
#SBATCH --partition=lab-colibri
#SBATCH --qos=pi-jkoc
#SBATCH --job-name=comb_reads
#SBATCH --time=4-00:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=comb_reads.out
#SBATCH --error=comb_reads.err
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=12GB

# Move to working directory
cd /hb/home/snbogan/WGBS/CrossPhox_WGBS/trimmed_data_polya

# Process each unique sample
for sample in $(ls *.fq.gz | awk -F'_' '{print $1"_"$2}' | sort | uniq); do
    echo "Processing sample: $sample"

    # Combine forward reads (_1.trimmed.fq.gz)
    cat ${sample}*_L*_1.trimmed.fq.gz > /hb/home/snbogan/WGBS/CrossPhox_WGBS/combined_trimmed_reads/${sample}_1.combined.fq.gz

    # Combine reverse reads (_2.trimmed.fq.gz)
    cat ${sample}*_L*_2.trimmed.fq.gz > /hb/home/snbogan/WGBS/CrossPhox_WGBS/combined_trimmed_reads/${sample}_2.combined.fq.gz
done

echo "Combining completed. Combined files are in the 'combined_reads' directory."
  

