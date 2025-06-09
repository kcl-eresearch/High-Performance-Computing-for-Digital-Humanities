# Before we begin
  
## Introduction to the terminal

Throughout this training we'll be interacting with CREATE via a **terminal** or **command line**.
This means we'll be providing our instructions and receiving responses in text form.
There's a few important commands we'll cover gradually as we need them.

Why text instead of a graphical interface?
Text-based interfaces were naturally the default before graphical interfaces became widely available, but even now they remain the most common way to interact with remote HPC systems.
There are several advantages which a text-based interface gets us:

- They're precise - by using a well established set of commands it's clear what we mean
- They're repeatable - since our commands are just text, they can be easily saved, shared and run as automated scripts
- They're low-bandwidth - by using text instead of graphics, we're not taking up network bandwidth that could be better used for moving data around

Depending on your operating system there are a number of terminal applications available which we would recommend:

- Windows: PowerShell - note that this uses a different command syntax, but once we're logged into CREATE this won't matter
- MacOS: Terminal
- Linux: The name of your terminal application may vary, but it's usually called something like "Terminal"

You should be familiar with basic terminal commands before participating in this workshop.
However, we have created a list of [common commands](./unix_commands.md) you can use as a reference sheet.

## Connecting to CREATE HPC

You should have been provided with a guest username and password which you can use to log in to CREATE HPC.
King's staff and students use their King's user id, or "k-number" to connect, so the example username we will use in this workshop is `k1234567`.
You can connect to the login nodes using the following command, replacing `k1234567` with your guest username:

```bash
ssh k1234567@hpc.create.kcl.ac.uk
```

You will be prompted to enter your password:

```bash
$ ssh k1234567@hpc.create.kcl.ac.uk
k1234567@hpc.create.kcl.ac.uk's password: 
```

Type your password then press 'Enter'.
You will not see any indication that your password has been typed in - this is normal!
If the password is incorrect you will be prompted to retype it.

Upon successful connection you should see something similar to

```text
==================================================================
King's College London | e-Research
------------------------------------------------------------------

Welcome to erc-hpc-login1.create.kcl.ac.uk


This machine is part of

 ██████╗██████╗ ███████╗ █████╗ ████████╗███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔════╝
██║     ██████╔╝█████╗  ███████║   ██║   █████╗
██║     ██╔══██╗██╔══╝  ██╔══██║   ██║   ██╔══╝
╚██████╗██║  ██║███████╗██║  ██║   ██║   ███████╗
 ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝

------------------------------------------------------------------
This machine is automatically updated on the 5th of each month
at 03:47 BST. It may reboot shortly thereafter.
------------------------------------------------------------------

Documentation: https://docs.er.kcl.ac.uk/

Please contact e-research@kcl.ac.uk for support.
...
Only files stored within /rds and /users are backed up.

Please remember to acknowledge CREATE in your research outputs:
  https://docs.er.kcl.ac.uk/CREATE/acknowledging/

==================================================================
k1234567@erc-hpc-login1:~$
```

## The environment

- Ubuntu 22.04 LTS Linux operating system with the Bash shell
- Directories/locations of interest
    - Home directory located in `/users/k-number`
    - Personal scratch space located in `/scratch/users/k-number`
    - Group scratch space located in `/scratch/grp/group-name`
    - Project space located in `/scratch/prj/prj-name`
    - RDS space located in `/rds/prj-name`
    - Datasets space located in `/datasets/dataset-name`

Most of these directories will be useful to you at some point over the course of your research, so we'll briefly introduce each in turn.
For more information, see our [storage docs](https://docs.er.kcl.ac.uk/CREATE/storage/).

**Home directory:** `/users/k-number`.
Your home directory is the directory you see when you log in to CREATE.
This is a good place to put any code you write or other custom software, configuration files and small amounts of data.
This directory is only accessible by you by default - other users can't access files in your home directory unless you specifically allow them to.
You will typically be allocated 50GiB for your home directory.

**Personal scratch:** `/scratch/users/k-number`.
Your personal scratch space is where you should store the input and output data for your active research.
Scratch space is designed to provide much higher performance which is important for many HPC jobs and has a much higher capacity and personal allocation.
Your personal scratch space can only be accessed by you by default - just like your home directory.
You will typically be allocated 200GiB for your personal scratch, but may request more if necessary.

**Group scratch:** `/scratch/grp/group-name` and **Project scratch:** `/scratch/prj/prj-name`.
Group or project scratch space is similar to your personal scratch space but as the name suggests is shared by a group or a project.
Every member of the group or project will be able to access the files stored in this space.
Projects are initially allocated 1TiB, but may request more space if necessary at a cost of £50 per TiB.
Researchers may request that a project be created in CREATE for their work by emailing [e-research@kcl.ac.uk](mailto:e-research@kcl.ac.uk).

**Research Data Store (RDS):** `/rds/prj-name`.

The Research Data Store is our large-scale storage facility for live research data.
This is suitable for the largest datasets used by projects and where it's important that the data be properly backed up.

!!! Important
    The only data storage locations that are backed up are your home directory (`/users/k-number`) and RDS projects (`/rds/prj-name`). Data stored in scratch is *not* backed up, so make sure you copy any important results or code to RDS or another location that is backed up.
