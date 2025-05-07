module util_mod
use kind_mod, only: dp
implicit none
private
public :: default, str, shape_mat_str, write_binary

interface write_binary
   module procedure write_binary_vec, write_binary_mat
end interface write_binary

contains

elemental function default(x, xopt) result(y)
! return a logical argument unless an optional logical argument is passed
logical, intent(in) :: x
logical, intent(in), optional :: xopt
logical :: y
if (present(xopt)) then
   y = xopt
else
   y = x
end if
end function default

function shape_mat_str(x) result(str)
! return the shape of a 2D array as a string, with one space separating the dimensions
real(kind=dp), intent(in) :: x(:,:)
character (len=:), allocatable :: str
allocate(character(len=100) :: str)
write (str, "(i0,1x,i0)") shape(x)
str = trim(str)
end function shape_mat_str

pure function str(i) result(istr)
! convert an integer to a string
integer, intent(in) :: i
character (len=:), allocatable :: istr
allocate (character(len=100) :: istr)
write (istr, "(i0)") i
istr = trim(istr)
end function str

subroutine write_binary_vec(x, bfile)
! write a 2D array of reals to a file as unformatted stream
real(kind=dp), intent(in) :: x(:)
character (len=*), intent(in) :: bfile
integer :: unit
open(newunit=unit, file=bfile, status="replace", &
   form="unformatted", access="stream")
write(unit) x
close(unit)
end subroutine write_binary_vec

subroutine write_binary_mat(x, bfile)
! write a 2D array of reals to a file as unformatted stream
real(kind=dp), intent(in) :: x(:,:)
character (len=*), intent(in) :: bfile
integer :: unit
open(newunit=unit, file=bfile, status="replace", &
   form="unformatted", access="stream")
write(unit) x
close(unit)
end subroutine write_binary_mat

end module util_mod
