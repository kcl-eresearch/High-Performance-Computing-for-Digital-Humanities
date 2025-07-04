# Exercises

This section contains collection of exercises based on the material covered in the previous sections.

Sample answers are provided in-line in the expandable boxes, but please try to do exercises by yourself
before looking at the sample answers. There are also some hints to help you if you are stuck.

Supporting files can be found on CREATE HPC in `/datasets/hpc_training` directory. The
directory also contains example scripts from the exercises for convenience.

!!! info
    There might be multiple ways to achieve a specific goal - If your method does not match the sample
    answer it might not mean you have done things incorrectly, just differently.

## Using modules

1. ### Basic software environment module usage

    **Goal**: Load and use the Python environment module with the most recent version of Python

    * Investigate the module environment before and after loading the module. What has changed?
    * Print python version
    * Check the python interpreter location on the filesystem
    * Unload the module and check the python version and location again. What is different?

    ??? hint
        Use `which` command to find the location and `-V` option to print python version.

    ??? example "Sample answer"
        First print the list of the modules before the module has been loaded

        ```
        k1234567@erc-hpc-login2:~$ module list
        ```

        Next load the Python module - N.B. the most recent version you have available may be different to this example answer.

        ```
        k1234567@erc-hpc-login2:~$ module load python/3.8.12-gcc-9.4.0
        ```

        List the currently loaded modules:

        ```
        k1234567@erc-hpc-login2:~$ module list

        Currently Loaded Modules:
          1) bzip2/1.0.8-gcc-9.4.0     6) libiconv/1.16-gcc-9.4.0   11) ncurses/6.2-gcc-9.4.0             16) xz/5.2.5-gcc-9.4.0
          2) libmd/1.0.3-gcc-9.4.0     7) libxml2/2.9.12-gcc-9.4.0  12) openssl/1.1.1l-gcc-9.4.0          17) zlib/1.2.11-gcc-9.4.0
          3) libbsd/0.11.3-gcc-9.4.0   8) tar/1.34-gcc-9.4.0        13) readline/8.1-gcc-9.4.0            18) python/3.8.12-gcc-9.4.0
          4) expat/2.4.1-gcc-9.4.0     9) gettext/0.21-gcc-9.4.0    14) sqlite/3.36.0-gcc-9.4.0
          5) gdbm/1.19-gcc-9.4.0      10) libffi/3.3-gcc-9.4.0      15) util-linux-uuid/2.36.2-gcc-9.4.0
        ```

        You can see that the python module and its dependencies have been added.

        Test by printing python version:

        ```
        k1234567@erc-hpc-login2:~$ python -V
        Python 3.8.12
        ```

        You can also see where the python interpreter resides:

        ```
        k1234567@erc-hpc-login2:~$ which python
        /software/spackages_prod/apps/linux-ubuntu20.04-zen2/gcc-9.4.0/python-3.8.12-mdneme5mnx2ihlvy6ihbvjatdvnn45l6/bin/python
        ```

        Unload the python module using:

        ```
        k1234567@erc-hpc-login2:~$ module rm python/3.8.12-gcc-9.4.0
        ```

        Check the version and location again:

        ```
        k1234567@erc-hpc-login2:~$ python -V
        Python 3.8.10
        k1234567@erc-hpc-login2:~$ which python
        /usr/bin/python
        ```

        Now we are using system provided python. Although we said that no software
        is automatically pre-loaded, there will be applications that come with the
        operating system and cannot be removed/hidden easily.

1. ### Further environment module usage

    **Goal**: Explore loading different versions of the same environment

    * Load the most recent version of Python and then attempt to load a different version. What is the outcome?

    ??? example  "Sample answer"
        Start by loading python 3.8.12 (N.B. the versions you have available may be different to this example answer):

        ```
        k1234567@erc-hpc-login2:~$ module load python/3.8.12-gcc-9.4.0
        ```

        Next load python 2.7.18:

        ```
        k1234567@erc-hpc-login2:~$ module load python/2.7.18-gcc-9.4.0
        ```

        You should see the following message informing you about the module swap:

        ```
        The following have been reloaded with a version change:
          1) python/3.8.12-gcc-9.4.0 => python/2.7.18-gcc-9.4.0
        ```

## Python virtual environments

1. ### Python virtualenv creation

    **Goal**: Create and use a Python virtual environment

    * Create python virtualenv using the most recent available version of python and activate it.
    * Find out where the python interpreter and pip utility are located
    * Deactivate the python virtual environment
    * Check the location of python interpreter and pip utility again

    ??? example "Sample answer"
        Start by loading the python interpreter using:

        ```
        k1234567@erc-hpc-login2:~$ module load python/3.11.6-gcc-13.2.0
        ```

        Once the module has been loaded create the python virtual environment:

        ```
        k1234567@erc-hpc-login2:~$ python -m venv myvenv
        ```

        Next activate the environment:

        ```
        k1234567@erc-hpc-login2:~$ source myvenv/bin/activate
        (myvenv) k1234567@erc-hpc-login2:~$
        ```

        Use `which` command to print the locations of the python interpreter and pip utility

        ```
        (myvenv) k1234567@erc-hpc-login2:~$ which python
        /users/k1234567/myvenv/bin/python
        (myvenv) k1234567@erc-hpc-login2:~$ which pip
        /users/k1234567/myvenv/bin/pip
        ```

        __Note__: The above paths might vary depending on where on the filesystem you have created your virtual environemnt.

        Next deactivate the virtual environment

        ```
        (myvenv) k1234567@erc-hpc-login2:~$ deactivate
        ```

        Check the location of python interpreter and pip using

        ```
        k1234567@erc-hpc-login2:~$ which python
        /software/spackages_v0_21_prod/apps/linux-ubuntu22.04-zen2/gcc-13.2.0/python-3.11.6-oe7bpykqsieymznu5rprjla46ti6uagh/bin/python
        k1234567@erc-hpc-login2:~$ which pip
        /usr/bin/pip
        ```

1. ### Python virtualenv package installation

    **Goal**: Install packages into a python virtual environment

    * Using the virtualenv created in the previous excercise, install the `pandas` package to it. Check if it has been installed.
    * What other packages were installed as dependencies?

    ??? hint
        * Use `pip install package_name` to install a package in your virtual environment
        * Use `pip list` to list installed packages

    ??? example "Sample answer"
        Using the previously created environment activate it

        ```
        k1234567@erc-hpc-login2:~$ source myvenv/bin/activate
        (myvenv) k1234567@erc-hpc-login2:~$
        ```

        Next use pip command to install the relevant package

        ```
        (myvenv) k1234567@erc-hpc-login2:~$ pip install pandas
        Collecting pandas
          Downloading pandas-1.4.2-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (11.7 MB)
             ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 11.7/11.7 MB 14.4 MB/s eta 0:00:00
        Collecting python-dateutil>=2.8.1
          Downloading python_dateutil-2.8.2-py2.py3-none-any.whl (247 kB)
             ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 247.7/247.7 KB 1.8 MB/s eta 0:00:00
        Collecting pytz>=2020.1
          Downloading pytz-2022.1-py2.py3-none-any.whl (503 kB)
             ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 503.5/503.5 KB 1.7 MB/s eta 0:00:00
        Collecting numpy>=1.18.5
          Downloading numpy-1.22.3-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (16.8 MB)
             ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 16.8/16.8 MB 13.6 MB/s eta 0:00:00
        Collecting six>=1.5
          Downloading six-1.16.0-py2.py3-none-any.whl (11 kB)
        Installing collected packages: pytz, six, numpy, python-dateutil, pandas
        Successfully installed numpy-1.22.3 pandas-1.4.2 python-dateutil-2.8.2 pytz-2022.1 six-1.16.0
        ```

        Additional dependencies that pandas package requires will also be installed.

        You can check if the package has been installed using

        ```
        (myvenv) k1234567@erc-hpc-login2:~$ pip list
        Package         Version
        --------------- -------
        numpy           1.22.3
        pandas          1.4.2
        pip             22.0.4
        python-dateutil 2.8.2
        pytz            2022.1
        setuptools      62.1.0
        six             1.16.0
        wheel           0.37.1
        ```

        __Note__: The version numbers you see might not match those above.

## Job submission (part 1)

1. ### SLURM batch job submission

    **Goal**: Submit a batch job requesting 1 core and 2G of memory

    * Have the job print the hostname of the node that it runs on
    * Check if the job is running
    * Analyse the output file
    * Check information about completed job

    ??? hint
        * Use `hostname` command to print the hostname of the node
        * Add `sleep` to the jobscript so that it does not terminate too quickly
        * Use `squeue` to check the status of the job
        * Use `sacct` to get the information about the job when it has finished

    ??? example "Sample answer"
        Create a sample script `test-job1.sh` and add the following contents to it

        ```
        #!/bin/bash -l

        #SBATCH --job-name=test-job1
        #SBATCH --partition=cpu
        #SBATCH --reservation=cpu_introduction
        #SBATCH --ntasks=1
        #SBATCH --nodes=1
        #SBATCH --cpus-per-task=1
        #SBATCH --mem=2G

        echo "My hostname is "`hostname`
        sleep 60
        ```

        Submit the jobs using

        ```
        k1234567@erc-hpc-login2:~$ sbatch test-job1.sh
        Submitted batch job 56739
        ```

        You can check the status of your job(s)

        ```
        k1234567@erc-hpc-login2:~$ squeue --me
        JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
        56739       cpu test-job k1234567  R       0:10      1 erc-hpc-comp001
        ```

        Analyse the output, which should be located in the `slurm-jobid.out` file (replace `jobid` with the id of your job)

        ```
        k1234567@erc-hpc-login2:~$ cat slurm-56739.out
        My hostname is erc-hpc-comp001
        ```

        You can check information about completed job using

        ```
        k1234567@erc-hpc-login2:~$ sacct -j 56739
               JobID    JobName  Partition    Account  AllocCPUS      State ExitCode
        ------------ ---------- ---------- ---------- ---------- ---------- --------
        56739         test-job1        cpu        kcl          1  COMPLETED      0:0
        56739.batch       batch                   kcl          1  COMPLETED      0:0
        ```

1. ### SLURM interactive job submission

    **Goal**: Request an interactive session with one core and 4G of memory

    * Print the hostname of the interactive node that you have been allocated
    * Print number of cores available
    * What happens immediately after requesting the interactive job? How is it different from submitting a batch job? Why might this be a bad thing?

    ??? hint
        * Use `hostname` command to print the hostname of the node
        * Use `nproc` utility to print the number of allocated cpus for the job

    ??? example "Sample answer"

        Use `srun` command to request an interactive session

        ```
        k1234567@erc-hpc-login2:~$ srun -p cpu --reservation cpu_introduction --mem 4G --pty /bin/bash -l
        srun: job 56741 queued and waiting for resources
        srun: job 56741 has been allocated resources
        k1234567@erc-hpc-comp001:~$
        ```

        Print the hostname of the allocated node and number of cores that we have been allocated

        ```
        k1234567@erc-hpc-comp001:~$ hostname
        erc-hpc-comp001
        k1234567@erc-hpc-comp001:~$ nproc
        1
        ```

1. ### GPU SLURM jobs

    **Goal**: Submit a job requesting gpu(s) on a single node.

    * Write a job script that requests a single gpu and does something that reports the information in its output
    * Submit a job that requests two gpus and check the output

    ??? hint
        * Use `nvidia-smi --id=$CUDA_VISIBLE_DEVICES` utility to print the details of allocated gpu(s) for the job

    ??? example "Sample answer"
        Create a sample script `test-gpu.sh` and add the following contents to it:

        ```
        #!/bin/bash -l

        #SBATCH --job-name=test-gpu
        #SBATCH --partition=interruptible_gpu
        #SBATCH --ntasks=1
        #SBATCH --cpus-per-task=1
        #SBATCH --gres gpu:1

        nvidia-smi --id=$CUDA_VISIBLE_DEVICES
        ```

        Submit the jobs using

        ```
        k1234567@erc-hpc-login2:~$ sbatch test-gpu.sh
        Submitted batch job 57425
        ```

        Analyse the output, which should be located in the `slurm-jobid.out` file (replace `jobid` with the id of your job)

        ```
        k1234567@erc-hpc-login2:~$ cat slurm-57425.out
        Tue May 10 09:23:12 2022
        +-----------------------------------------------------------------------------+
        | NVIDIA-SMI 510.54       Driver Version: 510.54       CUDA Version: 11.6     |
        |-------------------------------+----------------------+----------------------+
        | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
        | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
        |                               |                      |               MIG M. |
        |===============================+======================+======================|
        |   1  NVIDIA A100-SXM...  On   | 00000000:31:00.0 Off |                    0 |
        | N/A   42C    P0    51W / 400W |      0MiB / 40960MiB |      0%      Default |
        |                               |                      |             Disabled |
        +-------------------------------+----------------------+----------------------+

        +-----------------------------------------------------------------------------+
        | Processes:                                                                  |
        |  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
        |        ID   ID                                                   Usage      |
        |=============================================================================|
        |  No running processes found                                                 |
        +-----------------------------------------------------------------------------+
        ```

        Next modify `--gres` option to be `--gres gpu:2` and re-submit the job.

        Analyse the output, which should be located in the `slurm-jobid.out` file (replace `jobid` with the id of your job)

        ```
        k1234567@erc-hpc-login2:~$ cat slurm-57460.out
        Tue May 10 09:32:21 2022
        +-----------------------------------------------------------------------------+
        | NVIDIA-SMI 510.60.02    Driver Version: 510.60.02    CUDA Version: 11.6     |
        |-------------------------------+----------------------+----------------------+
        | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
        | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
        |                               |                      |               MIG M. |
        |===============================+======================+======================|
        |   1  NVIDIA A100-SXM...  Off  | 00000000:31:00.0 Off |                    0 |
        | N/A   35C    P0    55W / 400W |      0MiB / 40960MiB |      0%      Default |
        |                               |                      |             Disabled |
        +-------------------------------+----------------------+----------------------+
        |   2  NVIDIA A100-SXM...  Off  | 00000000:B1:00.0 Off |                    0 |
        | N/A   34C    P0    55W / 400W |      0MiB / 40960MiB |      0%      Default |
        |                               |                      |             Disabled |
        +-------------------------------+----------------------+----------------------+

        +-----------------------------------------------------------------------------+
        | Processes:                                                                  |
        |  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
        |        ID   ID                                                   Usage      |
        |=============================================================================|
        |  No running processes found                                                 |
        +-----------------------------------------------------------------------------+
        ```

1. ### Debugging SLURM job scripts

    **Goal**: Analyse and fix a SLURM batch job script

    * For this exercise, use the `bad-script1.sh` script located in the `sample-scripts` folder in the supporting files directory
    * Examine the job script, what is it intended to do?
    * Submit it as a batch job. What is the problem? Try to fix the issue.
    * How else could you have fixed the issue?

    ??? hint
        You will have to copy the script to your local workspace in order to modify it.

    ??? example "Sample Answer"
        Submit the `/datasets/hpc_training/sample-scripts/sample-scripts/bad-script1.sh` job

        ```
        k1234567@erc-hpc-login2:~$ sbatch /datasets/hpc_training/sample-scripts/sample-scripts/bad-script1.sh
        ```

        Once the job has finished analyse its output file

        ```
        k1234567@erc-hpc-login2:~$ cat slurm-56749.out
        slurmstepd-erc-hpc-comp001: error: *** JOB 56749 ON erc-hpc-comp001 CANCELLED AT 2022-05-09T14:41:14 DUE TO TIME LIMIT ***
        ```

        and the accounting information

        ```
        k1234567@erc-hpc-login2:~$ sacct -j 56749
               JobID    JobName  Partition    Account  AllocCPUS      State ExitCode
        ------------ ---------- ---------- ---------- ---------- ---------- --------
        56749        bad-scrip+        cpu        kcl          1    TIMEOUT      0:0
        56749.batch       batch                   kcl          1  CANCELLED     0:15
        ```

        You can see that the job was killed because insufficient runtime was requested. Fix it by changing
        the runtime to 3 minutes which should conver the 2 minute sleep (You can alternatively decrease the sleep time).

        ```
        #SBATCH -t 0-0:03 # time (D-HH:MM)
        ```

        Once the amended script is submitted the output file should contain the following

        ```
        k1234567@erc-hpc-login2:~$ cat slurm-56751.out
        Hello World! erc-hpc-comp001
        ```

        and the accouting information should contain

        ```
        k1234567@erc-hpc-login2:~$ sacct -j 56751
               JobID    JobName  Partition    Account  AllocCPUS      State ExitCode
        ------------ ---------- ---------- ---------- ---------- ---------- --------
        56751        bad-scrip+        cpu        kcl          1  COMPLETED      0:0
        56751.batch       batch                   kcl          1  COMPLETED      0:0
        ```

## Job submission (part 2)

1. ### Multi-core SLURM jobs

    **Goal**: Submit a job requesting multiple cores on a single node.

    * Write a job script that requests two cores and does something that reports the information in its output
    * Submit the job and check whether the correct resources have been allocated to the job by SLURM. Does it match the output from your job?
    * How else could you have achieved the same resource request?

    ??? hint
        * Use `nproc` utility to print the number of allocated cpus for the job
        * Use `sacct` to check the resource allocation after the job has finished

    ??? example "Sample answer"
        Create a sample script `test-multicore.sh` and add the following contents to it:

        ```
        #!/bin/bash -l

        #SBATCH --job-name=test-multicore
        #SBATCH --partition=cpu
        #SBATCH --reservation=cpu_introduction
        #SBATCH --ntasks=1
        #SBATCH --cpus-per-task=2

        echo "I have "`nproc`" cpus."
        ```

        Submit the jobs using:

        ```
        k1234567@erc-hpc-login2:~$ sbatch test-multicore.sh
        Submitted batch job 56758
        ```

        Analyse the output, which should be located in the `slurm-jobid.out` file (replace `jobid` with the id of your job)

        ```
        k1234567@erc-hpc-login2:~$ cat slurm-56758.out
        I have 2 cpus.
        ```

        You can check the information about completed job using

        ```
        k1234567@erc-hpc-login2:~$ sacct -j 56758
               JobID    JobName  Partition    Account  AllocCPUS      State ExitCode
        ------------ ---------- ---------- ---------- ---------- ---------- --------
        56758        test-mult+        cpu        kcl          2  COMPLETED      0:0
        56758.batch       batch                   kcl          2  COMPLETED      0:0
        ```

        You should see the `AllocCPUS` with value of 2.

1. ### SLURM array jobs

    **Goal**: Submit an array job consisting of 3 tasks

    * Write a job script that defines an array of 3 tasks
    * Have your job print out the SLURM array task ID number in its output
    * Submit the script and then immediately check the status of the running job. How many individual jobs are running?
    * How do you identify array jobs and tasks in the queue displayed by SLURM?
    * Investigate the output files - how does an array job differ from the other jobs that you have been submitting?

    ??? hint
        * Use `sleep` command to delay the execution of the script so that you can check its status
        * Use `squeue` command to check the status of the running job.
        * Use `SLURM_ARRAY_TASK_ID` environment variable inside the job to get the task id associated witht he task.

    ??? example "Sample answer"
        Create a sample script `test-array.sh` and add the following contents to it:

        ```
        #!/bin/bash -l

        #SBATCH --job-name=test-array
        #SBATCH --partition=cpu
        #SBATCH --reservation=cpu_introduction
        #SBATCH --ntasks=1
        #SBATCH --array=1-3

        sleep 60
        echo "My task id is ${SLURM_ARRAY_TASK_ID}"
        ```

        Submit the jobs using

        ```
        k1234567@erc-hpc-login2:~$ sbatch test-array.sh
        Submitted batch job 56759
        ```

        Check the status of the job using:

        ```
        k1234567@erc-hpc-login2:~$ squeue --me
                     JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                   56759_1       cpu test-arr k1234567  R       0:12      1 erc-hpc-comp001
                   56759_2       cpu test-arr k1234567  R       0:12      1 erc-hpc-comp001
                   56759_3       cpu test-arr k1234567  R       0:12      1 erc-hpc-comp001
        ```

        You may see separate entries corresponding to each of the tasks in your array job.

        Analyse the output, which should be located in the `slurm-jobid_X.out` files (replace `jobid` with the id of your job).
        `X` will be a number corresponding to your tasks range, so you should have 3 separate log files, one for each array task.

        ```
        k1234567@erc-hpc-login2:~$ cat slurm-56759_1.out
        My task id is 1
        k1234567@erc-hpc-login2:~$ cat slurm-56759_2.out
        My task id is 2
        k1234567@erc-hpc-login2:~$ cat slurm-56759_3.out
        My task id is 3
        ```

1. ### Organising input for SLURM array jobs

    **Goal**: Define an array job where each task takes its input from a different file

    * Write an array job script where each task will print the contents of the files located in the `sample-files/arrayjob` folder in the supporting files directory
    * Each task should only print the contents of one file, no two tasks should print the same file
    * Submit the job, confirm the contents of the array tasks output files match the input file contents as intended

    ??? hint
        * Try to find the association between the task id and the filename
        * Use `cat` to print out the contents of the file

    ??? example "Sample answer"
        Create a sample script `test-array-files.sh` and add the following contents to it

        ```
        #!/bin/bash -l

        #SBATCH --job-name=test-array
        #SBATCH --partition=cpu
        #SBATCH --reservation=cpu_introduction
        #SBATCH --ntasks=1
        #SBATCH --array=1-3

        cat /datasets/hpc_training/sample-files/arrayjob/file${SLURM_ARRAY_TASK_ID}.txt
        ```

        Submit the jobs using

        ```
        k1234567@erc-hpc-login2:~$ sbatch test-array-files.sh
        Submitted batch job 56769
        ```

        Analyse the output, which should be located in the `slurm-jobid_X.out` files (replace `jobid` with the id of your job).
        `X` will be a number corresponding to your tasks range, so you should have 3 separate log files, one for each array task.

        ```
        k1234567@erc-hpc-login2:~$ cat slurm-56769_1.out
        Hello, I'm file 1
        k1234567@erc-hpc-login2:~$ cat slurm-56769_2.out
        Hello, I'm file 2
        k1234567@erc-hpc-login2:~$ cat slurm-56769_3.out
        Hello, I'm file 3  
        ```

## Singularity

1. ### Using containers in a batch job

    **Goal**: Submit a batch job and execute singularity container command

    * Submit the batch job using default scheduler options
    * Use `lolcow` container
    * Execute `cowsay` command within the container that prints `Hello there` string

    ??? hint
        * Use `cowsay string` command to print `string` text
        * Ensure that you use the correct path to the container file

    ??? example "Sample answer"
        Create a sample script `test-singularity.sh` and add the following contents to it

        ```
        #!/bin/bash -l

        #SBATCH --job-name=test-singularity
        #SBATCH --partition=cpu
        #SBATCH --reservation=cpu_introduction

        singularity exec ~/lolcow_latest.sif cowsay "Hello there"
        ```

        Submit the jobs using

        ```
        k1234567@erc-hpc-login2:~$ sbatch test-singularity.sh
        Submitted batch job 56748
        ```

        Analyse the output, which should be located in the `slurm-jobid.out` file (replace `jobid` with the id of your job)

        ```
        k1234567@erc-hpc-login2:~$ cat slurm-56748.out
         _____________
        < Hello there >
         -------------
                \   ^__^
                 \  (oo)\_______
                    (__)\       )\/\
                        ||----w |
                        ||     ||
        ```

1. ### Finding containers that are useful for your research

    **Goal**: Use DockerHub to find a container that could be useful for your research and run it with Singularity

    [DockerHub](https://hub.docker.com) is an online repository of container images.
    Many commonly used pieces of software have been containerized into images that are officially endorsed, providing a convenient way to use this software without needing to install it.

    * On DockerHub, search for some software you use in your research and see if you can find a container for that software
    * Can you find documentation about how to use the container?
    * Download the image to the HPC cluster
    * Run it with Singularity

        ??? hint

            * If you can't think of a software to search for, try searching for `R` or `python`.
            * Start an interactive session before running the commands
            * Use `singularity pull docker://{container name}` command to download the container (replacing the `{}` and their contents with the correct container name)
            * Use `singularity run` command to run the container

        ??? example "Sample answer"
            Let's search for a container that provides the `tidyverse` R packages.
            
            There is a `tidyverse` container provided by the `rocker` organisation.
            
            To pull the container, first start an interactive session as singularity is not available on
            the login nodes:

            ```
            srun --partition cpu --reservation cpu_introduction --pty /bin/bash -l
            ```

            We can then pull the container with:

            ```bash
            singularity pull tidyverse.sif docker://rocker/tidyverse
            ```

            We can run R using the container with:

            ```bash
            singularity exec tidyverse.sif R
            ```
