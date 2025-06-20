# SSH keys

## What are SSH keys?

SSH keys are a widely used method for securely accessing remote machines, which if configured correctly provide better security than a username and password.
Many HPC systems require users to use SSH keys for secure access, rather than a username and password.

TODO: expand this section!

## Creating an SSH key

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
Your public key is the part which a machine or service uses to say that you are authorised to access it.

The next step is to provide your public key to the system you want to access.
For CREATE HPC, this is done by uploading it to the [e-Research Portal](https://portal.er.kcl.ac.uk/).
Other HPC systems will have their own ways of providing an SSH key.
The documentation or onboarding instructions for your system should tell you how to do this.
