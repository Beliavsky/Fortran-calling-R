#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3) {
  stop("Usage: Rscript summary_matrix_bin.r <binfile> <nrows> <ncols>")
}

binfile <- args[1]
nrows   <- as.integer(args[2])
ncols   <- as.integer(args[3])

# Read the raw binary data (double = 8 bytes)
con  <- file(binfile, "rb")
vals <- readBin(con, what = "double", n = nrows * ncols, size = 8)
close(con)

# Reshape into matrix (Fortran is column-major)
mat <- matrix(vals, nrow = nrows, ncol = ncols)

# Compute statistics
col_means <- colMeans(mat)
col_sds   <- apply(mat, 2, sd)
col_mins  <- apply(mat, 2, min)
col_maxs  <- apply(mat, 2, max)

# Combine into a data.frame
stats_df <- as.data.frame(rbind(mean = col_means, sd  = col_sds,
	        min = col_mins, max = col_maxs),
			stringsAsFactors = FALSE)
print(stats_df)
