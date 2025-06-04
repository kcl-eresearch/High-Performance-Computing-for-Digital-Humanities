all: mpi_hello omp_hello

mpi_hello:
	mpicc -o mpi_hello mpi_hello.c

omp_hello:
	gcc -fopenmp -o omp_hello omp_hello.c

clean:
	rm mpi_hello omp_hello
