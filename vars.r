# Reads a Fortran binary stream, reshapes to matrix,
# fits VAR(p), prints coefficients

suppressWarnings(suppressPackageStartupMessages({library(vars)}))

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 4) {
  stop("Usage: Rscript fit_var_bin_lite.r <binfile> <nrows> <ncols> <p>\n",
       "  e.g. Rscript fit_var_bin_lite.r matrix.bin 1000000 2 2")
}

binfile <- args[1]
nrows   <- as.integer(args[2])
ncols   <- as.integer(args[3])
p       <- as.integer(args[4])

if (!file.exists(binfile)) stop("Binary file not found: ", binfile)

# 2) Read the raw doubles (small vector of length nrows*ncols)
con  <- file(binfile, "rb")
vals <- readBin(con, what = "double", n = nrows * ncols, size = 8)
close(con)

# 3) Reshape (Fortran -> column‐major)
mat <- matrix(vals, nrow = nrows, ncol = ncols)

# 4) Wrap in data.frame
df <- as.data.frame(mat)
colnames(df) <- paste0("Y", seq_len(ncols))

# 5) Fit VAR(p) with constant
cat(sprintf("\nFitting VAR(%d) on %d×%d data…\n\n", p, nrows, ncols))
fit <- VAR(y = df, p = p, type = "const")

# 6) Print coefficient tables
cat("=== Coefficient Estimates ===\n")
print(fit)
