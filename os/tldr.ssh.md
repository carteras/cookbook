# tldr: ssh

## Description

Opens a secure, encrypted shell session on a remote machine over the network. Once connected, you get a terminal on the remote machine as if you were sitting in front of it. The most common tool for managing servers remotely.

---

## Simple Examples

```bash
# Connect to a remote host as a specific user
ssh admin_user@192.168.122.15

# Connect on a non-default port
ssh admin_user@192.168.122.15 -p 2222

# Connect using a specific private key file
ssh -i ~/.ssh/id_rsa admin_user@192.168.122.15

# Run a single command on the remote host and return
ssh admin_user@192.168.122.15 "whoami"

# Enable verbose output (useful for debugging connection issues)
ssh -v admin_user@192.168.122.15

# Forward a local port to a remote service (port tunnelling)
ssh -L 8080:localhost:80 admin_user@192.168.122.15
```

---

## Composite Example

Connecting to a wargame VM from your host machine on port 2222, then verifying you're in the right place:

```bash
# From your host machine
ssh bushranger101@10.13.37.42 -p 2222
# The authenticity of host '10.13.37.42' can't be established.
# Are you sure you want to continue connecting (yes/no)? yes
# bushranger101@10.13.37.42's password:

# Now you're on the remote machine
whoami
# bushranger101

cat ~/secret.flag
# a43c1b0aa53a0c908810c06ab1ff3967

exit
# Connection to 10.13.37.42 closed.
```

---

## Notes for Students

- The first time you connect to a host, SSH will ask you to verify its fingerprint. Type `yes` to accept and it won't ask again for that host.
- **Port 22 is the default.** We use `2222` in this course to avoid conflicts if your host also runs SSH. Always specify `-p 2222` when connecting to your VM.
- SSH stores known hosts in `~/.ssh/known_hosts`. If you rebuild a VM and try to reconnect, you may get a "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED" error — this is SSH protecting you from a potential attack. If you know the host changed legitimately (you just rebuilt it), remove the old entry: `ssh-keygen -R 10.13.37.42`
- In a wargame, SSH is how players progress between levels. They find the password for the next level and SSH in as that user.
- `ssh-keygen` creates a public/private key pair for passwordless authentication — more secure than passwords and worth learning once you're comfortable with the basics.
