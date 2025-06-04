# Singularity

Containers have become popular in the last decade and continue doing so. They provide a method to package an application so it can be run, with its dependencies, isolated from other processes and independent from the host environemnt. In a nutshell they are encapsulations of application, or system environments.

Singuarity is a container technology which has been popular in HPC environments due to its security model (no root on the host, no root inside the container).
You can find out more information about Singularity [here](https://sylabs.io/singularity/).

!!! Info
    Singularity is only available on the compute nodes.
    You will not be able to run these commands on the login nodes, so for this section you should start an interactive job using:

    ```
    srun --partition cpu --reservation cpu_introduction --pty /bin/bash
    ```

Singularity is already on the path and you will be able to pull the prebuilt/3rd party containers from Docker/Singularity hubs using

```bash
k1234567@erc-hpc-login1:~$ singularity pull docker://sylabsio/lolcow
```

```text
INFO:    Converting OCI blobs to SIF format
INFO:    Starting build...
Getting image source signatures
Copying blob 16ec32c2132b done  
Copying blob 5ca731fc36c2 done  
Copying config fd0daa4d89 done  
Writing manifest to image destination
Storing signatures
2023/11/09 20:14:31  info unpack layer: sha256:16ec32c2132b43494832a05f2b02f7a822479f8250c173d0ab27b3de78b2f058
2023/11/09 20:14:32  info unpack layer: sha256:5ca731fc36c28789c5ddc3216563e8bfca2ab3ea10347e07554ebba1c953242e
INFO:    Creating SIF file...
```

and execute/run them once they have been downloaded and stored on the filesystem

```bash
k1234567@erc-hpc-login1:~$ singularity run lolcow_latest.sif
```

```text
INFO:    Converting SIF file to temporary sandbox...
WARNING: underlay of /etc/localtime required more than 50 (77) bind mounts
 _____________________________
< Thu Nov 9 20:15:06 GMT 2023 >
 -----------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
INFO:    Cleaning up image...
```

Generally, the `run` command will run a default script (also known as an entrypoint) that has been defined within the container. If you want to execute a specific command within the container you can do so using the `exec` option

```bash
k1234567@erc-hpc-login1:~$ singularity exec lolcow_latest.sif cowsay "Hello World"
```

```text
INFO:    Converting SIF file to temporary sandbox...
WARNING: underlay of /etc/localtime required more than 50 (77) bind mounts
 _____________
< Hello World >
 -------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
INFO:    Cleaning up image...
```

You can also build the containers yourself, but for the moment you will have to perform the building outside CREATE environment.
Once built, you can copy them over and use them without any issues.

!!! Warning
    Using third party containers is a great way to get started, but you need to make sure that the container is behaving as expected before using it in your work.

## Exercises

Work through the exercises [here](exercises.md/#using-modules) to test your understanding of how to use Singularity on CREATE HPC.
