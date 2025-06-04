# RStudio

[RStudio](https://posit.co/products/open-source/rstudio/) provides an integrated development environment (IDE) for the R programming language.
RStudio on CREATE HPC provides access to all the benefits of the HPC (multiple cores for parallel jobs, more memory than available on your computer)
while also having the convenience of the RStudio graphical user interface.

RStudio is available on CREATE through the modules system:

```text
k1234567@erc-hpc-login2:~$ module spider rstudio

---------------------------------------------------------------------------------------------------------------------------------------------
  rstudio:
---------------------------------------------------------------------------------------------------------------------------------------------
     Versions:
        rstudio/v2023.03.0_386-gcc-11.4.0-r-4.1.1-python3+-chk-version
        rstudio/v2023.03.0_386-gcc-11.4.0-r-4.2.2-python3+-chk-version
        rstudio/v2023.03.0_386-gcc-11.4.0-r-4.3.0-python3+-chk-version

---------------------------------------------------------------------------------------------------------------------------------------------
  For detailed information about a specific "rstudio" package (including how to load the modules) use the module's full name.
  Note that names that have a trailing (E) are extensions provided by other modules.
  For example:

     $ module spider rstudio/v2023.03.0_386-gcc-11.4.0-r-4.3.0-python3+-chk-version
---------------------------------------------------------------------------------------------------------------------------------------------

```

!!!tip
    Note that there may be versions of RStudio available that use different versions of R. Make sure
    you choose the one you want to use. Since different minor releases of R use different library
    locations, you will need to install packages separately for each one.

To run RStudio on the compute nodes and access their resources, it's necessary to submit a batch job and then create an SSH tunnel from your
machine to the running process. To submit a batch job to run RStudio, the e-Research team provides a
[template script](https://docs.er.kcl.ac.uk/CREATE/software/rstudio/).

```text
#!/bin/bash -l

#SBATCH --job-name=ops-rstudio
#SBATCH --partition=cpu
#SBATCH --ntasks=1
#SBATCH --mem=2G
#SBATCH --signal=USR2
#SBATCH --cpus-per-task=1

module load rstudio/v2023.03.0_386-gcc-11.4.0-r-4.3.0-python3+-chk-version

# get unused socket per https://unix.stackexchange.com/a/132524
export PASSWORD=$(openssl rand -base64 15)
readonly IPADDRESS=$(hostname -I | tr ' ' '\n' | grep '10.211.4.')
readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
cat 1>&2 <<END
1. SSH tunnel from your workstation using the following command:

   Linux and MacOS:
   ssh -NL 8787:${HOSTNAME}:${PORT} ${USER}@hpc.create.kcl.ac.uk

   Windows:
   ssh -m hmac-sha2-512 -NL 8787:${HOSTNAME}:${PORT} ${USER}@hpc.create.kcl.ac.uk

   and point your web browser to http://localhost:8787

2. Login to RStudio Server using the following credentials:

   user: ${USER}
   password: ${PASSWORD}

When done using the RStudio Server, terminate the job by:

1. Exit the RStudio Session ("power" button in the top right corner of the RStudio window)
2. Issue the following command on the login node:

      scancel -f ${SLURM_JOB_ID}

END

# Create custom database config
DBCONF=$TMPDIR/database.conf
if [ ! -e $DBCONF ]
then
printf "\nNOTE: creating $DBCONF database config file.\n\n"
echo "directory=$TMPDIR/var-rstudio-server" > $DBCONF
fi

rserver --server-user ${USER} --www-port ${PORT} --server-data-dir $TMPDIR/data-rstudio-server \
--secure-cookie-key-file $TMPDIR/data-rstudio-server/secure-cookie-key \
--database-config-file=$DBCONF --auth-none=0 \
--auth-pam-helper-path=pam-env-helper

printf 'RStudio Server exited' 1>&2
```

We'll go through this script section by section.
The first section of this is the #SBATCH statements which specify the resources we're requesting. If you want to request
more memory or CPU cores, you'll need to modify this section. For example, to use 8 CPU cores and 25GB of memory:

```text
#!/bin/bash -l

#SBATCH --job-name=ops-rstudio
#SBATCH --partition=cpu
#SBATCH --ntasks=8
#SBATCH --mem=25G
#SBATCH --signal=USR2
#SBATCH --cpus-per-task=1
```

!!!tip
    To effectively make use of multiple CPU cores in R code, you will usually need to explicitly set up R
    to use these, e.g. by using the `parallel` package or the `future` package. If you're not sure that you'll
    use them, don't request multiple CPU cores - you'll tie up resources that other users might want to
    use and it'll slow down allocation of resources for your job.

Next, the RStudio module is loaded - make sure the module version here matches the R version you want to use and is
one of the options available to you in the output of `module spider rstudio`.

```text
module load rstudio/v2023.03.0_386-gcc-11.4.0-r-4.3.0-python3+-chk-version
```

The next block does some setup and prints some information to the SLURM output file which will explain how to connect
to your RStudio session after you submit the job.

```text
# get unused socket per https://unix.stackexchange.com/a/132524
export PASSWORD=$(openssl rand -base64 15)
readonly IPADDRESS=$(hostname -I | tr ' ' '\n' | grep '10.211.4.')
readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
cat 1>&2 <<END
1. SSH tunnel from your workstation using the following command:

   Linux and MacOS:
   ssh -NL 8787:${HOSTNAME}:${PORT} ${USER}@hpc.create.kcl.ac.uk

   Windows:
   ssh -m hmac-sha2-512 -NL 8787:${HOSTNAME}:${PORT} ${USER}@hpc.create.kcl.ac.uk

   and point your web browser to http://localhost:8787

2. Login to RStudio Server using the following credentials:

   user: ${USER}
   password: ${PASSWORD}

When done using the RStudio Server, terminate the job by:

1. Exit the RStudio Session ("power" button in the top right corner of the RStudio window)
2. Issue the following command on the login node:

      scancel -f ${SLURM_JOB_ID}

END
```

The final section of the batch script finishes setup for RStudio and runs it using the `rserver` command.

```text
# Create custom database config
DBCONF=$TMPDIR/database.conf
if [ ! -e $DBCONF ]
then
printf "\nNOTE: creating $DBCONF database config file.\n\n"
echo "directory=$TMPDIR/var-rstudio-server" > $DBCONF
fi

rserver --server-user ${USER} --www-port ${PORT} --server-data-dir $TMPDIR/data-rstudio-server \
--secure-cookie-key-file $TMPDIR/data-rstudio-server/secure-cookie-key \
--database-config-file=$DBCONF --auth-none=0 \
--auth-pam-helper-path=pam-env-helper

printf 'RStudio Server exited' 1>&2
```

Submit the script using `sbatch`, wait for the job to start (use `squeue --me` to check the status of your jobs),
and check the output file for connection information:

```text
k1234567@erc-hpc-login2:~$ sbatch rstudio.sh
Submitted batch job 15244802
k1234567@erc-hpc-login2:~$ cat slurm-15244802.out
1. SSH tunnel from your workstation using the following command:

   Linux and MacOS:
   ssh -NL 8787:erc-hpc-comp015:53723 k1234567@hpc.create.kcl.ac.uk

   Windows:
   ssh -m hmac-sha2-512 -NL 8787:erc-hpc-comp015:53723 k1234567@hpc.create.kcl.ac.uk

   and point your web browser to http://localhost:8787

2. Login to RStudio Server using the following credentials:

   user: k1234567
   password: WYk6MgV9DUkv0/UewDp3

When done using the RStudio Server, terminate the job by:

1. Exit the RStudio Session ("power" button in the top right corner of the RStudio window)
2. Issue the following command on the login node:

      scancel -f 15244802

NOTE: creating /tmp/database.conf database config file.
```

On your laptop or desktop, start a new terminal session and run the ssh command given in your job's output,
e.g. `ssh -NL 8787:erc-hpc-comp015:53723 k1234567@hpc.create.kcl.ac.uk`.

!!!tip
    This will produce a message saying you may need to visit the e-Research Portal to authorise
    your SSH connection, but then no further output, even if successful. This is expected!

Then in your web browser go to [http://localhost:8787](http://localhost:8787).
You should see an RStudio login page. Log in with your k-number and the password given in your job's
output, and you should see an RStudio window.

When you're finished working, close the RStudio session by clicking the power button in the top right corner,
use `Ctrl+C` to close the SSH tunnel,
then on the HPC run `scancel -f <your job id>`, as given in the output file of your job, to cancel the
job's allocation and free up the resources.
