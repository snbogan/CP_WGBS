#!/bin/bash
#SBATCH --account=pi-jkoc
#SBATCH --partition=lab-colibri
#SBATCH --qos=pi-jkoc
#SBATCH --job-name=CP_fastQC
#SBATCH --time=0-48:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=CP_fastQC.out
#SBATCH --error=CP_fastQC.err
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=48GB

#Load fastqc
module load fastqc
module load parallel
    
#Set wd
cd /hb/home/snbogan/WGBS/CrossPhox_WGBS/01.RawData
  
##Run fastqc in parallel with two files at a time
# Define the function that will run FastQC on a single file
run_fastqc() {
  fastqc "$1" -o /hb/home/snbogan/WGBS/CrossPhox_WGBS/fastqc_raw/
}

#Export the function so it can be used by GNU parallel
export -f run_fastqc

#Use GNU parallel to run FastQC on all files (2 at a time)
find /hb/home/snbogan/WGBS/CrossPhox_WGBS/01.RawData -type f -name "*.fq.gz"  | parallel -j 4 -N1 --delay 5 --joblog fastqc_parallel.log run_fastqc {}
