# Basic Unix Commands

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
