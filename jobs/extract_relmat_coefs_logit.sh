#!/bin/bash
#SBATCH --account=pi-jkoc
#SBATCH --partition=lab-colibri
#SBATCH --qos=pi-jkoc
#SBATCH --job-name=extract_relmat_coefs_logit
#SBATCH --output=extract_relmat_coefs_logit_out/extract_relmat_coefs_array_%A_%a.txt
#SBATCH --error=extract_relmat_coefs_logit_err/extract_relmat_coefs_array_%A_%a.err
#SBATCH --array=1-9058
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --time=02:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=END,FAIL

# Load R module if needed
module load r

export R_LIBS_USER=/hb/home/snbogan/R/x86_64-conda-linux-gnu-library/4.4/

# Run the array task
Rscript extract_relmat_coefs_logit.R ${SLURM_ARRAY_TASK_ID}



  

