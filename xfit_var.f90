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
! x = random_normal(nrows, ncols)
! do i=2,nrows
!    x(i,:) = x(i,:) + matmul(var_coeff_1, x(i-1,:))
! end do
x = sim_vector_ar(nrows, var_coeff_1)
call print_stats(x)
call fit_vector_ar(x, var_order=2)
end program xfit_var
