module r_mod
! subroutines that write data and call R scripts to process it
use kind_mod, only: dp
use util_mod, only: default, shape_mat_str, str, write_binary
implicit none
private
public :: print_stats, fit_vector_ar
character (len=*), parameter :: r_command = "Rscript"
character (len=100), save :: bfile = "matrix.bin"
contains

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

subroutine print_stats(x, print_cmd)
! print stats on the columns of a matrix
real(kind=dp), intent(in)   :: x(:,:)
logical      , intent(in), optional :: print_cmd
character(len=200)          :: cmd
call write_binary(x, bfile)
cmd = r_command // " stats_matrix.r " // trim(bfile) // " " // shape_mat_str(x)
if (default(.true., print_cmd)) print "(/,a)", trim(cmd)
call execute_command_line(cmd)
end subroutine print_stats

end module r_mod
