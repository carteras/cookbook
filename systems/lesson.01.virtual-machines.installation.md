# Lesson 1: Installing a Virtual Machine with Fedora Server 43

## Concept

A **virtual machine (VM)** is a computer running inside your computer. Instead of buying a whole new physical server, you can create one in software. This lets you safely experiment, break things, and learn — without any real consequences.

We'll be using **QEMU/KVM**, which is the gold standard for virtualisation on Linux. Think of it like this:

- **KVM** is the engine — it talks directly to your CPU to make virtualisation fast
- **QEMU** is the body — it pretends to be all the hardware a computer needs (disk, network card, screen)
- **virt-manager** is the dashboard — a graphical app that makes it easy to manage everything

## Goals

By the end of this module you will have:

- A working Fedora Server 43 virtual machine
- SSH access into that machine from the lab machine's terminal
- A foundation to build on in future lessons

## At the End of This Lesson You Will Be Able To

- Launch `virt-manager` on a lab machine
- Create a new virtual machine using `virt-manager`
- Install Fedora Server 43 from an ISO image
- Set up your user account and configure SSH access
- Connect to your VM remotely over SSH

## Glossary

| Term | Meaning |
|------|---------|
| **VM** | Virtual Machine — a computer running inside software |
| **Host** | The lab machine you're sitting at |
| **Guest** | The virtual machine running on the host |
| **ISO** | A disk image file — like a virtual DVD |
| **KVM** | Kernel-based Virtual Machine — Linux's built-in virtualisation engine |
| **QEMU** | Quick Emulator — hardware emulation layer |
| **virt-manager** | A graphical tool to manage VMs |
| **NAT** | Network Address Translation — your VM shares your host's IP address |
| **Bridge** | A direct network connection — your VM gets its own IP address |
| **SSH** | Secure Shell — a way to log into a remote machine securely over the network |
| `sudo` | "Super User Do" — run a command as administrator (used inside your VM) |
| `dnf` | Fedora's package manager (like an app store for the terminal) |
| `nano` | A simple text editor in the terminal |
| `systemctl` | A tool to start, stop, and check the status of system services |

---

> 📋 **Lab machines are pre-configured.**  
> QEMU/KVM, `libvirt`, and `virt-manager` are already installed and running on your lab machine by your instructor. You do not need to install or configure anything on the host — just open `virt-manager` and go. Everything from Part 1 onwards happens inside your VM, where you will have full administrator access.

---

## Part 1: Getting the Fedora Server 43 ISO

The Fedora Server 43 ISO has been placed in a shared folder on the lab machine by your instructor. You don't need to download anything.

To confirm you can see it, open a terminal on the lab machine and run:

```bash
ls /shared/vms/
```

You should see a file ending in `.iso`. Note the full filename — you'll need it when browsing for the ISO in virt-manager shortly. If the folder is empty or the path doesn't exist, ask your instructor before continuing.

---

## Part 2: Creating Your Virtual Machine

### Step 2.1 — Open virt-manager

```bash
virt-manager
```

The virt-manager window will open.

```
┌─────────────────────────────────────────────────────┐
│  Virtual Machine Manager                        [x]  │
├─────────────────────────────────────────────────────┤
│  File  Edit  View  Help                              │
├─────────────────────────────────────────────────────┤
│                                                      │
│  Name                      CPU usage   Host CPU      │
│  ──────────────────────────────────────────────────  │
│  QEMU/KVM                                            │
│                                                      │
│  [ Create a new virtual machine ]  ← Click this     │
│                                                      │
└─────────────────────────────────────────────────────┘
```

Click the **"Create a new virtual machine"** button (it looks like a computer screen with a star, in the toolbar).

### Step 2.2 — Choose Installation Method

```
┌─────────────────────────────────────────────────┐
│  New VM  (Step 1 of 5)                          │
├─────────────────────────────────────────────────┤
│  How would you like to install the OS?          │
│                                                 │
│  (●) Local install media (ISO image or CDROM)  │
│  ( ) Network Install (HTTP, HTTPS, or FTP)      │
│  ( ) Import existing disk image                 │
│                                                 │
│  [  Back  ]  [  Forward  ]  [  Cancel  ]        │
└─────────────────────────────────────────────────┘
```

Select **"Local install media (ISO image or CDROM)"** and click **Forward**.

### Step 2.3 — Select the ISO

Click **Browse**, then **Browse Local**, and navigate to your Fedora Server ISO.

> 📌 **IMAGE PLACEHOLDER**  
> *Screenshot needed: virt-manager ISO browser dialog showing the file picker with a Fedora ISO selected*

virt-manager should automatically detect the operating system as "Fedora". If it doesn't, uncheck "Automatically detect" and type `Fedora` in the search box.

Click **Forward**.

### Step 2.4 — Set RAM and CPU

```
┌─────────────────────────────────────────────────┐
│  New VM  (Step 3 of 5)                          │
├─────────────────────────────────────────────────┤
│  Memory:  [ 2048 ] MiB                          │
│  CPUs:    [   2  ]                              │
│                                                 │
│  [  Back  ]  [  Forward  ]  [  Cancel  ]        │
└─────────────────────────────────────────────────┘
```

- **Memory**: Set to at least `2048` MiB (2 GB). 4096 is better if your computer has the RAM.
- **CPUs**: `2` is fine for learning.

Click **Forward**.

### Step 2.5 — Create a Virtual Hard Disk

```
┌─────────────────────────────────────────────────┐
│  New VM  (Step 4 of 5)                          │
├─────────────────────────────────────────────────┤
│  (●) Create a disk image for the VM             │
│      [ 20.0 ] GiB                               │
│                                                 │
│  [  Back  ]  [  Forward  ]  [  Cancel  ]        │
└─────────────────────────────────────────────────┘
```

Leave the default of **20 GiB** and click **Forward**.

### Step 2.6 — Name Your VM and Choose Network

```
┌─────────────────────────────────────────────────┐
│  New VM  (Step 5 of 5)                          │
├─────────────────────────────────────────────────┤
│  Name: [ your-student-number ]                  │
│                                                 │
│  Network selection:                             │
│  [ Virtual network 'default': NAT          ▼ ] │
│                                                 │
│  [  Back  ]  [  Finish  ]  [  Cancel  ]         │
└─────────────────────────────────────────────────┘
```

- **Name**: Use your student number or a name you'll remember. **Don't use spaces.** Keep it professional — your instructor will see it.
- **Network**: Leave as **NAT** for now. We'll add a second network card in a later lesson.

Click **Finish**. Your VM will be created and the installation will start automatically.

---

## Part 3: Installing Fedora Server 43

The Fedora Server installer will appear in a new window. Follow these steps carefully.

### Step 3.1 — Boot Menu

When the VM starts, you'll see a boot menu. Press **Enter** or wait for it to automatically select **"Install Fedora Server 43"**.

> 📌 **IMAGE PLACEHOLDER**  
> *Screenshot needed: Fedora 43 GRUB boot menu showing "Install Fedora Server 43" option highlighted*

### Step 3.2 — Language Selection

Choose your language and click **Continue**.

> 📌 **IMAGE PLACEHOLDER**  
> *Screenshot needed: Fedora Anaconda installer language selection screen*

### Step 3.3 — Installation Summary Screen

This is the main hub. You'll see several options that need to be configured (marked with warning icons ⚠️).

```
┌─────────────────────────────────────────────────────────────┐
│  INSTALLATION SUMMARY                                       │
├──────────────────────────┬──────────────────────────────────┤
│  LOCALIZATION            │  SOFTWARE                        │
│  ⚠ Keyboard              │  ✓ Installation Source           │
│  ✓ Language Support      │  ⚠ Software Selection            │
│  ✓ Time & Date           │                                  │
├──────────────────────────┼──────────────────────────────────┤
│  SYSTEM                  │  USER SETTINGS                   │
│  ⚠ Installation Dest.    │  ⚠ Root Account                  │
│  ✓ KDUMP                 │  ⚠ User Creation                 │
│  ✓ Network & Hostname    │                                  │
└──────────────────────────┴──────────────────────────────────┘
```

Work through each item with a ⚠️.

### Step 3.4 — Software Selection

Click **Software Selection**.

Select **Minimal Install** from the left column. This gives us a lean server without a graphical desktop — perfect for learning the command line.

> 📌 **IMAGE PLACEHOLDER**  
> *Screenshot needed: Fedora Software Selection screen with "Minimal Install" highlighted on the left*

Click **Done**.

### Step 3.5 — Installation Destination

Click **Installation Destination**.

Your virtual hard disk should be listed. Select it by clicking on it (a checkmark will appear). Leave partitioning on **Automatic**.

> 📌 **IMAGE PLACEHOLDER**  
> *Screenshot needed: Fedora Installation Destination screen with the virtual disk selected and Automatic partitioning chosen*

Click **Done**.

### Step 3.6 — Network & Hostname

Click **Network & Hostname**.

- Make sure your network card is toggled **ON** (the slider on the right should be blue/on).
- Set the **Hostname** to something meaningful, like `fedora-server` or your student number.

Click **Done**.

### Step 3.7 — Root Account

Click **Root Account**.

For this course, **disable the root account** by checking "Disable root account". You will have full administrator access through your own account using `sudo` inside your VM — a separate root account is not needed and is best left disabled for security.

Click **Done**.

### Step 3.8 — User Creation

Click **User Creation**. This is your personal account.

```
Full name:  [ Your Name        ]
Username:   [ yourusername     ]  ← lowercase, no spaces
Password:   [ **************** ]
Confirm:    [ **************** ]

[X] Make this user administrator
```

> ⚠️ **Use a strong password.** Your classmates are on the same network. Don't embarrass yourself.

Check **"Make this user administrator"** — this gives you `sudo` access.

Click **Done**.

### Step 3.9 — Begin Installation

Once all warning icons are gone, click **Begin Installation**.

The installation will take a few minutes. You'll see a progress screen as files are copied and configured.

> 📌 **IMAGE PLACEHOLDER**  
> *Screenshot needed: Fedora installation progress screen showing packages being installed*

### Step 3.10 — Reboot

When the installation finishes, click **Reboot System**.

> 📌 **IMAGE PLACEHOLDER**  
> *Screenshot needed: Fedora installation complete screen with "Reboot System" button*

If the VM doesn't reboot cleanly, you can force it off in virt-manager by clicking the power icon and selecting **Force Off**, then start it again.

---

## Part 4: First Login and Initial Setup

### Step 4.1 — Log In

After the reboot, you'll see a plain text login prompt:

```
Fedora Linux 43 (Server Edition)
Kernel 6.x.x on an x86_64

fedora-server login: yourusername
Password:
```

Type your username and press Enter, then type your password (it won't show as you type — that's normal).

### Step 4.2 — Check Your Shell

After logging in, check what shell you're using:

```bash
echo $SHELL
```

Fedora uses `bash` by default, so you should see `/bin/bash`. 

### Step 4.3 — Update the System

Your VM is a fresh install, so let's make sure it has the latest packages before we do anything else. This runs inside your VM, where you are the administrator:

```bash
sudo dnf update -y
```

This downloads and installs the latest updates. The first run can take a few minutes.

---

## Part 5: Installing and Configuring SSH

SSH lets you log into your VM from a terminal on the lab machine — much more convenient than typing directly into the VM window. All commands in this section run **inside your VM**.

### Step 5.1 — Install OpenSSH Server

Fedora Server usually has SSH pre-installed, but let's confirm and install it if needed:

```bash
sudo dnf install -y openssh-server
```

### Step 5.2 — Check SSH Status

```bash
sudo systemctl status sshd
```

You should see `Active: active (running)`. If not:

```bash
sudo systemctl enable --now sshd
```

### Step 5.3 — Configure SSH

Open the SSH configuration file:

```bash
sudo nano /etc/ssh/sshd_config
```

Find and change (or uncomment) these two lines:

```
PasswordAuthentication yes
```


Press **Ctrl+S** to save, then **Ctrl+X** to exit.

Restart SSH to apply the changes:

```bash
sudo systemctl restart sshd
sudo systemctl status sshd
```


```
● sshd.service - OpenSSH server daemon
     Active: active (running)
     ...
Mar 29 ... sshd[...]: Server listening on 0.0.0.0 port 22.
```

### Step 5.4 — Open the Firewall for Port 2222

We probably don't need this

<!-- Fedora's firewall is enabled by default inside your VM. We need to allow traffic on port 2222:

```bash
sudo firewall-cmd --permanent --add-port=2222/tcp
sudo firewall-cmd --reload
``` -->
<!-- 
Verify it worked:

```bash
sudo firewall-cmd --list-ports
```

You should see `2222/tcp` in the output. -->

### Step 5.5 — Find Your VM's IP Address

```bash
ip a
```

You'll see output like this:

```
1: lo: <LOOPBACK,UP,LOWER_UP> ...
    inet 127.0.0.1/8 ...

2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> ...
    inet 192.168.122.XX/24 ...      ← This is your VM's IP address
```

The `192.168.122.x` address is your VM's IP on the NAT network. Note it down.

---

## Part 6: Connecting via SSH from the Lab Machine

Now exit out of the VM console window and open a regular terminal on the **lab machine**. From there, connect to your VM over SSH:

```bash
ssh yourusername@192.168.122.XX -p 22
```

For example:

```bash
ssh adam@192.168.122.15 -p 22
```

When prompted "Are you sure you want to continue connecting?", type `yes`.

Enter your password when asked.

You should now see a prompt like:

```bash
[adam@fedora-server ~]$
```

Congratulations — you're logged into your VM over SSH! 🎉

Let's confirm who we are:

```bash
whoami
# Output: adam
```

And verify your administrator access works inside the VM:

```bash
sudo whoami
# Output: root
```

> 💡 `sudo` here is running inside your VM, where you created your account as administrator. You are not running as root on the lab machine itself.

### Shutting Down Your VM Gracefully

At the end of class, always shut down the VM properly — don't just close the window. Run this inside your VM:

```bash
sudo shutdown now
```

---

## Summary

You've successfully:

- Located the Fedora Server 43 ISO in the shared lab folder
- Created a Fedora Server 43 virtual machine using virt-manager
- Installed Fedora Server with a minimal configuration
- Set up SSH for remote access on port 22
- Connected to your VM from the lab machine via SSH

In the next lesson, we'll add a second network card to give your VM its own IP address on the local network.