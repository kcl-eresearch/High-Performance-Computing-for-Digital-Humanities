# Jupyter notebooks

Jupyter notebooks provide a convenient way to run Python code and visualise outputs through a graphical user interface.

HPC clusters typically don't provide access to a graphical user interface - all interactions happen through the terminal.
However, there are ways to run software with a graphical user interface on an HPC cluster.
This allows you to benefit from the resources available on the HPC (multiple cores for parallel jobs, more memory than available on your computer)
while also having the convenience of a familiar graphical user interface.

## Installing Jupyterlab

We will use `jupyterlab` to run a Jupyter notebook.
We'll create a new Python virtual environment for this,
but note that you could also install the `jupyterlab` package within an existing virtual environment if you have created one for a specific project.

```bash
module load python/3.11.6-gcc-13.2.0
python -m venv jupyter_env
```

We'll activate the environment and install the `jupyterlab` package.

```bash
source jupyter_env/bin/activate
pip install jupyterlab
```

## Submission script

The submission script we'll use to run jupyterlab is shown below.
We'll go through each section in turn.

```bash
#!/bin/bash -l

#SBATCH --job-name=ops-jupyter
#SBATCH --partition=cpu
#SBATCH --ntasks=1
#SBATCH --mem=2G
#SBATCH --signal=USR2
#SBATCH --cpus-per-task=1

module load python/3.11.6-gcc-13.2.0
source jupyter_env/bin/activate

# get unused socket per https://unix.stackexchange.com/a/132524
readonly IPADDRESS=$(hostname -I | tr ' ' '\n' | grep '10.211.4.')
readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
cat 1>&2 <<END
1. SSH tunnel from your workstation using the following command:

   Linux and MacOS:
   ssh -NL 8888:${HOSTNAME}:${PORT} ${USER}@hpc.create.kcl.ac.uk

   Windows:
   ssh -m hmac-sha2-512 -NL 8888:${HOSTNAME}:${PORT} ${USER}@hpc.create.kcl.ac.uk

   and point your web browser to http://localhost:8888/lab?token=<add the token from the jupyter output below>

When done using the notebook, terminate the job by
issuing the following command on the login node:

      scancel -f ${SLURM_JOB_ID}

END

jupyter-lab --port=${PORT} --ip=${IPADDRESS} --no-browser

printf 'notebook exited' 1>&2
```

The first section of this is the #SBATCH statements which specify the resources we're requesting. If you want to request
more memory or CPU cores, you'll need to modify this section. For example, to use 8 CPU cores and 25GB of memory:

```text
#!/bin/bash -l

#SBATCH --job-name=jupyter
#SBATCH --partition=cpu
#SBATCH --ntasks=1
#SBATCH --mem=2G
#SBATCH --signal=USR2
#SBATCH --cpus-per-task=1
```

!!!tip
    To effectively make use of multiple CPU cores in Python code, you will usually need to explicitly
    specify this in your Python code, e.g. by [using the Numba package](parallel_jobs.md#python-example).
    If you're not sure that you'll use them, don't request multiple CPU cores - you'll tie up resources
    that other users might want to use, and it'll slow down allocation of resources for your job.

Next, the Python module is loaded and the virtual environment we just created is activated.

```text
module load python/3.11.6-gcc-13.2.0
source jupyter_env/bin/activate
```

The next block does some setup and prints some information to the SLURM output file which will explain how to connect to your Jupyterlab session after you submit the job.

```text
# get unused socket per https://unix.stackexchange.com/a/132524
readonly IPADDRESS=$(hostname -I | tr ' ' '\n' | grep '10.211.4.')
readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
cat 1>&2 <<END
1. SSH tunnel from your workstation using the following command:

   Linux and MacOS:
   ssh -NL 8888:${HOSTNAME}:${PORT} ${USER}@hpc.create.kcl.ac.uk

   Windows:
   ssh -m hmac-sha2-512 -NL 8888:${HOSTNAME}:${PORT} ${USER}@hpc.create.kcl.ac.uk

   and point your web browser to http://localhost:8888/lab?token=<add the token from the jupyter output below>

When done using the notebook, terminate the job by
issuing the following command on the login node:

      scancel -f ${SLURM_JOB_ID}

END
```

The final section of the batch script runs jupyterlab.

```text
jupyter-lab --port=${PORT} --ip=${IPADDRESS} --no-browser
```

Submit the script using `sbatch`, wait for the job to start (use `squeue --me` to check the status of your jobs),
and check the output file for connection information:

```bash
k1234567@erc-hpc-login2:~$ sbatch jupyter.sh
Submitted batch job 15244802
k1234567@erc-hpc-login2:~$ cat slurm-15244802.out
```


On your laptop or desktop, start a new terminal session and run the ssh command given in your job's output,
e.g. `ssh -NL 8888:erc-hpc-comp015:53723 k1234567@hpc.create.kcl.ac.uk`.

!!!tip
    This will produce a message saying you may need to visit the e-Research Portal to authorise
    your SSH connection, but then no further output, even if successful. This is expected!

Then in your web browser go to [http://localhost:8888/lab?token=<add the token from the jupyter output below>](http://localhost:8888), and you should see the Jupyter Lab interface.

When you're finished working, close the browser tab,
use `Ctrl+C` to close the SSH tunnel,
then on the HPC run `scancel -f <your job id>`, as given in the output file of your job, to cancel the
job's allocation and free up the resources.
