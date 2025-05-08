# Fortran-calling-R
Examples of Fortran subroutines that call R to process data and print results. A Fortran subroutine writes a matrix of data to a binary file and calls an R script with command line arguments giving the matrix dimensions and parameters for the R function used. An example is

```fortran
subroutine fit_vector_ar(x, var_order, print_cmd)
! fit a vector autoregressive (VAR) model of order var_order to x(:,:)   
real(kind=dp), intent(in)   :: x(:,:)
integer      , intent(in)   :: var_order
logical      , intent(in), optional :: print_cmd
character(len=200)          :: cmd
call write_binary(x, bfile)
cmd = r_command // " vars.r " // trim(bfile) // " " // shape_mat_str(x) &
   // " " // str(var_order)
if (default(.true., print_cmd)) print "(/,a)", trim(cmd)
call execute_command_line(cmd)
end subroutine fit_vector_ar
```
calling the R script
```R
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
```
with sample output
```
Rscript vars.r matrix.bin 1000000 2 2

Fitting VAR(2) on 1000000×2 data…

=== Coefficient Estimates ===

VAR Estimation Results:
======================= 

Estimated coefficients for equation Y1: 
======================================= 
Call:
Y1 = Y1.l1 + Y2.l1 + Y1.l2 + Y2.l2 + const 

        Y1.l1         Y2.l1         Y1.l2         Y2.l2         const 
 3.003103e-01 -1.989826e-01  9.820639e-06 -4.274379e-04  1.452491e-03 


Estimated coefficients for equation Y2: 
======================================= 
Call:
Y2 = Y1.l1 + Y2.l1 + Y1.l2 + Y2.l2 + const 

        Y1.l1         Y2.l1         Y1.l2         Y2.l2         const 
-0.3999801759  0.5005289961 -0.0005591599  0.0001047444  0.0004631382
```

