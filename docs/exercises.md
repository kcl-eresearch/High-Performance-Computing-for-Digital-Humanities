# Exercises

This section contains collection of exercises based on the material covered in the previous sections.

Sample answers are provided in-line in the expandable boxes, but please try to do exercises by yourself
before looking at the sample answers. There are also some hints to help you if you are stuck.

Supporting files can be found on CREATE HPC in `/datasets/hpc_training` directory. The
directory also contains example scripts from the exercises for convenience.

!!! info
    There might be multiple ways to achieve a specific goal - If your method does not match the sample
    answer it might not mean you have done things incorrectly, just differently.

## Navigating CREATE HPC

1. ### Filesystem navigation

    **Goal**: List the contents of your home directory and personal scratch

    * Where is your personal scratch directory located?

    ??? hint
        Use `ls` utility to list the contents, `cd` to change the directory and `pwd` to print the working (current) directory.

        Experiment with addition options to `ls` such as `la` or `ltra`.

    ??? example "Sample answer"
        Your home directory is located in `/users/k-number`, e.g. `/users/k1234567`.

        Your personal scratch can be found in `/scratch/users/k-number`, e.g. `/scratch/users/k1234567`

1. ### Filesystem quota reporting

    **Goal**: Display quota information for your account

    * What's the quota limit for your home directory?

    ??? example "Sample answer"
        Quota information is listed as part of MOTD when you log in, but you can also use `quotas` utility:

        ```
        k1234567@erc-hpc-login2:~$ quotas
        Path                     Type      Quota GB    Usage GB    Avail GB    Usage %
        -----------------------  ------  ----------  ----------  ----------  ---------
        /scratch/users/k1234567  User           200           0         200          0
        /users/k1234567          User            50          10          40         20
        ```

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
        #SBATCH --ntasks=1
        #SBATCH --nodes=1
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

    **Goal**: Request an interactive session with two cores and 4G of memory

    * Print the hostname of the interactive node that you have been allocated
    * Print number of cores available
    * What happens immediately after requesting the interactive job? How is it different from submitting a batch job? Why might this be a bad thing?

    ??? hint
        * Use `hostname` command to print the hostname of the node
        * Use `nproc` utility to print the number of allocated cpus for the job

    ??? example "Sample answer"

        Use `srun` command to request an interactive session

        ```
        k1234567@erc-hpc-login2:~$ srun -p cpu --ntasks 1 --cpus-per-task 2 --mem 4G --pty /bin/bash -l
        srun: job 56741 queued and waiting for resources
        srun: job 56741 has been allocated resources
        k1234567@erc-hpc-comp001:~$
        ```

        Print the hostname of the allocated node and number of cores that we have been allocated

        ```
        k1234567@erc-hpc-comp001:~$ hostname
        erc-hpc-comp001
        k1234567@erc-hpc-comp001:~$ nproc
        2
        ```

1. ### Debugging SLURM job scripts (1)

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

1. ### Debugging SLURM job scripts (2)

    **Goal**: Analyse and fix a SLURM batch job script

    * For this exercise, use the `bad-script2.sh` script located in the `sample-scripts` folder in the supporting files directory
    * Examine the job script, what resources does it request from SLURM?
    * Submit it as a batch job. What is the problem? Try to fix the issue.
    * How else could you have fixed the issue?

    ??? hint
        You will have to copy the script to your local workspace in order to modify it.

    ??? example "Sample answer"

        Submit the `/datasets/hpc_training/sample-scripts/bad-script2.sh` job

        ```
        k1234567@erc-hpc-login2:~$ sbatch /datasets/hpc_training/sample-scripts/bad-script2.sh
        ```

        Once the job has finished analyse its output file

        ```
        k1234567@erc-hpc-login2:~$ cat slurm-12345.out
        Settings:
        memset_increment_size => 0.0
        memset_size => 2
        memset_sleep => 10
        memalloc_sleep => 0
        cpuburn => 1
        memalloc => 1
        burntime => 20
        nprocs => 1
        memalloc_size => 2
        ncores => 1
        ...
        slurmstepd: error: Detected 1 oom-kill event(s) in step 12345.batch cgroup. Some of your processes may have been killed by the cgroup out-of-memory handler.
        ```

        and the accounting information:

        ```
        k1234567@erc-hpc-login2:~$ sacct -j 12345
               JobID    JobName  Partition    Account  AllocCPUS      State ExitCode
        ------------ ---------- ---------- ---------- ---------- ---------- --------
        12345        bad-scrip+        cpu    default          1 OUT_OF_ME+    0:125
        12345   .ba+      batch               default          1 OUT_OF_ME+    0:125
        ```

        This time the job was killed because of insufficient memory. Fix it by changing
        the required memory to 3G, or by decreasing the amount of memory needed by cpumemburn.

        ```
        #SBATCH --mem=3G
        ```

        Once the amended script is submitted the output file should contain the following:

        ```
        k1234567@erc-hpc-login2:~$ cat slurm-57619.out
        Settings:
        memset_increment_size => 0.0
        memset_size => 2
        memset_sleep => 10
        memalloc_sleep => 0
        cpuburn => 1
        memalloc => 1
        burntime => 20
        nprocs => 1
        memalloc_size => 2
        ncores => 1
        ...
        ```

        and the accouting information should contain:

        ```
        k1234567@erc-hpc-login2:~$ sacct -j 57619
               JobID    JobName  Partition    Account  AllocCPUS      State ExitCode
        ------------ ---------- ---------- ---------- ---------- ---------- --------
        57619        bad-scrip+        cpu    default          1  COMPLETED      0:0
        57619.ba+         batch               default          1  COMPLETED      0:0
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

1. ### GPU SLURM jobs

    **Goal**: Submit a job requesting gpu(s) on a single node.

    * Write a job script that requests single gpu and does something that reports the information in its output
    * Submit the job that requests two gpus and check the output

    ??? hint
        * Use `nvidia-smi --id=$CUDA_VISIBLE_DEVICES` utility to print the details of allocated gpu(s) for the job

    ??? example "Sample answer"
        Create a sample script `test-gpu.sh` and add the following contents to it:

        ```
        #!/bin/bash -l

        #SBATCH --job-name=test-gpu
        #SBATCH --partition=gpu
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

## Job submission (part 3)

1. ### Performance benchmarking

    **Goal**: Benchmark multi-core computations, understand the contribution from parallelisation

    * For this task, you will use a software program called `sharpen` that is in the `utils` folder in the supporting files directory. There are two versions:
        * `sharpen-fser`
          : This is the serial version of the code, it will only use a single core
        * `sharpen-fomp`
          : This is the multi-threaded version of the code, it can use any number of cores _on a single node_

        !!! info
            `sharpen` processes an image by convolving it with a filter (Gaussian and Laplacian functions). To speed up the process, the image is decomposed into an array, each chunk is then processed separately, in parallel, before recombining. This is an example of the [_divide and conquer_](https://en.wikipedia.org/wiki/Divide-and-conquer_algorithm) approach.

    * Write a job submission script that runs the `sharpen` application on a single core (it's sufficient to set a walltime of 1 minute).
    * Submit the job. `sharpen` reports how long the whole process took in its output, you should see two lines similar to this:

        ```
        Calculation time was 5.579000 seconds
        Overall run time was 5.671895 seconds
        ```

      How long did your job take? What is the most probable reason for the difference between 'calculation time' and 'overall run time'?

    * Now write another job script to run `sharpen` on 2 cores. What path/filename should you use for the `sharpen` binary (program)? What's a good choice for the walltime?
    * Submit the job. How long did the calculation take this time? What about the overall run time?
    * Now repeat the process, using 4 cores, then 8 cores, and finally 16 cores. Tabulate the results:

        | Cores  | Calculation time (s)  | Overall run time (s)  | Difference (s)    | Core-seconds  |
        |--------|-----------------------|-----------------------|-------------------|---------------|
        | 1      |                       |                       |                   |               |
        | 2      |                       |                       |                   |               |
        | 4      |                       |                       |                   |               |

    * Do the results make sense? Graph the different time metrics versus CPU cores — what is the profile of the different metrics?

    ??? hint
        * Copy the input file, `fuzzy.pgm` from the `sample-files/sharpen` folder in the supporting files directory to your working directory (`sharpen` expects `fuzzy.pgm` to be in the same directory from where you run the job)
        * Make sure you use `sharpen-fser` for the single-core job, and `sharpen-fomp` for the multi-core jobs

    ??? example "Sample answer"
        Create a sample script `sharpen-serial.sh` and add the following contents to it:

        ```
        #!/bin/bash -l

        #SBATCH --job-name=sharpen-serial
        #SBATCH --partition=cpu
        #SBATCH --time=0-0:01
        #SBATCH --ntasks=1

        cp /datasets/hpc_training/sample-files/sharpen/fuzzy.pgm ./
        /datasets/hpc_training/utils/sharpen-fser
        ```

        Submit the job using:

        ```
        k1234567@erc-hpc-login2:~$ sbatch sharpen-serial.sh
        Submitted batch job 13629786
        ```

        Examine the output, which should be located in the `slurm-jobid.out` file (replace `jobid` with the id of your job):

        ```
        k1234567@erc-hpc-login2:~$ tail -n 3 slurm-13629786.out
        Calculation time was 5.579000 seconds
        Overall run time was 5.671895 seconds
        ```

        Create another script, called `sharpen-parallel.sh`, with the following content:

        ```
        #!/bin/bash -l

        #SBATCH --job-name=sharpen-parallel
        #SBATCH --partition=cpu
        #SBATCH --time=0-0:00:30    # You might expect the job to take half as long, so you cut your time request in half
        #SBATCH --ntasks=2

        cp /datasets/hpc_training/sample-files/sharpen/fuzzy.pgm ./
       /datasets/hpc_training/utils/sharpen-fomp
        ```

        Submit the job using:

        ```
        k1234567@erc-hpc-login2:~$ sbatch sharpen-parallel.sh
        Submitted batch job 13629787
        ```

        Examine the output file to record the run times again, then change the `sharpen-parallel.sh` script to request more cores (4, 8, 16) and re-submit.
        Add the run times to your table (your results may differ from the example shown here):

        | Cores  | Overall run time (s)  | Calculation time (s)  | I/O time (s)  | Total core seconds  |
        |------- |---------------------- |---------------------- |------------- |-------------------- |
        | 1      | 5.544246              | 5.410836              | 0.13341      | 5.410836            |
        | 2      | 2.917452              | 2.804676              | 0.112776     | 5.609352            |
        | 4      | 1.609339              | 1.48881               | 0.120529     | 5.95524             |
        | 8      | 0.924753              | 0.793237              | 0.131516     | 6.345896            |
        | 12     | 0.665114              | 0.530394              | 0.13472      | 6.364728            |
        | 24     | 0.40722               | 0.268055              | 0.139165     | 6.43332             |
        | 48     | 0.315862              | 0.136599              | 0.179263     | 6.556752            |
        | 96     | 0.239602              | 0.071997              | 0.167605     | 6.911712            |

        Using more cores results in a faster time to solution (overall run time).

        The difference between overall time and calculation time is mostly due to I/O, when the processed chunks are combined and the result file written out. Disk input/output is often significantly slower than CPU calculation. The nature of the `sharpen` code is such that this step is the same, regardless of the number of CPU cores (i.e. it is not parallelised), therefore, this value is roughly the same for all runs.
        The total core-seconds used is an indication of efficiency (see the next section); it increases with core count.

1. ### Analysing parallel performance and resource optimisation

    **Goal**: Understand performance scaling, parallel efficiency & speed-up

    * Now we have some data showing the performance of our application we need to try and draw some useful conclusions as to what the most efficient set of resources are to use for our jobs. To do this we introduce two metrics:

        * **Speedup**
          : The ratio of the baseline runtime (or runtime on the lowest core count) to the runtime at the specified core count. i.e. baseline runtime divided by runtime at the specified core count.
        * **Ideal speedup**
          : The expected speedup if the application showed perfect scaling. i.e. if you double the number of cores, the application should run twice as fast.
        * **Parallel efficiency**
          : The percentage of ideal speedup actually obtained for a given core count. This gives an indication of how well you are exploiting the additional resources you are using.

    * Using the run times from your calculations in the previous exercise, complete the following table:

        | Cores  | Overall run time (s)  | Ideal speed-up  | Actual speed-up  | Parallel efficiency  |
        |--------|-----------------------|-----------------|------------------|----------------------|
        | 1      |                       |                 |                  |                      |
        | 2      |                       |                 |                  |                      |
        | 4      |                       |                 |                  |                      |

    * What number of cores is the most _efficient_, irrespective of total time to result?
    * What number of cores gives the _fastest overall_ result, irrespective of efficiency?
    * What would be a good number of cores to use for this application? Why did you choose that? What other factors might come into play?
    * Now repeat the tabulation, using **Calculation time** instead of overall run time. This factors out the non-parallised part of the computation (I/O time) — how well has the calculation part been parallelised?

    ??? example "Sample answer"
        The table below shows these metrics calculated for example results

        | Cores  | Overall run time (s)  | Ideal speedup  | Actual speedup    | Parallel efficiency  |
        |------- |---------------------- |--------------- |------------------ |--------------------- |
        | 1      | 5.544246              | 1              | 1                 | 100%                 |
        | 2      | 2.917452              | 2              | 1.90037265394598  | 95%                  |
        | 4      | 1.609339              | 4              | 3.44504545033706  | 86%                  |
        | 8      | 0.924753              | 8              | 5.99538038806038  | 75%                  |
        | 12     | 0.665114              | 12             | 8.33578303869713  | 69%                  |
        | 24     | 0.40722               | 24             | 13.614866656844   | 57%                  |
        | 48     | 0.315862              | 48             | 17.5527477189406  | 37%                  |
        | 96     | 0.239602              | 96             | 23.1393978347426  | 24%                  |

        Using a single core is always the most efficient, by definition.

        In this example, the speed-up is always positive, that is, using more cores gives a faster overall time to solution, albeit at the expense of actual efficiency. Note that, for more complex calculations, especially where there is a dependency between component parts at some point there is often an inflection where using more cores results in a _slower_ time to solution (for example, many-to-many body particle interactions simulations neccesitate communication of information between parallel workers; this _increases_ with core count, off-setting the gains from parallelisation).

        Good parallel efficiency is often considered to be 70% or greater. On a busy HPC system, jobs with greater resources might queue for longer than smaller jobs — balancing overall time to solution with efficiency is difficult to predict when one factors in queueing time.

1. ### Jupyter Lab/Notebook jobs

    **Goal**: Submit a Jupyter lab notebook job and connect to it using SSH tunnelling

    * Jupyter Lab should be installed in a Python virtual environment
    * Sample `test-jlab.sh` script is located in the `sample-scripts` folder in the supporting files directory. You won't have to change any existing content but you will have to add some things in

    ??? hint
        * You will have to copy the script to your local workspace in order to modify it
        * Create python virtual environment and install `jupyterlab` package into it
        * Once the job is running the output file will give you the ssh tunnel detils

    ??? example "Sample answer"

        First of all we need to create the python virtualenv and install jupyter lab package:

        ```
        k1234567@erc-hpc-login2:~$ module load python/3.8.12-gcc-9.4.0
        k1234567@erc-hpc-login2:~$ python -m venv jvenv
        k1234567@erc-hpc-login2:~$ source jvenv/bin/activate
        (jvenv) k1234567@erc-hpc-login2:~$ pip install jupyterlab
        Collecting jupyterlab
        ...
        Successfully installed MarkupSafe ...
        (jvenv) k1234567@erc-hpc-login2:~$ deactivate
        ```

        Next we copy the `test-jlab.sh` and modify it. The only two things that need to be added are:

        * Module loading of the python module
        * Virtualenv activation before the `jupyter-lab` command is executed

        After the modifications the script might look like:

        ```
        #!/bin/bash -l

        #SBATCH --job-name=test-jlab
        #SBATCH --partition=cpu
        #SBATCH --ntasks=1
        #SBATCH --mem=2G
        #SBATCH --signal=USR2
        #SBATCH --cpus-per-task=1

        module load python/3.8.12-gcc-9.4.0

        # get unused socket per https://unix.stackexchange.com/a/132524
        readonly IPADDRESS=$(hostname -I | tr ' ' '\n' | grep '10.211.4.')
        readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
        cat 1>&2 <<END
        1. SSH tunnel from your workstation using the following command:

           ssh -NL 8888:${HOSTNAME}:${PORT} ${USER}@hpc.create.kcl.ac.uk

           and point your web browser to http://localhost:8888

        When done using the notebook, terminate the job by
        issuing the following command on the login node:

              scancel -f ${SLURM_JOB_ID}

        END

        source jvenv/bin/activate
        jupyter-lab --port=${PORT} --ip=${IPADDRESS} --no-browser

        printf 'notebook exited' 1>&2
        ```

        Next submit the job and wait until its running

        ```
        k1234567@erc-hpc-login2:~$ sbatch test-jlab.sh
        ```

        Once the job has started look at the output file - at the top of the file there will be instructions
        on how to connect to the instance from you laptop/workstation using ssh tunnel.

        After the connection instructions, there will be jupyter lab specific output. You can ignore most of it with the exception
        of the token that you will need to authenticate to the web interface.

## Singularity

1. ### Singularity container usage

    **Goal**: Pull and run a container

    * Pull the `lolcow` Singularity container and run it. What is the output?

    ??? hint
        * Start an interactive session before running the commands
        * Use `singularity pull` command to download the container
        * Use `singularity run` command to run the container

    ??? example "Sample answer"
        Start an interactive session first as singularity is not available on
        the login nodes

        ```
        srun --partition cpu --pty /bin/bash -l
        ```

        After the resources have been allocated, pull the lolcow container using `singularity pull`

        ```
        k1234567@erc-hpc-comp179:~$ singularity pull docker://sylabsio/lolcow
        INFO:    Converting OCI blobs to SIF format
        INFO:    Starting build...
        Getting image source signatures
        ...
        INFO:    Creating SIF file...
        ```

        Once the container has been downloaded use `run` command to run it

        ```
        k1234567@erc-hpc-comp179:~$ singularity run lolcow_latest.sif
        INFO:    Converting SIF file to temporary sandbox...
         ________________________________________
        / Alas, how love can trifle with itself! \
        |                                        |
        | -- William Shakespeare, "The Two       |
        \ Gentlemen of Verona"                   /
         ----------------------------------------
                \   ^__^
                 \  (oo)\_______
                    (__)\       )\/\
                        ||----w |
                        ||     ||
        ```

1. ### Slurm container batch job submission

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
