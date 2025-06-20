# Accessing software

HPC systems tend to provide software packages for the users. The number can be quite large and
the software varied, especially on clusters where users come from different research backgrounds, such as bioinformatics, computer science, etc.

By default no software is preloaded and to use any of the software packages available one must _load_ them explicitly. This is driven
by the challenges presented by

* multiple versions
* dependencies
* incompatibilities between different versions and packages

!!! info
    On CREATE HPC, [spack](https://spack.readthedocs.io/en/latest/) is used to install and manage the software on the platform.

## Environment Modules

Environment modules provide a way for a dynamic modification of a user's environment and address some of the challenges listed above.
They are very useful in managing large numbers of applications and help to control multiple versions and the dependencies present.

Each modulefile contains information needed to set up your environment for the application.
In most cases it will alter, or define shell variables such as `PATH`, `LD_LIBRARY_PATH`, etc.

If there are specific dependencies, the modules will define and load them accordingly. For example, if a package relies on
a specific compiler, the module file will load that compiler for you.

To list available modules on the system use `module avail`. After you run it you should see something similar to the following output:

```text
k1234567@erc-hpc-login1:~$ module avail

----------------------------------------------------------------------------- /software/spackages_prod/modules/linux-ubuntu20.04-zen2 -----------------------------------------------------------------------------
   alsa-lib/1.2.3.2-gcc-9.4.0                                                 perl-extutils-config/0.008-gcc-9.4.0
   amdblis/3.0-gcc-9.4.0-python-3.8.12                                        perl-extutils-helpers/0.026-gcc-9.4.0
   amdfftw/3.0-gcc-9.4.0-openmpi-4.1.1-python-3.8.12                          perl-extutils-installpaths/0.012-gcc-9.4.0
   amdlibflame/3.0-gcc-9.4.0-python-3.8.12                                    perl-extutils-makemaker/7.24-gcc-9.4.0
   anaconda3/2021.05-gcc-9.4.0                                                perl-extutils-pkgconfig/1.16-gcc-9.4.0
   ant/1.10.7-gcc-9.4.0                                                       perl-file-listing/6.04-gcc-9.4.0
   autoconf-archive/2019.01.06-gcc-9.4.0                                      perl-font-ttf/1.06-gcc-9.4.0
   autoconf/2.69-gcc-9.4.0                                                    perl-gd/2.53-gcc-9.4.0-python-3.8.12
   automake/1.16.3-gcc-9.4.0                                                  perl-html-parser/3.72-gcc-9.4.0
   bazel/3.7.2-gcc-9.4.0-python-3.8.12                                        perl-html-tagset/3.20-gcc-9.4.0
   bcftools/1.12-gcc-9.4.0-python-3.8.12                                      perl-http-cookies/6.04-gcc-9.4.0
   bdftopcf/1.0.5-gcc-9.4.0                                                   perl-http-daemon/6.01-gcc-9.4.0
   bedtools2/2.23.0-gcc-9.4.0-python-3.8.12                                   perl-http-date/6.02-gcc-9.4.0
   berkeley-db/18.1.40-gcc-9.4.0                                              perl-http-message/6.13-gcc-9.4.0
   binutils/2.37-gcc-9.4.0                                                    perl-http-negotiate/6.01-gcc-9.4.0
   bismark/0.23.0-gcc-9.4.0-python-3.8.12                                     perl-io-html/1.001-gcc-9.4.0
...
```

!!! info
    The version numbers you see might differ from the example shown here due to module updates since this training was written.

You can run the above command yourself to see the full list.
Use the arrow keys to scroll up and down the list, and `q` to go back to the command line when you're done.

If you know the name, or parts of the name of the package that you want to use, you can search for it using `module spider`, e.g.

```text
module spider python

--------------------------------------------------------------------------------------------------------------------------------------------------
  python:
--------------------------------------------------------------------------------------------------------------------------------------------------
     Versions:
        python/3.11.6-gcc-11.4.0
        python/3.11.6-gcc-12.3.0
        python/3.11.6-gcc-13.2.0
     Other possible modules matches:
        py-meson-python  py-mysql-connector-python  py-python-dateutil

--------------------------------------------------------------------------------------------------------------------------------------------------
  To find other possible module matches execute:

      $ module -r spider '.*python.*'

--------------------------------------------------------------------------------------------------------------------------------------------------
  For detailed information about a specific "python" package (including how to load the modules) use the module's full name.
  Note that names that have a trailing (E) are extensions provided by other modules.
  For example:

     $ module spider python/3.11.6-gcc-13.2.0
--------------------------------------------------------------------------------------------------------------------------------------------------
```

To load a module use `module load` command

```bash
module load python/3.11.6-gcc-13.2.0
```

The above command loads a specific version of the application/module. If the explicit version is omitted during the `module load` request,
i.e. `module load python`, the default version of the package will be loaded.
The default version is marked by `D` (for default) in the output of `module avail`.
It is better to load a specific version of the module rather than relying on the default versioning to avoid issues when the default version changes.

!!! tip
    You might see different module versions that provide the same version of the application, but with
    different dependency versions, e.g. different versions of gcc. This is helpful for compatibility with
    other software that requires a specific gcc version.

To list currently loaded modules use `module list`

```text
module list

Currently Loaded Modules:
  1) bzip2/1.0.8-gcc-13.2.0     7) gdbm/1.23-gcc-13.2.0       13) zstd/1.5.5-gcc-13.2.0                     19) sqlite/3.43.2-gcc-13.2.0
  2) libmd/1.0.4-gcc-13.2.0     8) libiconv/1.17-gcc-13.2.0   14) tar/1.34-gcc-13.2.0                       20) util-linux-uuid/2.38.1-gcc-13.2.0
  3) libbsd/0.11.7-gcc-13.2.0   9) xz/5.4.1-gcc-13.2.0        15) gettext/0.22.3-gcc-13.2.0-libxml2-2.10.3  21) python/3.11.6-gcc-13.2.0
  4) expat/2.5.0-gcc-13.2.0    10) zlib-ng/2.1.4-gcc-13.2.0   16) libffi/3.4.4-gcc-13.2.0
  5) ncurses/6.4-gcc-13.2.0    11) libxml2/2.10.3-gcc-13.2.0  17) libxcrypt/4.4.35-gcc-13.2.0
  6) readline/8.2-gcc-13.2.0   12) pigz/2.7-gcc-13.2.0        18) openssl/3.1.3-gcc-13.2.0
```

!!! important
    Although you can load the modules on the login nodes and they will be propagated to the scheduled jobs, you __should__ load them in your job script as some of the
    software is optimised for specific processor architectures. You will also avoid conflicts and missing modules (in case you forget to load them before submitting the job).

To remove, or unload a specific module use `module rm`

```bash
module rm python/3.11.6-gcc-13.2.0
```

This will also unload any dependent modules required by the module you are unloading.

!!! tip
    To remove __all__ loaded modules use `module purge`.

To find out more information about the module, use `module whatis`

```bash
module whatis python/3.11.6-gcc-13.2.0
```

You should see information about the module

```text
python/3.11.6-gcc-13.2.0                       : The Python programming language.
```

## Exercises - modules

To test your understanding of how to access software using modules, work through the exercises in [this section](exercises.md/#using-modules).

## Installing your own software

Although it's likely that many software packages are pre-installed on any HPC cluster, there is a chance that the package that you want to use
is not installed and cannot be accessed as a module.

You can of course build, or install your own packages. As you do not have root (administrative rights) on the nodes you won't be able to install them
into system locations, or use system package managers (`apt`, `dpkg`) to perform the installations.
You can however install into your own personal location, or the group shares - in essence anywhere you can write to. Build systems such
as `cmake` or `automake` will have appropriate switches to define custom installation locations.

Building and installing software can become complex, and is beyond the scope of this workshop.
However, we will discuss a few other approaches to accessing software that you might find useful:
Python virtual environments, Conda, and [Singularity](singularity.md).

Python virtual environments and Conda/Anaconda provide a way to extend functionality of an existing python installation and create isolated environments
that can be used to install, or upgrade specific packages.
Singularity is a tool for running [software containers](https://en.wikipedia.org/wiki/Containerization_(computing)).

### Python virtual environments

To create a Python virtual environment load the relevant python module and then execute `python3 -m venv envname` command replacing `envname` with the name
of the environment you want to create:

```text
k1234567@erc-hpc-login1:~$ module load python/3.11.6-gcc-13.2.0
k1234567@erc-hpc-login1:~$ python3 -m venv myenv
```

With this, Python has created the `myenv` directory which now contains the required base files.

!!! tip
    You can also specify the absolute/relative path to the environment if you do not want it created in the current directory.

You only need to create the environment once. Once it has been created you do not need to run the command again (unless you need deleted the current one, or wish to create another one).

To use the environment you have to activate it first by sourcing the activate script

```text
k1234567@erc-hpc-login1:~$ source myenv/bin/activate
(myenv) k1234567@erc-hpc-login1:~$
```

!!! important
    When activating the virtual environment you can use relative paths, but the activation has to be initiated from the right directory.
    Using full (absolute) path might be the safer alternative.

The name of the venv should be prepended to your prompt indicating that the environment is active. From now on you can use the environment:

* to install packages

    ```text
    (myenv) k1234567@erc-hpc-login2:~$ pip install pytest
    Collecting pytest
      Downloading pytest-7.3.2-py3-none-any.whl (320 kB)
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 320.9/320.9 kB 12.8 MB/s eta 0:00:00
    Collecting tomli>=1.0.0
      Downloading tomli-2.0.1-py3-none-any.whl (12 kB)
    Collecting packaging
      Downloading packaging-23.1-py3-none-any.whl (48 kB)
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 48.9/48.9 kB 2.5 MB/s eta 0:00:00
    Collecting iniconfig
      Downloading iniconfig-2.0.0-py3-none-any.whl (5.9 kB)
    Collecting exceptiongroup>=1.0.0rc8
      Downloading exceptiongroup-1.1.1-py3-none-any.whl (14 kB)
    Collecting pluggy<2.0,>=0.12
      Downloading pluggy-1.0.0-py2.py3-none-any.whl (13 kB)
    Installing collected packages: tomli, pluggy, packaging, iniconfig, exceptiongroup, pytest
    Successfully installed exceptiongroup-1.1.1 iniconfig-2.0.0 packaging-23.1 pluggy-1.0.0 pytest-7.3.2 tomli-2.0.1

    [notice] A new release of pip available: 22.3.1 -> 23.1.2
    [notice] To update, run: pip install --upgrade pip
    ```

* or to run python scripts

    ```text
    (myenv) k1234567@erc-hpc-login1:~$ python /datasets/hpc_training/utils/helloworld.py
    Hello World!
    ```

To deactivate the environment use `deactivate` command

```text
(myenv) k1234567@erc-hpc-login1:~$ deactivate
k1234567@erc-hpc-login1:~$
```

You will see that the environment name has disappeared from the shell prompt.

??? note "Conda virtual environments"
    Conda is another tool for creating virtual environments.
    On CREATE, Conda is available via the `anaconda3` module.

    To use Conda, first load the module:

    ```text
    module load anaconda3/2022.10-gcc-13.2.0
    ```

    You can then create a virtual environment and specify the packages you want to install into that environment.
    For example, to create an environment with a specific version of Python:

    ```text
    conda create --name python39-env python=3.9
    ```

    The environment can be activated by running `conda activate` with the name of the env

    ```text
    k1234567@erc-hpc-login1:~$ conda activate python39-env
    (python39-env) k1234567@erc-hpc-login1:~$
    ```

    and deactivated by running `conda deactivate`

    ```text
    (python39-env) k1234567@erc-hpc-login1:~$ conda deactivate
    k1234567@erc-hpc-login1:~$
    ```

    As with Python virtualenvs, note that the name of the active Conda environment is prepended to your prompt when the environment is active.

    !!! tip
        To prevent activation of the Conda base environment by default, which may conflict with other modules/packages, run
        `conda config --set auto_activate_base false`

#### Exercises - virtual environments

To practice using Python virtual environments, work through the exercises in [this section](exercises.md/#python-virtual-environments).
