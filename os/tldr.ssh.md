# TL;DR SSH  

## Introduction
Secure Shell (SSH) is a cryptographic network protocol that allows secure communication between devices over an unsecured network. It's widely used for remote system administration, secure file transfers, and tunneling.

---

## 1. **Basic SSH Connection**
### 🔹 Connect to a remote server
```sh
ssh username@remote_host
```
- `username`: Your login name on the remote machine.
- `remote_host`: The IP address or domain of the server.

---

## 2. **Using SSH Keys (Passwordless Login)**
### 🔹 Generate SSH Key Pair
```sh
ssh-keygen -t rsa -b 4096
```
- Saves keys in `~/.ssh/id_rsa` (private) and `~/.ssh/id_rsa.pub` (public).

### 🔹 Copy Public Key to Server
```sh
ssh-copy-id username@remote_host
```
- Enables passwordless login.

---

## 3. **Securely Copying Files with SCP**
### 🔹 Copy a file from local to remote
```sh
scp localfile.txt username@remote_host:/remote/directory/
```

### 🔹 Copy a file from remote to local
```sh
scp username@remote_host:/remote/file.txt ./
```

### 🔹 Copy directories recursively
```sh
scp -r local_directory username@remote_host:/remote/directory/
```

---

## 4. **Using rsync for Faster Transfers**
### 🔹 Sync local and remote directories efficiently
```sh
rsync -avz local_directory/ username@remote_host:/remote/directory/
```
- `-a`: Archive mode (preserves permissions, timestamps, symbolic links).
- `-v`: Verbose mode.
- `-z`: Compresses data for faster transfer.

---

## 5. **SSH Tunneling (Port Forwarding)**
### 🔹 Forward local port to a remote machine
```sh
ssh -L local_port:target_host:target_port username@remote_host
```
- Example: Access a web service on a remote server locally
```sh
ssh -L 8080:localhost:80 username@remote_host
```

---

## 6. **Multiplexing SSH Sessions**
### 🔹 Speed up repeated SSH connections
```sh
echo "
Host *
    ControlMaster auto
    ControlPath ~/.ssh/control-%r@%h:%p
    ControlPersist 10m
" >> ~/.ssh/config
```
- Prevents multiple authentications for subsequent connections.

---

## 7. **Managing SSH Sessions**
### 🔹 Run a command on a remote server
```sh
ssh username@remote_host 'ls -lah /var/log'
```

### 🔹 Keep an SSH session alive
```sh
ssh -o ServerAliveInterval=60 username@remote_host
```

### 🔹 Disconnect but keep processes running
```sh
nohup my_command &
```

---

## 8. **SSH Configuration for Convenience**
### 🔹 Simplify SSH with `~/.ssh/config`
```sh
echo "
Host myserver
    HostName remote_host
    User username
    IdentityFile ~/.ssh/id_rsa
" >> ~/.ssh/config
```
Then, connect with:
```sh
ssh myserver
```

---

## 9. **Troubleshooting SSH Issues**
### 🔹 Debugging SSH connections
```sh
ssh -v username@remote_host
```

### 🔹 Restart SSH service (on the server)
```sh
sudo systemctl restart ssh
```

### 🔹 Fixing permission issues
```sh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
chmod 700 ~/.ssh
```

---

## Conclusion
SSH is a powerful tool for remote system access, file transfers, and secure tunneling. Mastering its basics will make remote system management more efficient and secure. Practice these commands to become proficient!

