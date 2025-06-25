#!/bin/bash
#SBATCH --account=pi-jkoc
#SBATCH --partition=lab-colibri
#SBATCH --qos=pi-jkoc
#SBATCH --job-name=relmat_logit_array
#SBATCH --output=relmat_logit_array/relmat_logit_array_%A_%a.txt
#SBATCH --error=relmat_logit_array_err/relmat_logit_array_%A_%a.err
#SBATCH --array=1-9149
#SBATCH --cpus-per-task=8
#SBATCH --mem=40G
#SBATCH --time=4-00:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=END,FAIL

# Load R module if needed
module load r

export R_LIBS_USER=/hb/home/snbogan/R/x86_64-conda-linux-gnu-library/4.4/

# Run the array task
Rscript fit_relmat_logit.R



  

