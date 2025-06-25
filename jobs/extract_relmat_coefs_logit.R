args <- commandArgs(trailingOnly = TRUE)
task_id <- as.integer(args[1])  # Should be between 1 and number of actual .Rdata files

# Directory containing .Rdata files
rdata_dir <- "/hb/home/snbogan/WGBS/CrossPhox_WGBS/01_diff_meth/relmat_data"

# List and sort .Rdata files numerically by chunk number
all_files <- list.files(
  path = rdata_dir,
  pattern = "^diff_meth_logit_chunk_\\d+\\.Rdata$",
  full.names = TRUE
)

# Extract numeric chunk index from each file
get_index <- function(fname) as.integer(gsub("^.*chunk_(\\d+)\\.Rdata$", "\\1", fname))
chunk_numbers <- sapply(all_files, get_index)
sorted_files <- all_files[order(chunk_numbers)]
sorted_chunk_nums <- chunk_numbers[order(chunk_numbers)]

# Safety check: task ID must not exceed number of available files
if (task_id > length(sorted_files)) {
  stop("Task ID exceeds number of available .Rdata files.")
}

# Load the correct chunk file and its chunk number
chunk_file <- sorted_files[task_id]
chunk_num <- sorted_chunk_nums[task_id]  # for naming output consistently

# Load CpG ID list from mat_names.csv
mat_names_file <- "/hb/home/snbogan/WGBS/CrossPhox_WGBS/01_diff_meth/mat_names.csv"
mat_names <- read.csv(mat_names_file, stringsAsFactors = FALSE)[[1]]

# Get CpG IDs for this chunk
chunk_size <- 1000
start_idx <- (task_id - 1) * chunk_size + 1
end_idx <- min(length(mat_names), task_id * chunk_size)
cpg_ids <- mat_names[start_idx:end_idx]

# Load the results object (should be named `chunk_results`)
if (!file.exists(chunk_file)) {
  message("Chunk file not found: ", chunk_file)
  quit(status = 0)
}
load(chunk_file)

if (!exists("chunk_results")) {
  message("Object `chunk_results` not found in chunk file: ", chunk_file)
  quit(status = 0)
}
res <- chunk_results  # rename to expected variable name

# Function to extract coefficients and stats
extract_effects <- function(model, cpg_id) {
  if (inherits(model, "try-error") || is.na(model)) {
    return(data.frame(
      CpG_ID = cpg_id,
      F0_treat_estimate = NA,
      F0_treat_tvalue = NA,
      F0_treat_pval = NA,
      F1_treat_estimate = NA,
      F1_treat_tvalue = NA,
      F1_treat_pval = NA
    ))
  }

  coefs <- try(summary(model)$coefficients, silent = TRUE)
  if (inherits(coefs, "try-error")) {
    return(data.frame(
      CpG_ID = cpg_id,
      F0_treat_estimate = NA,
      F0_treat_tvalue = NA,
      F0_treat_pval = NA,
      F1_treat_estimate = NA,
      F1_treat_tvalue = NA,
      F1_treat_pval = NA
    ))
  }

  tvals <- coefs[, "Estimate"] / coefs[, "Std. Error"]
  pvals <- 2 * (1 - pnorm(abs(tvals)))

  return(data.frame(
    CpG_ID = cpg_id,
    F0_treat_estimate = coefs["F0_treatU", "Estimate"],
    F0_treat_tvalue = tvals["F0_treatU"],
    F0_treat_pval = pvals["F0_treatU"],
    F1_treat_estimate = coefs["F1_treatU", "Estimate"],
    F1_treat_tvalue = tvals["F1_treatU"],
    F1_treat_pval = pvals["F1_treatU"]
  ))
}

# Apply extraction to each model
results_df <- do.call(rbind, mapply(extract_effects, res, cpg_ids, SIMPLIFY = FALSE))

# Save results using the actual chunk number in the filename
out_file <- sprintf("%s/logit_stats_chunk_%d.csv", rdata_dir, chunk_num)
write.csv(results_df, out_file, row.names = FALSE)
