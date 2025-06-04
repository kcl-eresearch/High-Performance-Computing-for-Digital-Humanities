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

## Requesting access to CREATE HPC

In order to access CREATE your KCL account first needs to be authorised.
To request authorisation to the HPC system, you should email [support@er.kcl.ac.uk](mailto:support@er.kcl.ac.uk) with your k-number and a brief description of the work you're planning to do.

To help speed up our training, you have been given temporary access, but to use CREATE in your own research outside this training, you will still need to request authorisation.

## Creating an SSH key

To login to CREATE, we'll need to use an **SSH key**.
SSH keys are a widely used method for securely accessing remote machines, which if configured correctly provide better security than a username and password.

To create an SSH key we use `ssh-keygen` - when it prompts us for a passphrase, this is the passphrase/password which will be used to secure your key.

```bash
ssh-keygen
```

```text
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in ~/.ssh/id_rsa
Your public key has been saved in ~/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:mgjcz9Wz/9geaYgQtcg4eJCtrAsgJFobmX+26ZeqqmM
The key's randomart image is:
+---[RSA 3072]----+
|   o.o    .      |
|..= .o.o o .     |
|+. =..+ + .      |
|+...+.o. o       |
|o o..o oS o      |
|. .. +o+ . + . . |
| . ...=  .o . +  |
|.E.   . o  . + . |
|oo.....o    oo+  |
+----[SHA256]-----+
```

As you can see in the output of `ssh-keygen`, our SSH key is composed of two parts: the identification or **private key** and the **public key**.
Your private key is the part which proves your identity and should never be shared with anyone else.
Your public key is the part which a machine or service uses to say that you are authorised to access it

## Connecting to CREATE HPC

Once your account has been created and you have uploaded your ssh key to the [e-research portal](https://portal.er.kcl.ac.uk/)
you should be able to connect to the login nodes using the following command, replacing `k1234567` with your own k-number:

```bash
ssh k1234567@hpc.create.kcl.ac.uk
```

You should see something similar to

```text
█████████████████████████████████
█████████████████████████████████
████ ▄▄▄▄▄ █▀▄▀▄█ ▀▀██ ▄▄▄▄▄ ████
████ █   █ █▀▄▀▀▀▀▀▀▀█ █   █ ████
████ █▄▄▄█ █▀ █▄█ █▀ █ █▄▄▄█ ████
████▄▄▄▄▄▄▄█▄▀ ▀▄█ ▀ █▄▄▄▄▄▄▄████
████▄▄▄ ▄█▄  ██  ▄▄▄▀▄█ █▄█ █████
████▀▄▀▀█▀▄██▀ ▀▀▄▀▄▀ ███▄█▄ ████
████▀▄▄▀█▄▄▀█▄█ ▄ ▄██ ▄ ▄▀▄ ▄████
████ █  ▄█▄▄▄█▄███▄ ▀█▄  ▄█▄ ████
████▄█▄█▄█▄█ ▄▀▀█ █▀ ▄▄▄ ▀▄██████
████ ▄▄▄▄▄ █▄█▄▀▄▄▄█ █▄█ ▀▄▄ ████
████ █   █ █ █▄  ▄▄▄▄  ▄ ▀ █▄████
████ █▄▄▄█ █  ▀▀▀█▀ ▀ ▀▀▀ ▄█ ████
████▄▄▄▄▄▄▄█▄▄▄█▄▄▄███▄▄▄▄▄▄▄████
█████████████████████████████████
█████████████████████████████████

You may need to authenticate your SSH access by visiting the e-Research Portal:

https://portal.er.kcl.ac.uk/mfa/
```

And will need to approve the connection by following the link at the bottom.

Once approved, upon successful connection you should see something similar to

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

Please see [here](https://docs.er.kcl.ac.uk/CREATE/access/#accessing-create-hpc) for more
detailed information.

Although we prefer and encourage the use of command line ssh utilities, there are a number of GUI ssh clients
(mainly for Windows users) that could be used for the ssh connectivity:

- PuTTY
- MobaXterm

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

## Basic Unix Commands

Unix is the name of a family of operating systems (OS) that support multi-tasking and multiple users. Unix commands allow you to interact with the OS and applications on it. Sometimes a Unix like operating system is deployed without a graphical user interface (GUI). Therefore, the only way to interact with the OS is through commandline. Furthermore, some applications do not have a GUI and can only be invoked through the command line.

Below is a list of basic commands and an explanation for each command. Please note that some of these commands require one or more arguments while others do not need any.  

Some commands can change behaviour or output based on switches provided. A switch is usually a letter or a word preceded by a **-** dash or two dashes **--** respectively.

- cd
    - Changes the current directory that you are in.
    - Examples:
        - `cd dir1` *# changes current directory to dir1*
        - `cd`  *# changes current directory to your home directory*
    - Notes:
        - Please see the notes on relative and absolute paths below.
- pwd
    - Prints the current directory you are in.
- mkdir
    - Creates a new directory
    - Examples:
        - `mkdir test_dir` *# Creates a directory with test_dir as its name*
- mv
    - Moves file(s) or directories from a source path to a destination path.
    - Examples:
        - `mv test_file test_dir/` *# Moves test_file to test_dir*
- cp
    - Copies file(s) from a source path to a destination path.
    - Examples:
        - `cp test_file test_dir/` *# Copies test_file to test_dir*
- rm
    - Removes file(s).
    - Examples:
        - `rm test_file` *# Removes test_file if it exists*
- rmdir
    - Removes directory
    - Examples:
        - `rm test_dir` *# Removes test_dir if it exists and is empty*
- tail
    - Shows the last 10 lines from any text file.
    - Examples:
        - `tail some_file.txt` *# Shows the last 10 lines of some_file.txt*
        - `tail -f some_file.txt` *# Shows the last 10 lines of some_file.txt and keeps track of changes*

- ls
    - Lists the contents of the current directory.
    - Examples:
        - `ls -l` *# Lists the contents of current directory in long format*
        - `ls -a` *# Lists the contents of current directory including hidden files.*
- whoami
    - Prints your username.
- history
    - Prints a list of commands executed by you.
- groups
    - Prints the list of groups your user is a member of.
- clear
    - Clears command line screen, useful when logs or warnings have filled up the screen.
- last
    - Prints a history of logins to the system.
- ps
    - Prints a list of existing processes of current user.
- top
    - Shows a live list of tasks and resource usage.
- man
    - Shows the manual of a specific command.
    - Examples:
        - `man tail` *# Shows the manual for command tail*

### Notes on Relative and Absolute Paths in Unix

- Some Unix commands accept paths as arguments. Paths can be defined as Relative or Absolute. Absolute paths start from the root of the file system with a forward slash **/** .Relative paths use the current working directory as a refrence and navigate the path from there. For instance, if you are in your home directory and wish to navigate to a directory called _test_dir_ (which is in your home directory), you can use the `cd test_dir` command.  

- If you are in your home directory and wish to navigate to a directory that is not present there, you can use **../** (two full-stops followed by a forward slash) in the path to go one level up. For instance `cd ../some_dir/` would take you one level up from where you are. You can use as many **../** as the number of levels you need to go up in a relative path.

For example, if you are in a directory called `some_dir/` inside your home directory:

```text
/users/k1234567
├── some_dir/            <-- current location
│   ├── nested_dir/
│   └── myfile.txt
└── test_dir/
```

`cd nested_dir` will take you into `nested_dir/`.

```text
/users/k1234567
├── some_dir/
│   ├── nested_dir/      <-- current location
│   └── myfile.txt
└── test_dir/
```

From there, `cd ..` will take you back to `some_dir/`.
The command `cd ../../test_dir` will take you straight from `nested_dir/` to the `test_dir/` directory that is inside your home directory without any intermediate steps.

```text
/users/k1234567
├── some_dir/
│   ├── nested_dir/
│   └── myfile.txt
└── test_dir/            <-- current location
```

You could also move to these directories by using their absolute paths, e.g. `cd /users/k1234567/test_dir/`.

## Exercises

Work through the exercises in [this section](exercises.md/#navigating-create-hpc).
