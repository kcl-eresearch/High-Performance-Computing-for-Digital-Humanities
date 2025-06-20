import time

import numba
import numpy as np

@numba.jit(parallel=True)
def calculate_squares(n):
    squares = np.zeros(n)

    # Square numbers in parallel using Numba
    for i in numba.prange(n):
        squares[i] = i ** 2

    return squares

if __name__ == "__main__":
    start_time = time.time()

    squares = calculate_squares(1_000_000_000)

    end_time = time.time()
    print("Used {} threads".format(numba.get_num_threads()))
    print("Took {:.4f} seconds".format(end_time - start_time))
