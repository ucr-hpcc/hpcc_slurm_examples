# include <cstdlib>
# include <ctime>
# include <iomanip>
# include <iostream>
# include <mpi.h>

using namespace std;

int main ( int argc, char *argv[] );
void timestamp ( );

//****************************************************************************80

int main ( int argc, char *argv[] )

//****************************************************************************80
	//
	//  Purpose:
	//
	//    MAIN is the main program for HELLO_MPI.
	//
	//  Discussion:
	//
	//    This is a simple MPI test program.
	//    Each process prints out a "Hello, world!" message.
	//    The master process also prints out a short message.
	//
	//    Modified to use the C MPI bindings, 14 June 2016.
	//
	//  Licensing:
	//
	//    This code is distributed under the GNU LGPL license. 
	//
	//  Modified:
	//
	//    14 June 2016
	//
	//  Author:
	//
	//    John Burkardt
	//
	//  Reference:
	//
	//    William Gropp, Ewing Lusk, Anthony Skjellum,
	//    Using MPI: Portable Parallel Programming with the
	//    Message-Passing Interface,
	//    Second Edition,
	//    MIT Press, 1999,
	//    ISBN: 0262571323,
	//    LC: QA76.642.G76.
	//
	//76     int provided;
	//77     MPI_Init_thread(&argc, &argv, MPI_THREAD_MULTIPLE, &provided);  
	//78     MPI_Barrier(MPI_COMM_WORLD);                                   
	//79                                               
	//80     MPI_Comm_rank(MPI_COMM_WORLD, &nodeId);
	//81     MPI_Comm_size(MPI_COMM_WORLD, &numtasks); 
	//
	//
{
	int id;
	int ierr;
	int p;
	double wtime;
	//
	//  Initialize MPI.
	//
	ierr = MPI_Init ( &argc, &argv );
	//
	//  Get the number of processes.
	//
	ierr = MPI_Comm_size ( MPI_COMM_WORLD, &p );
	//
	//  Get the individual process ID.
	//
	ierr = MPI_Comm_rank ( MPI_COMM_WORLD, &id );
	//
	//  Process 0 prints an introductory message.
	//
	if ( id == 0 ) 
	{
		timestamp ( );
		cout << "\n";
		cout << "HELLO_MPI - Master process:\n";
		cout << "  C++/MPI version\n";
		cout << "  An MPI example program.\n";
		cout << "\n";
		cout << "  The number of processes is " << p << "\n";
		cout << "\n";
	}
	//
	//  Every process prints a hello.
	//
	if ( id == 0 ) 
	{
		wtime = MPI_Wtime ( );
	}
	cout << "  Process " << id << " says 'Hello, world!'\n";
	//
	//  Process 0 says goodbye.
	//
	if ( id == 0 )
	{
		wtime = MPI_Wtime ( ) - wtime;
		cout << "  Elapsed wall clock time = " << wtime << " seconds.\n";
	}
	//
	//  Terminate MPI.
	//
	MPI_Finalize ( );
	//
	//  Terminate.
	//
	if ( id == 0 )
	{
		cout << "\n";
		cout << "HELLO_MPI:\n";
		cout << "  Normal end of execution.\n";
		cout << "\n";
		timestamp ( );
	}
	return 0;
}
//****************************************************************************80

void timestamp ( )

	//****************************************************************************80
	//
	//  Purpose:
	//
	//    TIMESTAMP prints the current YMDHMS date as a time stamp.
	//
	//  Example:
	//
	//    31 May 2001 09:45:54 AM
	//
	//  Licensing:
	//
	//    This code is distributed under the GNU LGPL license. 
	//
	//  Modified:
	//
	//    08 July 2009
	//
	//  Author:
	//
	//    John Burkardt
	//
	//  Parameters:
	//
	//    None
	//
{
# define TIME_SIZE 40

	static char time_buffer[TIME_SIZE];
	const struct std::tm *tm_ptr;
	size_t len;
	std::time_t now;

	now = std::time ( NULL );
	tm_ptr = std::localtime ( &now );

	len = std::strftime ( time_buffer, TIME_SIZE, "%d %B %Y %I:%M:%S %p", tm_ptr );

	std::cout << time_buffer << "\n";

	return;
# undef TIME_SIZE
}
