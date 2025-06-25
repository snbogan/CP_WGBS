library(tidyverse, lib.loc = "/hb/home/snbogan/R/x86_64-conda-linux-gnu-library/4.4")
library(BiocParallel, lib.loc = "/hb/home/snbogan/R/x86_64-conda-linux-gnu-library/4.4")
library(lme4qtl, lib.loc = "/hb/home/snbogan/R/x86_64-conda-linux-gnu-library/4.4")

# Get array job ID from environment variable
array_id <- as.numeric(Sys.getenv("SLURM_ARRAY_TASK_ID", "1"))

# Read in meth_prop_mat_logit, targets_f, and cstm_a_m
load("/hb/home/snbogan/WGBS/CrossPhox_WGBS/01_diff_meth/relmat_logit_inputs.Rdata")

# Define cores - adjust based on your cluster configuration
param <- MulticoreParam(workers = as.numeric(Sys.getenv("SLURM_CPUS_PER_TASK", "1")),
                        progressbar = TRUE)

fit_cpg_model <- function(i) {
  prop_meth <- as.numeric(meth_prop_mat_logit[i, ])
  targets_f$prop_meth <- prop_meth
  
  fit <- try(
    relmatLmer(prop_meth ~ F0_treat + F1_treat + (1|ID) + (1|Dam) + (1|Sire),
               data = targets_f,
               relmat = list(ID = cstm_a_m)),
    silent = TRUE
  )
  
  if (inherits(fit, "try-error")) {
    return(NA)
  }
  
  return(fit)
}

quiet_fit_cpg_model <- function(i) {
  suppressMessages(
    suppressWarnings(
      fit_cpg_model(i)
    )
  )
}

# Split data into chunks of 1,000 CpGs
n_cpgs <- nrow(meth_prop_mat_logit)
chunk_size <- 1000
chunks <- split(1:n_cpgs, ceiling(seq_along(1:n_cpgs) / chunk_size))

# Select the current chunk based on array ID
current_chunk <- chunks[[array_id]]

cat("Processing chunk", array_id, "of", length(chunks),
    "containing", length(current_chunk), "CpGs...\n")

# Run in parallel over current chunk
chunk_results <- bplapply(current_chunk, quiet_fit_cpg_model, BPPARAM = param)

# Save results for this chunk
save(chunk_results, file = paste0("/hb/home/snbogan/WGBS/CrossPhox_WGBS/01_diff_meth/diff_meth_logit_chunk_", array_id, ".Rdata"))

# Clean up
rm(chunk_results)
gc()
