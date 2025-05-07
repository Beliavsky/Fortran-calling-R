module sim_time_series_mod
use random_mod
use kind_mod, only: dp
implicit none
private
public :: sim_vector_ar
contains
function sim_vector_ar(n, var_coeff_1) result(z)
! simulate a VAR(1) (vector autoregressive process of order 1)
integer, intent(in) :: n
real(kind=dp), intent(in) :: var_coeff_1(:,:)
real(kind=dp), allocatable :: z(:,:)
integer :: i, nvar
nvar = size(var_coeff_1, 1)
if (size(var_coeff_1, 2) /= nvar) then
   print*,"shape(var_coeff_1) =", shape(var_coeff_1)
   error stop "must be square"
end if
z = random_normal(n, nvar)
do i=2,n
   z(i,:) = z(i,:) + matmul(var_coeff_1, z(i-1,:))
end do
end function sim_vector_ar
end module sim_time_series_mod