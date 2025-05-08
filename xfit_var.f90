program xfit_var
use kind_mod  , only: dp
use random_mod, only: random_normal
use r_mod     , only: print_stats, fit_vector_ar
use sim_time_series_mod, only: sim_vector_ar
implicit none
real(kind=dp), allocatable :: x(:,:)
integer, parameter :: nrows=10**6, ncols=2
real(kind=dp), parameter :: var_coeff_1(ncols, ncols) = &
   reshape([3, -4, -2, 5], [ncols, ncols]) / 10.0_dp
integer :: var_order
x = sim_vector_ar(nrows, var_coeff_1)
call print_stats(x)
do var_order=1,2
   call fit_vector_ar(x, var_order=var_order)
end do
end program xfit_var
