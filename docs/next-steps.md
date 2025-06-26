# Next steps

King's staff and students can request access to CREATE HPC as described [here](https://docs.er.kcl.ac.uk/CREATE/requesting_access/).

You may also want to [register a project](https://docs.er.kcl.ac.uk/CREATE/requesting_access/#project-registration).
This gives you a project-specific scratch space as well as the option to request [backed-up RDS storage](https://docs.er.kcl.ac.uk/research_data/rds/).
We encourage project registration as it helps us track the research impact of CREATE usage.

## Transferring files

One of the easiest and quickest ways to transfer files is using `scp` (secure copy).
Running `scp <source> <target>` on your local machine (i.e., laptop or desktop) allows you to copy files from a source on your local machine
to a target destination on the HPC storage, or from the HPC back to your local machine.
This is suitable for files up to 500GB.

It is **strongly** recommended that you use an `~/.ssh/config` file as outlined on the [Accessing CREATE](https://docs.er.kcl.ac.uk/CREATE/access/) page.

For MacOS/Linux, the config file should look like this, with `<your k-number>` replaced by your real k-number:

```text
Host create
    Hostname hpc.create.kcl.ac.uk
    User <your k-number>
    PubkeyAuthentication yes
    IdentityFile ~/.ssh/id_rsa
```

For Windows the config file should look like this, again with `<your k-number>` replaced by your real k-number:

```text
Host create
    Hostname hpc.create.kcl.ac.uk
    MACs hmac-sha2-512
    User <your k-number>
    PubkeyAuthentication yes
    IdentityFile ~/.ssh/id_rsa
```

Using the config file in this format means that to copy a file called `hello_world.sh` from your local machine to your home
directory on CREATE would be as simple as running the following command from your local machine in the same directory the file was in:

Linux and MacOS:

```bash
scp hello_world.sh create:/users/k1234567/hello_world.sh
```

Windows:

```bash
scp -o MACs=hmac-sha2-512 hello_world.sh create:/users/k1234567/hello_world.sh
```

To copy a file called `hello_er.out` from the your personal scratch space in `/scratch/users/` to the current working directory
on your local machine, you would run the following command on your local machine:

Linux and MacOS:

```bash
scp create:/scratch/users/k1234567/hello_er.out ./hello_er.out
```

Windows:

```bash
scp -o MACs=hmac-sha2-512 create:/scratch/users/k1234567/hello_er.out ./hello_er.out
```

!!!tip
    For other ways to transfer files to CREATE HPC, see the instructions [here](https://docs.er.kcl.ac.uk/CREATE/rsync_and_scp/).

## Getting help

If you're not sure how to do something on the HPC, first check the [docs](https://docs.er.kcl.ac.uk/) as many common tasks are already covered here. If you don't find the answer to your question there, you can ask a question on the e-Research support [forum](https://forum.er.kcl.ac.uk/) or search to see if someone else has already asked it. If you're still stuck, you can submit a ticket requesting help by emailing [support@er.kcl.ac.uk](mailto:support@er.kcl.ac.uk).
