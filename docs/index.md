# High performance computing with CREATE

This workshop is an introduction to using the CREATE High-Performance Computing (HPC) system and is intended to give a basic overview of the tools available and how to use them.

By the end of the workshop you should be able to:

* Use modules to find and load the necessary software
* Use Python virtual environments
* Use Singularity containers
* Use scheduler commands to submit jobs and find out information about them
* Submit different types of jobs

## What is an HPC system

An HPC system is a term that usually describes a clustered network of computers. The computers in a cluster typically share a common purpose, and are used to accomplish tasks that might otherwise be too big for any one computer. Those computers might share the same, or similar hardware specifications, are usually connected via high speed networks and are backed by a fast, network filesystems.

At a very high level, those computers can be divided into the following categories:

* Login nodes
* Compute nodes
* Storage nodes
* Management nodes

!!! Important
    Login nodes should only be used for submitting jobs and running simple tasks, such as editing of your job scripts, etc

![Compute node diagram](images/node_diagram_two.png)

## About CREATE

King's Computational Research, Engineering and Technology Environment ([CREATE](https://docs.er.kcl.ac.uk/#kings-create)) is a tightly integrated ecosystem of
research computing infrastructure hosted by [King’s College London](https://www.kcl.ac.uk).
It consists of:

* CREATE Cloud: A private cloud platform to provide flexible and scalable hosting environments, allowing researchers greater control over their own research computing resources using virtual machines
* CREATE HPC: A high performance compute cluster with CPU and GPU nodes, fast network interconnects and shared storage, for large scale simulations and data analytics
* CREATE RDS: A very large, highly resilient storage area for longer term curation of research data
* CREATE TRE: Tightly controlled project areas making use of Cloud and HPC resources to process sensitive datasets (e.g. clinical PIID) complying with NHS Digital audit standards (DSPT)
* CREATE Web: A self-service web hosting platform for static content (HTML/CSS/JS) and WordPress sites

!!! Important
    For research that has made use of CREATE, please see the [Acknowledging](https://docs.er.kcl.ac.uk/CREATE/acknowledging/) page.

## Prerequisites

In order to join this training workshop, you must have a terminal application installed on your computer.
If you use MacOS or Linux, you will have one available by default.
If you use Windows, you can use PowerShell - some commands will differ from those used on Mac/Linux.

If you are working through these materials on your own, outside a workshop, you will also need to request an account on the CREATE HPC system.
Information on how to request access can be found in our [documentation](https://docs.er.kcl.ac.uk/CREATE/requesting_access/)

## References

The material in this course was inspired by / based on the following resources

* [CREATE documentation](https://docs.er.kcl.ac.uk/)
* [EPCC Introduction to High-Performance Computing](https://epcced.github.io/hpc-intro/)
* [A previous iteration of this course developed at Maudsley BRC](https://github.kcl.ac.uk/pages/maudsley-brc-cti/drive-health-hpc-training/)
