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
    in the [job monitoring](#job-monitoring) section.
    Most applications do not scale infinitely and will reach a point where the marginal impact of allocating more resources is minimal.

## Multithreaded/multicore (SMP) jobs

These type of jobs will occupy multiple cores on a single node often using a method known as OpenMP.
The program which we want to run must be designed to support running multithreaded jobs.
You can request those using the following script:

```bash
#SBATCH --job-name=omp_hello
#SBATCH --partition=cpu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=2G
#SBATCH --reservation=cpu_introduction
#SBATCH -t 0-0:02 # time (D-HH:MM)

/datasets/hpc_training/utils/omp_hello
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

!!! hint
    You can also request memory per cpu, rather than per node using the `--mem-per-cpu` option.
    `--mem` and `--mem-per-cpu` are mutually exclusive meaning you can use one, or the other in your
    resource request.

## Array jobs

Array jobs offer a mechanism for submitting and managing collections of similar jobs quickly and easily.
All jobs will have the same initial options (e.g. memory, cpu, runtime, etc.) and will run the same commands.
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
#SBATCH --reservation=cpu_introduction
#SBATCH -t 0-0:02 # time (D-HH:MM)
#SBATCH --array=1-3

echo "Array job - task id: $SLURM_ARRAY_TASK_ID"
```

!!! info

    When the job starts running a separate job id in the format `jobid_taskid` will be assigned to each of the tasks.

    As a result, the array job will produce a separate log file for each of the tasks, i.e.
    you will see multiple files in the `slurm-jobid_taskid.out` format.

## MPI jobs

Sometimes you might want to utilise resources on multiple nodes simultaneously to perform computations.

As mentioned earlier, requesting the resource by itself will not make your application run in parallel - the application has to support parallel execution.

[Message Passing Interface (MPI)](https://en.wikipedia.org/wiki/Message_Passing_Interface)
is standard designed for parallel execution and it allows programs to exploit multiple processing cores in parallel.

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
#SBATCH --reservation=cpu_introduction
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
You can request those using the following script - note that this time we're using the `gpu` partition and the `gpu_introduction` reservation:

``` bash
#SBATCH --job-name=gpu-job
#SBATCH --partition=gpu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --reservation=gpu_introduction
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

Work through the exercises in [this section](exercises.md/#job-submission-part-2) to practice submitting parallel jobs, and [this section](exercises.md/#job-submission-part-3) to look at optimisation and benchmarking.
