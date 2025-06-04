#include <stdio.h>
#include <mpi.h>

int main(int argc, char** argv) {
    int rank, size, hostnamelen;
    char hostname[30] = "/0";

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Get_processor_name(hostname, &hostnamelen);

    printf("Hello World from MPI process %d of %d on %s\n", rank, size, hostname);

    MPI_Finalize();
    return 0;
}
