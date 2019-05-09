program hello_world
use mpi
implicit none
integer ( kind = 4 ) error
integer ( kind = 4 ) id
integer p
character(len=MPI_MAX_PROCESSOR_NAME) :: name
integer clen
integer, allocatable :: mype(:)
real ( kind = 8 ) wtime

call MPI_Init ( error )
call MPI_Comm_size ( MPI_COMM_WORLD, p, error )
call MPI_Comm_rank ( MPI_COMM_WORLD, id, error )
if ( id == 0 ) then

wtime = MPI_Wtime ( )

write ( *, '(a)' ) ' '
write ( *, '(a)' ) 'HELLO_MPI - Master process:'
write ( *, '(a)' ) '  FORTRAN90/MPI version'
write ( *, '(a)' ) ' '
write ( *, '(a)' ) '  An MPI test program.'
write ( *, '(a)' ) ' '
write ( *, '(a,i8)' ) '  The number of processes is ', p
write ( *, '(a)' ) ' '

end if

call MPI_GET_PROCESSOR_NAME(NAME, CLEN, ERROR)

write ( *, '(a)' ) ' '
write ( *, '(a,i8,a,a)' ) '  Process ', id, ' says "Hello, world!" ',name(1:clen)

call MPI_Finalize ( error )
end program
