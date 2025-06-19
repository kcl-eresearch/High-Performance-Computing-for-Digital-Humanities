# Submitting Jobs

## The scheduler

HPC systems are usually composed out of large number of nodes and have large number of users simultaneously using the facility.
How do we ensure that the available resources are managed properly?
This is a job of the scheduler, which is a heart and soul of the system and it's resposible for managing the jobs that are run on the cluster.

As an analogy, think of the scheduler as a waiter in busy restaurant. This hopefully will give you some idea why sometimes
you have to wait for the job to run.

![Waiter analogy](images/restaurant_queue_manager.svg)

CREATE is using [SLURM](https://slurm.schedmd.com) scheduler, which stands for Simple Linux Utility for Resource Management.
SLURM is commonly used by other HPC systems as well.
You may also encounter other job schedulers such as [PBS](https://www.openpbs.org/).
These work on similar principles, although the exact commands and terminology will be different.

## Partitions

You can think of partitions as queues - they reside over specific sets of resources and allow access to particular groups.
Following the restaurant analogy, think of them as different sections of the restaurant and corresponding queues assigned to them.

The public partitions available on CREATE HPC are:

* `cpu`: Partition for cpu jobs
* `gpu`: Partition for gpu jobs
* `long_cpu` and `long_gpu`: Partitions for long running jobs. Requires justification and explicit permission to use
* `interruptible_cpu` and `interruptible_gpu`: Partitions that use unused capacity on private servers

In addition, specific groups/faculties have their own partitions on CREATE HPC that can only be used by members of those groups.
The list of CREATE partitions and who can use them can be found in our [documentation](https://docs.er.kcl.ac.uk/CREATE/running_jobs/#identify-your-partition).
Additional information about the resource constraints can be found [here](https://docs.er.kcl.ac.uk/CREATE/scheduler_policy/).

You can get the list of partitions that are available to you via `sinfo --summarize` command:

```text
k1234567@erc-hpc-login1:~$ sinfo --summarize
PARTITION         AVAIL  TIMELIMIT   NODES(A/I/O/T) NODELIST
cpu*                 up 2-00:00:00        35/0/0/35 erc-hpc-comp[001-028,183-189]
gpu                  up 2-00:00:00        13/6/0/19 erc-hpc-comp[030-040],erc-hpc-vm[011-018]
interruptible_cpu    up 1-00:00:00       20/65/0/85 erc-hpc-comp[041-047,058-109,128-133,135,137,139-151,153-154,157,179-180]
interruptible_gpu    up 1-00:00:00       24/17/2/43 erc-hpc-comp[048-057,110-127,134,170-178,190-194]
```

Any additional rows you see in the output of `sinfo` will be private partitions you have access to.

!!! hint
    `NODES(A/I/O/T)` column refers to nodes state in the form `allocated/idle/other/total`.

## Submitting jobs

In most cases you will be submitting non-interactive jobs, commonly referred to as batch jobs. For this you will be
using the [`sbatch`](https://slurm.schedmd.com/sbatch.html) utility.

To submit a job to the queue, we need to write a **shell script** which contains the commands we want to run.
When the scheduler picks our job from the queue, it will run this script.
There's several ways we could create this script on the cluster, but for short scripts it's often easiest to use a **command line text editor** to create it directly on the cluster.
For more complex scripts you might prefer to write them on your computer and transfer them across, but it's relatively rare that job submission scripts get that complex.

One common text editor that you should always have access to on systems like CREATE is `nano`:

```bash
nano test_job.sh
```

Nano is relatively similar to a basic graphical text editor like Notepad on Windows - you have a cursor (controlled by the arrow keys) and text is entered as you type.
Once we're done, we can use `Ctrl + O` to save the file - at this point if we haven't already told Nano the filename it will ask for one.
Then finally, `Ctrl + X` to exit back to the command line.
If we ever forget these shortcuts, Nano has a helpful reminder bar at the bottom.

If you find yourself doing a lot of text editing on the cluster, it may be worth learning to use a more advanced text editor like Vim or Emacs, but Nano is enough for most people.

We are going to start with a simple shell script `test_job.sh` that will contain the commands to be run during the job execution:

```bash
#!/bin/bash -l

echo "Hello World! "`hostname`
sleep 60
```

From the login node, submit the job to the scheduler using:

```bash
sbatch --partition cpu test_job.sh
```

If necessary we can also often get test jobs like these to run more quickly by using the `interruptible_cpu` queue.
The interruptible queues make use of otherwise unused space on private nodes, but if the owner of the nodes wants to use them, your running jobs may be cancelled.
It's useful for quick testing, but if you're going to use the interruptible queues for real jobs you need to make sure they can be safely cancelled and not lose progress - this is often done via **checkpointing**.

Once the command is executed you should see something similar to:

```text
k1234567@@erc-hpc-login1:~$ sbatch --partition cpu test_job.sh
Submitted batch job 56543
```

!!! info
    If you do not define a partition during the job submission the default, cpu partition will be used.

The job id (`56543`) is a unique identifier assigned to your job and can be used to query the status of the job. We will go through it
in the [job monitoring](#job-monitoring) section.

!!! Important
    When submitting a support request please provide relevant jobids of the failed, or problematic jobs.

### Interactive jobs

Sometimes you might need, or want to run things interactively, rather than submitting them as batch jobs.
This could be because you want to debug or test something, or the application/pipeline does not support
non-interactive execution. To request an interactive job via the scheduler use the [`srun`](https://slurm.schedmd.com/srun.html) utility:

```bash
srun --partition cpu --pty /bin/bash -l
```

The request will go through the scheduler and if resources are available you will be placed on
a compute node, i.e.

```text
k1234567@erc-hpc-login1:~$ srun --partition cpu --pty /bin/bash -l
srun: job 56544 queued and waiting for resources
srun: job 56544 has been allocated resources
k1234567@erc-hpc-comp001:~$
```

To exit an interactive job, we use the Bash command `exit` - this exits the current shell, so if you're inside an interactive job it will exit that, if you're just logged in to one of the login nodes, it will disconnect your SSH session.

!!! warning
    At the moment there are no dedicated partitions, or nodes for interactive sessions and those sessions share the resources with
    all of the other jobs. If there are no free resources available you request will fail.

!!! info "Running applications with Graphical User Interfaces (GUIs)"

    To run an interactive job for an application with a Graphical User Interface (GUI), for example RStudio, you must enable 'X11 forwarding' and 'authentication agent forwarding' when you connect to CREATE:

    ```bash
    ssh -XA hpc.create.kcl.ac.uk
    ```

    Then request compute resources using `salloc` - once your resources have been allocated you can then connect to the node with a further `ssh` connection:

    ```bash
    salloc <parameters>
    ssh -X $SLURM_NODELIST
    xeyes
    ```

## Job monitoring

It is important to be able to see the status of your running jobs, or to find out information
about completed, or failed jobs.

To monitor the status of the running jobs use [`squeue`](https://slurm.schedmd.com/squeue.html) utility.
Without any arguments, the command will print queue information for all users, however you can use `--me` parameter
to filter the list:

```text
k1234567@erc-hpc-login1:~$ squeue --me
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
             56544       cpu     bash k1234567  R       6:41      1 erc-hpc-comp001
```

!!! Info
    Job state is described in the `ST` column. For the full list of states please see [squeue](https://slurm.schedmd.com/squeue.html)
    docs (JOB STATE CODES section).

    The most common codes that you might see are:

    * `PD`: Pending - Job is awaiting resource allocation.
    * `R`: Running - Job currently has an allocation.
    * `CG`: Completing - Job is in the process of completing. Some processes on some nodes may still be active.
    * `CD`: Completed - Job has terminated all processes on all nodes with an exit code of zero.

For jobs that have finished, you can use [`sacct`](https://slurm.schedmd.com/sacct.html) utility to extract the relevant information.

```text
sacct -j 56543
       JobID    JobName  Partition    Account  AllocCPUS      State ExitCode
------------ ---------- ---------- ---------- ---------- ---------- --------
56543        test_job.+        cpu        kcl          1  COMPLETED      0:0
56543.batch       batch                   kcl          1  COMPLETED      0:0
```

The above shows the default information.

You can use `--long` option to display all of the stored information, or alternatively
you can customise your queries to display the information that you specifically looking for by using `--format` parameter:

```text
sacct -j 13378473 --format=ReqMem,AllocNodes,AllocCPUS,NodeList,JobID,Elapsed,State
    ReqMem AllocNodes  AllocCPUS        NodeList        JobID    Elapsed      State
---------- ---------- ---------- --------------- ------------ ---------- ----------
    1000Mc          1          1         noded19 13378473       00:00:01  COMPLETED
    1000Mc          1          1         noded19 13378473.ba+   00:00:01  COMPLETED
```

For the list of available options please see the job accounting fields in the [`sacct`](https://slurm.schedmd.com/sacct.html) documentation.

!!!tip "Check how efficiently your job used its resources"
    `sacct` can be used to check how efficiently your job used the resources you requested.
    For example, you can use the option `--format=JobID,JobName,Timelimit,Elapsed,CPUTime,ReqCPUS,NCPUS,ReqMem,MaxRSS`
    to get information on the maximum memory usage, total elapsed time, and CPU time used by your job.

    ```bash
    k1234567@erc-hpc-login1:~$ sacct -j 8328 --format=JobID,JobName,Timelimit,Elapsed,CPUTime,ReqCPUS,NCPUS,ReqMem,MaxRSS
    JobID           JobName  Timelimit    Elapsed    CPUTime  ReqCPUS      NCPUS     ReqMem     MaxRSS
    ------------ ---------- ---------- ---------- ---------- -------- ---------- ---------- ----------
    8328           hellowor   00:02:00   00:00:07   00:00:28        4          4         2G
    8328.ba+          batch              00:00:07   00:00:28        4          4               325772K
    ```

    The example job above requested 2GB of memory but only used about 0.33 GB, and requested up to 2 minutes but only took 7 seconds.

    You should look at resource usage of your jobs and use this to guide the resources you request for similar jobs in the future.
    Jobs that request lower resources will likely be scheduled faster.
    Requesting only the resources you need also ensures that the HPC resources are used efficiently.
    Requesting more CPUs or memory than you need can stop other people's jobs running and lead to significant HPC resources sitting idle.

## Cancelling jobs

You can cancel running, or queued job using [`scancel`](https://slurm.schedmd.com/scancel.html) utility. You can cancel
specific jobs using their `jobid`

```bash
k1234567@erc-hpc-login1:~$ scancel 56544
```

If you want to cancel all of your jobs you can add the `--user` option

```bash
k1234567@erc-hpc-login1:~$ scancel --user k1234567
```

## Choosing the resources

Jobs require resources to be defined, e.g. number of nodes, cpus, amount of memory or the runtime.
Defaults, such as 1 day runtime, 1 core, 1 node, etc are provided for convenience,
but in most cases they will not be sufficient to accomodate more intensive jobs and explicit request has to be made for more.

!!! warning
    If you do not request enough resources and your job exceeds the allocated amount, it will be terminated by the scheduler.

The resources can be requested by passing additional options to the `sbatch` and `srun` commands. In most cases
you will be using the following parameters to define the resources for your job:

* partition: `--partition`, or `-p` defines which partition, or queue your job will be targeting
* memory: `--mem` defines how much memory your job needs per allocated node
* tasks: `--ntasks`, or `-n` defines how many tasks your job needs
* nodes: `--nodes`, or `-n` defines how many nodes your job requires
* cpus per task: `--cpus-per-task`, defines how many cpus per task are needed
* runtime: `--time`, or `-t` defines how much time your job needs to run (in the `D-HH:MM` format)
* reservation: `--reservation` asks the scheduler to allocate your job to some pre-existing reserved space

For a full list of options please see [sbatch](https://slurm.schedmd.com/sbatch.html) documentation.

You can provide those options as arguments to the `sbatch`, or `srun` commands, i.e.

```bash
sbatch --job-name test_job --partition cpu --ntasks 1 --mem 1G --time 0-0:2 test_job.sh
```

however that can be time consuming and prone to errors. Luckily you can also define those resource requirements
in your submission scripts using `#SBATCH` tags. The sample job from the [previous section](#submitting-jobs)
will look like:

```bash
#!/bin/bash -l

#SBATCH --job-name=hello-world
#SBATCH --partition=cpu
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH -t 0-0:2 # time (D-HH:MM)

echo "Hello World! "`hostname`
sleep 60
```

!!! info
    In bash, and other shell scripting languages `#` is a special character usually representing comment
    (`#!` is an exception used to define the interpreter that the script will be executed with) and is ignored during the execution.
    For information on special characters in bash please see [here](https://tldp.org/LDP/abs/html/special-chars.html).

`#SBATCH` is a special tag that will be interpreted by SLURM (other schedulers utilise similar mechanism) when the job is submitted.
When the script is run outside the scheduler it will be ignored (becuse of the `#` comment).
This is quite useful, as it means the script can be executed outside the scheduler control and will run successfully.

!!! Hint
    When requesting resources try to request them close to what your job needs, rather than requesting the maximum.
    Think back to the restaurant analogy - it's easier to find a table for a group of two people than a group of eight,
    so your job will likely be scheduled sooner.
    This also ensures that the HPC resources are being used efficiently.

### Advanced resource requirements

In some situations you might want to request specific hardware, such as chipset or fast network interconects.
This can be achived with the use of `--constrain` option.

To request a specific type of GPU `a100` you would use

```text
#SBATCH --constrain=a100
```

or to request a specific type of processor/architecture you would use

```text
#SBATCH --constrain=haswell
```

## Job log files

By default the log files will be placed in the directory you have made your submission from (i.e. current working directory) in the format of `slurm-jobid.out`.
Both [stdout and stderr streams](https://en.wikipedia.org/wiki/Standard_streams) will be redirected from the job to that file.
These log files are important as they will give you clueues about the execution of your application in particular why it has failed.

You can modify this to suit your needs by explicitly defining different path

```bash
#SBATCH --output=/scratch/users/%u/%j.out
```

You can also separate the stdout and stderr into separate log files

```bash
#SBATCH --output=/scratch/users/%u/%j.out
#SBATCH --error=/scratch/users/%u/%j.err
```

!!! info
    `%u` and `%j` are replacement symbols (representing username and job id) that will be replaced with actual values once the job is submitted.
    Please see [file patterns section](https://slurm.schedmd.com/sbatch.html) for details.

## Exercises - submitting jobs

Work through the exercises in [this section](exercises.md/#job-submission-part-1) to practice submitting and debugging jobs.
