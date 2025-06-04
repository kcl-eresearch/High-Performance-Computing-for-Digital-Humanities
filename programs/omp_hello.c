#include <stdio.h>
#include <omp.h>

int main(int argc, char** argv) {
    int thread_id, num_threads;

    #pragma omp parallel private(thread_id)
    {
        #pragma omp single
        num_threads = omp_get_num_threads();

        thread_id = omp_get_thread_num();
        printf("Hello World from OpenMP thread %d of %d\n", thread_id, num_threads);
    }

    return 0;
}
