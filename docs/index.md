# High performance computing with CREATE

This workshop is an introduction to High-Performance Computing (HPC), In what situations you may want to use a HPC, the benefits of utilising a HPC along with some of the history and theoretical understanding necessary to be able visualise and effectively troubleshoot issues.

By the end of the workshop you should be able to:

* Use modules to find and load the necessary software
* Use Python virtual environments
* Use Singularity containers
* Use scheduler commands to submit jobs and find out information about them
* Submit different types of jobs

## A brief history of HPC and computing.

### What is a computer?

A computer is a machine that can be programmed to carry out a set of instructions. The first computers were mechanical devices, such as the abacus, which could perform basic arithmetic operations. The first electronic computers were developed in the 1940s and 1950s, and were used primarily for scientific and military applications. 

Before the development of electronic computers, people used mechanical devices to perform calculations, such as the slide rule and the mechanical calculator. One example of this would be our 'human computer' Katherine Johnson, who manually calculated the trajectory of early space flights. Later, she would go on to manually check the results of the first computers to ensure their accuracy. 

The first electronic computers were large, expensive, and difficult to use, and were primarily used by governments and large corporations. Over time, computers have become smaller, faster, and more powerful, and are now used in a wide variety of applications, from personal computing to large-scale data processing. Almost all of modern research now depends on computers in some way, whether it is for data analysis, simulation, or visualization. This has led to the development of High-Performance Computing (HPC) systems, which are designed to handle large-scale computations and data processing tasks.

### What can a computer do?

A computer can perform a wide variety of tasks, including:
* Performing calculations and data processing tasks quickly and accurately
* Storing and retrieving large amounts of data
* Running complex simulations and models
* Analyzing and visualizing data
* Automating repetitive tasks

### What a computer cannot do?

* Know what you actually wanted it to do
* Work without instructions
* Understand the context of the data it is processing

Ultimately, a computer is a tool that can be used to perform tasks, but it is not capable of independent thought or decision-making. It relies on humans to provide it with the necessary instructions and context to carry out its tasks effectively. AI and machine learning are changing this, but they are still limited by the data they are trained on and the algorithms that power them and do not have the same level of understanding or context as a human.

## What are the components of a computer and what do they do?

A computer is made up of several key components, each of which plays a specific role in the overall functioning of the machine. The main components of a computer include:
* **Central Processing Unit (CPU)**: The CPU is the brain of the computer, responsible for executing instructions and performing calculations. It processes data and controls the other components of the computer.
* **Memory (RAM)**: Random Access Memory (RAM) is the computer's short-term memory, used to store data and instructions that are currently being used by the CPU. It allows the computer to access data quickly and efficiently. This storage is volatile, meaning that it is cleared when the computer is turned off.
* **Motherboard**: The motherboard is the main circuit board of the computer, connecting all of the components together. It provides the necessary connections for the CPU, memory, storage, and other components to communicate with each other.
* **Storage**: Storage is the computer's long-term memory, used to store data and programs that are not currently being used by the CPU. This can include hard drives, solid-state drives, and other types of storage media.
* **Graphics Processing Unit (GPU)**: The GPU is a specialized processor designed to handle complex graphics and image processing tasks. It is often used in scientific research applications, AI model training, video editing, and other applications that can leverage the parallel processing capabilities of the GPU.
* **Network Interface Card (NIC)**: The NIC is responsible for connecting the computer to a network, allowing it to communicate with other computers and devices. This can include wired connections (such as Ethernet) or wireless connections (such as Wi-Fi).

### When would you want to use a CPU vs a GPU?
In general, you would want to use a CPU for tasks that require complex logic and decision-making, such as running simulations or processing large datasets. A CPU is designed to handle a wide variety of tasks and can perform complex calculations quickly and accurately.
A GPU, on the other hand, is designed to handle tasks that can be parallelized, such as rendering graphics or training machine learning models. A GPU can perform many calculations simultaneously, making it well-suited for tasks that require a large amount of data processing. This is because a GPU has many more cores than a CPU and, although simpler, allow it to perform many calculations in parallel.

## What is a High-Performance Computing (HPC) system and what makes it different from a regular computer?

A HPC system is a collection of computers that work together to perform complex calculations and data processing tasks. These systems are designed to handle large-scale computations and data processing tasks, and are typically used in scientific research, engineering, and other fields that require high-performance computing capabilities. HPC systems are typically composed of many individual computers, which are connected together through a high-speed network. These computers work together to perform calculations and process data, allowing researchers to tackle complex problems that would be impossible to solve on a single computer.

At a very high level, those computers can be divided into the following categories:

* Login nodes
* Compute nodes
* Storage nodes
* Management nodes

!!! Important
    As a user, you are unlikely to interact with the management nodes, and you will not have access to the storage nodes directly. You will primarily interact with the login nodes and compute nodes.

![Compute node diagram](images/node_diagram_two.png)

## What is Parallel Computing?
Parallel computing is a type of computing in which multiple processors or computers work together to perform a task. This allows for faster processing times and the ability to handle larger datasets than would be possible with a single processor or computer. In parallel computing, a task is divided into smaller sub-tasks, which are then distributed across multiple processors or computers. Each processor or computer works on its own sub-task simultaneously, allowing the overall task to be completed more quickly.

!!! Note
    It is not in the scope of this training to teach you how to write parallel code, but it is important to understand the concept of parallel computing and how to operate other people's code in a parallel environment.

## Why do we need parallel computing?
Parallel computing is necessary because many tasks in scientific research and data processing are too complex or time-consuming to be completed on a single processor or computer. By using parallel computing, researchers can take advantage of the processing power of multiple processors or computers to complete tasks more quickly and efficiently. This allows them to tackle larger problems and analyze larger datasets than would be possible with a single processor or computer. For the environmentally conscious researcher, parallel computing can also help to reduce the carbon footprint of research by allowing tasks to be completed more quickly and efficiently, reducing the overall energy consumption of the research process.

## What workflows benefit from parallel computing?
Parallel computing is particularly beneficial for workflows that involve large datasets or complex calculations. Some examples of workflows that can benefit from parallel computing include:
* Scientific simulations: Many scientific simulations involve complex calculations that can be parallelized, allowing them to be run more quickly and efficiently.
* Data analysis: Large datasets can be processed more quickly using parallel computing, allowing researchers to extract insights and patterns from the data more efficiently.
* Machine learning: Training machine learning models often involves processing large datasets and performing complex calculations, which can be accelerated using parallel computing.

## What is a scheduler and why do we need one?
A scheduler is a software tool that manages the allocation of resources in a HPC system. It is responsible for scheduling jobs to run on the compute nodes, ensuring that resources are used efficiently and that jobs are completed in a timely manner. The scheduler is also responsible for managing the queue of jobs, prioritizing them based on their resource requirements and other factors. For the training workshop, we will be using the Slurm scheduler, which is a widely used open-source job scheduler for HPC systems.

## What is a job and what is a job script?
A job is a unit of work that is submitted to the scheduler for execution on the compute nodes. A job can be a single command or a script that contains multiple commands. A job script is a file that contains the commands to be executed, along with any necessary configuration options and resource requirements. The job script is submitted to the scheduler, which then allocates the necessary resources and executes the job on the compute nodes.

## What is a module and why do we need one?
A module is a software tool that allows users to manage the software environment on a HPC system. It provides a way to load and unload software packages, set environment variables, and manage dependencies between different software packages. Modules are used to ensure that the correct versions of software packages are used for a particular job, and to avoid conflicts between different software packages. In the context of this training workshop, we will be using modules to load the necessary software packages for our jobs. On CREATE, we use spack to manage our software environment, which allows us to easily install and manage software packages and their dependencies.

## What is a Singularity container and why do we need one?
A Singularity container is a lightweight, portable, and reproducible software environment that can be used to run applications on a HPC system. It allows users to package their applications and all of their dependencies into a single container, which can then be run on any HPC system that supports Singularity. This makes it easy to share applications and ensure that they run consistently across different systems. Singularity containers are particularly useful for running applications that have complex dependencies or require specific versions of software packages.

## What is a Python virtual environment and why do we need one?
A Python virtual environment is a self-contained directory that contains a Python installation and all of the necessary packages and dependencies for a particular project. It allows users to create isolated environments for their Python projects, ensuring that the correct versions of packages are used and avoiding conflicts between different projects. Virtual environments are particularly useful for managing dependencies in Python projects, as they allow users to easily install and manage packages without affecting the global Python installation.


## References

The material in this course was inspired by / based on the following resources

* [CREATE documentation](https://docs.er.kcl.ac.uk/)
* [EPCC Introduction to High-Performance Computing](https://epcced.github.io/hpc-intro/)
* [A previous iteration of this course developed at Maudsley BRC](https://github.kcl.ac.uk/pages/maudsley-brc-cti/drive-health-hpc-training/)
