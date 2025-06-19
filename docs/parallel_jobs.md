# Parallel jobs

One main advantage of using an HPC system is the ability to utilise its large compute power to run jobs in parallel.

!!! important
    When considering running parallel jobs make sure to consult your application documentation to find out if it can be run
    in the parallel environment. Nowadays most applications will support some level of parallelism.
    Many scientific software tools will have `-p` or `-t` options to specify numbers of CPUs to be used when running in parallel.
    Applications that can make use of multiple nodes are less common.

    If the application does not support parallelism, requesting additional resources will not improve performance, and will likely
    lead to longer waiting times for your job to be scheduled.
    It also leads to resources being wasted as they are allocated to your job but are unused.

    If you request multiple CPUs/nodes for your job, it's a good idea to check how effectively your job uses them using `sacct`, as discussed
    in the [job monitoring](submitting_jobs.md#job-monitoring) section.
    Most applications do not scale infinitely and will reach a point where the marginal impact of allocating more resources is minimal.

There are four types of parallel execution we'll discuss here, but we won't cover all of them in detail:

* Shared Memory Parallelism (SMP) / Multithreading
* Distributed Memory Parallelism / Multiprocessing
* Job Arrays
* GPUs

Before we delve deeper into each of these, let's clarify some terminology:

**Processes**: A process is an instance of a running program. It has its own memory space and resources allocated by the operating system. Processes are independent of each other and do not share memory, except through inter-process communication mechanisms.

**Threads**: Threads are units of execution (or CPU utilisation) within a process. A process can have multiple threads, and these threads share the same memory space. Threads within the same process can communicate directly with each other. Threads are often used to perform multiple tasks concurrently within a single program.

**Tasks / Jobs**: In the context of SLURM and other job scheduling systems, a task / job typically refers to a unit of work that can be executed independently of other units of work. Each task may correspond to a single process or a group of processes, depending on how the job is configured. So far, each time we've submitted something to the queue, we've created one task / job.

## Multithreaded/multicore (SMP) jobs

Shared Memory Parallelism, as the name suggests, is a form of parallelism where all parallel threads of execution have access to a block of shared memory.
We can use this shared memory to store objects which multiple threads need access to and to allow the threads to communicate.

This can also be referred to as **multithreading** as the initial single thread of a process forks into a number of parallel threads.
This approach will generally use a library such as `OpenMP` (Open MultiProcessing), `TBB` (Threading Building Blocks), or `pthread` (POSIX threads).

!!! note "Parallel programming"
    Writing our own code which makes use of parallelism is a complex topic and is beyond the scope of this training. We use some minimal examples to help explain how different models of parallelism work, but don't worry if you don't fully understand all the examples.

As an example, let's run a minimal C parallel program, called `omp_hello.c`, that prints "Hello World" for a number of threads.
This program is available at `/datasets/hpc_training/utils/omp_hello`.

!!! note "Example files"
    Most of the example files we use in this section can be found on CREATE at `/datasets/hpc_training/`.

We need to create a shell script that requests appropriate resources to run the program:

```bash
#SBATCH --job-name=omp_hello
#SBATCH --partition=cpu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=2G
#SBATCH -t 0-0:02 # time (D-HH:MM)

/datasets/hpc_training/utils/omp_hello
```

!!! hint
    You can also request memory per cpu, rather than per node using the `--mem-per-cpu` option.
    `--mem` and `--mem-per-cpu` are mutually exclusive meaning you can use one, or the other in your
    resource request.

We submit the job with the following command:

```bash
sbatch run_omp_hello.sh
```

One possible output would be:

```text
Hello World from OpenMP thread 2 of 4
Hello World from OpenMP thread 3 of 4
Hello World from OpenMP thread 0 of 4
Hello World from OpenMP thread 1 of 4
```

Note here that the lines don't come out in any particular order - each time you run the program you might end up with a different result.
This is because the program doesn't make any attempt to synchronise the printing of each line, it just executes all of them in parallel.

!!! warning "Order of execution"
    When using parallelism, we cannot rely on threads / processes reaching a particular line of code in any particular order, though each individual thread will still execute the order as expected. If we need things to happen in a particular order, for example if we wanted the threads to say hello in order, we need to force this using **synchronisation**.

### Python example

Let's consider the slightly more complex example of a Python script, called `squares_numba.py`, which calculates the square of numbers from one to one billion using multithreading - again with OpenMP, but this time via the Numba library.

```py
import time

import numba
import numpy as np

@numba.jit(parallel=True)
def calculate_squares(n):
    squares = np.zeros(n)

    # Square numbers in parallel using Numba
    for i in numba.prange(n):
        # print("Hello from thread", numba.get_thread_id())
        squares[i] = i ** 2

    return squares

if __name__ == "__main__":
    start_time = time.time()

    squares = calculate_squares(1_000_000_000)

    end_time = time.time()
    print("Used {} threads".format(numba.get_num_threads()))
    print("Took {:.4f} seconds".format(end_time - start_time))
```

The output should be something like:

```text
Used 8 threads
Took 1.6164 seconds
```

The key steps in this code are:

* Import necessary libraries: Time to measure the execution time, NumPy for numerical computation, and Numba for parallelisation.
* Define a function `calculate_squares()` which calculates the squares of numbers from one to one billion - computers can square numbers very quickly, so this needs to be a large number.
* Use Numba's `@jit` decorator to enable JIT compilation and the `parallel=True` option to enable parallel execution using OpenMP. Python libraries like Numba use OpenMP internally to parallelize computations. Numba uses a compiler called LLVM to compile our Python code - when we ask for parallel execution with `@jit(parallel=True)`, that then uses OpenMP just like we did in our C++ example.
* Using `numba.prange` for our loop instead of the usual `range` causes it to be executed in parallel across all available threads. Each thread will be given an approximately equal share of the loop iterations to execute.
* In the main block we call the `calculate_squares()` function and time how long it takes to run.

To execute the above code on CREATE, we can use `run_squares_numba.sh`:

```bash
#!/bin/bash
#SBATCH --job-name=squares_numba
#SBATCH --partition=cpu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=2G
#SBATCH -t 0-0:02 # time (D-HH:MM)

# Load any required modules
module load python/3.9.12-gcc-10.3.0  

# Activate virtual environment
source numba_venv/bin/activate

python squares_numba.py
```

But before we run that we'll need to install necessary packages (in this case Numpy and Numba) in a virtual environment using:

```bash
python -m venv numba_venv
source numba_venv/bin/activate
pip install numba numpy
```

We run the shell script:

```bash
sbatch submit_squares_numba.sh
```

## Array jobs

Array jobs are a feature provided by job schedulers like SLURM and offer a mechanism for **submitting and managing collections of similar tasks** (a task is equal to a single "job" from a "job array") quickly and easily.
Each task in the job array runs independently.
Job arrays are useful for running multiple instances of the same job with different input parameters or configurations.
Tasks in a job array may or may not communicate with each other, depending on the specific requirements of the job.

Unlike in MPI or multi-threading, **parallelization is orchestrated at the level of the shell script** rather than within your program (e.g. Python script).
Each task in the job array represents an independent instance of the program, and the shell script manages the execution of these instances in parallel by iterating over the task indices and launching separate invocations of the program.
This approach allows you to parallelize the execution of the program across multiple tasks without modifying the script itself, making it a flexible and convenient method for running parallel tasks on HPC systems.

All jobs will have the same initial options (e.g. memory, number of cpus, runtime, etc.) and will run the same commands.
Using array jobs is an easy way to parallelise your workloads, as long as the following is true:

* Each array task can run independently of the others and there are no dependencies between the
  different components ([embarassingly parallel problem](https://en.wikipedia.org/wiki/Embarrassingly_parallel)).
* There is no requirement for all of the array tasks to run simultaneously.
* You can link the array task id (`SLURM_ARRAY_TASK_ID`) somehow to your data, or execution of your application.

To define an array job you will be using an `--array=range[:step][%max_active]` option:

* `range` defines index values and can consist of comma separated list and/or a range of values with a "-" separator, e.g. `1,2,3,4`, or `1-4` or `1,2-4`
* `step` defines the increment between the index values, i.e. `0-15:4` would be equivalent to `0,4,8,12`
* `max_active` defines number of simultaneously running tasks at any give time, i.e. `1-10%2` means only two array tasks can run simultaneously for
  the given array job

A sample array job is given below:

```bash
#!/bin/bash -l
#SBATCH --job-name=array-sample
#SBATCH --partition=cpu
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH -t 0-0:02 # time (D-HH:MM)
#SBATCH --array=1-3

echo "Array job - task id: $SLURM_ARRAY_TASK_ID"
```

!!! info

    When the job starts running a separate job id in the format `jobid_taskid` will be assigned to each of the tasks.

    As a result, the array job will produce a separate log file for each of the tasks, i.e.
    you will see multiple files in the `slurm-jobid_taskid.out` format.

### A more realistic example

For a more realistic example, let's revisit the Python script we used earlier to identify the most frequent words in a text file.
It would be useful to able to run this on many input text files, without having to modify the Python script or manually submit a job for each input.
This is a great usecase for array jobs.

Here's our original submission script, which specifies a single text file as input.

```bash
#! /bin/bash -l

#SBATCH --job-name=top_words
#SBATCH --partition=cpu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH -t 0-0:10 # time (D-HH:MM)

module load python/3.11.6-gcc-13.2.0
source top_words_env/bin/activate

python top_words.py paradise-lost.txt 20
```

There are multiple text files we can use as input in the `/datasets/hpc_training/DH-RSE/data/` folder.
We'll use `ls` to create a list of these input files and save it to an file.

```bash
ls /datasets/hpc_training/DH-RSE/data/*.txt > input_files.txt
```

We can now use the `head` and `tail` commands to pull out individual lines in the file.
For example, to extract the third line:

```bash
head input_files.txt -n 3 | tail -n 1
```

The `head` command extracts the first _n_ lines of a file (here _n_ = 3).
We use the pipe `|` to pass this output directly to the `tail` command, which extracts the last _n_ lines of its input.
Here we specify _n_ = 1 to extract just the last line returned by `head`, which is the the third line of the input file.

In the submission script, we can use the `$SLURM_ARRAY_TASK_ID` to extract the corresponding file name.
Here's what our updated submission script looks like:

```bash
#! /bin/bash -l

#SBATCH --job-name=top_words
#SBATCH --partition=cpu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH -t 0-0:10 # time (D-HH:MM)
#SBATCH --array=1-10

module load python/3.11.6-gcc-13.2.0
source top_words_env/bin/activate

input_file=`head input_files.txt -n $SLURM_ARRAY_TASK_ID | tail -n 1`

echo "Analysing "$input_file

python top_words.py $input_file 20
```

## Distributed Memory Parallelism (DMP) / MPI jobs

Sometimes you might want to utilise resources on multiple nodes simultaneously to perform computations.
This is possible using a Message Passing Interface (MPI).
In MPI, multiple independent processes run concurrently on separate nodes or processors.
Each process has its own memory space.
Communication between processes is achieved through explicit message passing (processes send and receive messages via MPI function calls).

As mentioned earlier, requesting the resource by itself will not make your application run in parallel - the application has to support parallel execution.

[Message Passing Interface (MPI)](https://en.wikipedia.org/wiki/Message_Passing_Interface)
is the most common library used by research software for parallel execution across processes.

Although MPI programming is beyond the scope of this course, if your application
uses, or supports MPI then it can be executed on multiple nodes in parallel.
For example, given the following submission script:

```bash
#!/bin/bash -l
#SBATCH --job-name=multinode-test
#SBATCH --partition=cpu
#SBATCH --nodes=2
#SBATCH --ntasks=16
#SBATCH --mem=2G
#SBATCH -t 0-0:05 # time (D-HH:MM)

module load openmpi/4.1.3-gcc-10.3.0-python3+-chk-version

mpirun /datasets/hpc_training/utils/mpi_hello
```

A sample output would be

```text
Hello world from process 11 of 16 on host erc-hpc-comp006
Hello world from process 2 of 16 on host erc-hpc-comp005
Hello world from process 15 of 16 on host erc-hpc-comp006
Hello world from process 13 of 16 on host erc-hpc-comp006
Hello world from process 12 of 16 on host erc-hpc-comp006
Hello world from process 1 of 16 on host erc-hpc-comp005
Hello world from process 14 of 16 on host erc-hpc-comp006
Hello world from process 0 of 16 on host erc-hpc-comp005
Hello world from process 3 of 16 on host erc-hpc-comp005
Hello world from process 9 of 16 on host erc-hpc-comp006
Hello world from process 7 of 16 on host erc-hpc-comp005
Hello world from process 6 of 16 on host erc-hpc-comp005
Hello world from process 10 of 16 on host erc-hpc-comp006
Hello world from process 8 of 16 on host erc-hpc-comp006
Hello world from process 4 of 16 on host erc-hpc-comp005
Hello world from process 5 of 16 on host erc-hpc-comp005
```

## GPU jobs

GPU jobs utilise GPUs present in the system.
GPUs are very good at certain types of calculations, and can have >10k cores each so can run many calculations in parallel.
However, GPUs are not the best option for all tasks.
GPUs are very bad at things that aren't these types of calculations, and typically have much smaller memory.
In addition, GPU programming can be complex.

You can request GPUs using the following script - note that this time we're using the `gpu` partition.
The `nvidia-smi` command prints some information about the GPUs allocated to the job.

``` bash
#SBATCH --job-name=gpu-job
#SBATCH --partition=gpu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH -t 0-0:02 # time (D-HH:MM)
#SBATCH --gres gpu:1

nvidia-smi --id=$CUDA_VISIBLE_DEVICES
```

A sample output would be:

```text
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 470.182.03   Driver Version: 470.182.03   CUDA Version: 11.4     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Tesla K40c          On   | 00000000:08:00.0 Off |                    0 |
| 23%   32C    P8    23W / 235W |      0MiB / 11441MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```

!!! hint
    You can request `X` gpus (up to 4) using `--gres gpu:X`

## Exercises - parallel jobs and benchmarking

Work through the exercises in [this section](exercises.md/#job-submission-part-2) to practice submitting parallel jobs.
