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
- SSH access into that machine from your host computer
- A foundation to build on in future lessons

## At the End of This Lesson You Will Be Able To

- Install and configure QEMU/KVM on your host machine
- Create a new virtual machine using `virt-manager`
- Install Fedora Server 43 from an ISO image
- Set up your user account and configure SSH access
- Connect to your VM remotely over SSH

## Glossary

| Term | Meaning |
|------|---------|
| **VM** | Virtual Machine — a computer running inside software |
| **Host** | Your real, physical computer |
| **Guest** | The virtual machine running on your host |
| **ISO** | A disk image file — like a virtual DVD |
| **KVM** | Kernel-based Virtual Machine — Linux's built-in virtualisation engine |
| **QEMU** | Quick Emulator — hardware emulation layer |
| **virt-manager** | A graphical tool to manage VMs |
| **NAT** | Network Address Translation — your VM shares your host's IP address |
| **Bridge** | A direct network connection — your VM gets its own IP address |
| **SSH** | Secure Shell — a way to log into a remote machine securely over the network |
| `sudo` | "Super User Do" — run a command with administrator privileges |
| `dnf` | Fedora's package manager (like an app store for the terminal) |
| `nano` | A simple text editor in the terminal |
| `systemctl` | A tool to start, stop, and check the status of system services |

---

## Part 1: Preparing Your Host Machine

Before we can create a VM, we need to make sure your computer supports virtualisation and has the right software installed.

### Step 1.1 — Check That Your CPU Supports Virtualisation

Open a terminal on your host machine and run:

```bash
grep -Ec '(vmx|svm)' /proc/cpuinfo
```

If you get a number greater than `0`, you're good to go. If you get `0`, you'll need to enable virtualisation in your BIOS/UEFI settings (look for "Intel VT-x" or "AMD-V").

### Step 1.2 — Install QEMU/KVM and virt-manager

If you are at home working on virtual box

```bash
sudo dnf install -y qemu-kvm libvirt virt-manager virt-install
```

This installs everything you need. Here's what each package does:

- `qemu-kvm` — the virtualisation engine
- `libvirt` — the service that manages VMs
- `virt-manager` — the graphical interface
- `virt-install` — a command-line installer (useful later)

### Step 1.3 — Start and Enable the Virtualisation Service

```bash
sudo systemctl enable --now libvirtd
```

The `--now` flag means "start it right now AND set it to start automatically on boot". 

Verify it's running:

```bash
sudo systemctl status libvirtd
```

You should see `Active: active (running)` in green.

### Step 1.4 — Add Your User to the `libvirt` Group

This lets you manage VMs without typing `sudo` every time:

```bash
sudo usermod -aG libvirt $(whoami)
```

**Important:** Log out and back in (or reboot) for this to take effect.

---

## Part 2: Getting the Fedora Server 43 ISO

You'll need the Fedora Server 43 ISO image. Your instructor may have placed it in a shared folder (check `/shared/vms/` or ask). If not, download it:

```bash
# Check the shared folder first
ls /shared/vms/

# If it's not there, download it (this is a large file ~800MB)
wget -P ~/Downloads https://dl.fedoraproject.org/pub/fedora/linux/releases/43/Server/x86_64/iso/Fedora-Server-dvd-x86_64-43-*.iso
```

---

## Part 3: Creating Your Virtual Machine

### Step 3.1 — Open virt-manager

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

### Step 3.2 — Choose Installation Method

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

### Step 3.3 — Select the ISO

Click **Browse**, then **Browse Local**, and navigate to your Fedora Server ISO.

> 📌 **IMAGE PLACEHOLDER**  
> *Screenshot needed: virt-manager ISO browser dialog showing the file picker with a Fedora ISO selected*

virt-manager should automatically detect the operating system as "Fedora". If it doesn't, uncheck "Automatically detect" and type `Fedora` in the search box.

Click **Forward**.

### Step 3.4 — Set RAM and CPU

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

### Step 3.5 — Create a Virtual Hard Disk

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

### Step 3.6 — Name Your VM and Choose Network

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

## Part 4: Installing Fedora Server 43

The Fedora Server installer will appear in a new window. Follow these steps carefully.

### Step 4.1 — Boot Menu

When the VM starts, you'll see a boot menu. Press **Enter** or wait for it to automatically select **"Install Fedora Server 43"**.

> 📌 **IMAGE PLACEHOLDER**  
> *Screenshot needed: Fedora 43 GRUB boot menu showing "Install Fedora Server 43" option highlighted*

### Step 4.2 — Language Selection

Choose your language and click **Continue**.

> 📌 **IMAGE PLACEHOLDER**  
> *Screenshot needed: Fedora Anaconda installer language selection screen*

### Step 4.3 — Installation Summary Screen

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

### Step 4.4 — Software Selection

Click **Software Selection**.

Select **Minimal Install** from the left column. This gives us a lean server without a graphical desktop — perfect for learning the command line.

> 📌 **IMAGE PLACEHOLDER**  
> *Screenshot needed: Fedora Software Selection screen with "Minimal Install" highlighted on the left*

Click **Done**.

### Step 4.5 — Installation Destination

Click **Installation Destination**.

Your virtual hard disk should be listed. Select it by clicking on it (a checkmark will appear). Leave partitioning on **Automatic**.

> 📌 **IMAGE PLACEHOLDER**  
> *Screenshot needed: Fedora Installation Destination screen with the virtual disk selected and Automatic partitioning chosen*

Click **Done**.

### Step 4.6 — Network & Hostname

Click **Network & Hostname**.

- Make sure your network card is toggled **ON** (the slider on the right should be blue/on).
- Set the **Hostname** to something meaningful, like `fedora-server` or your student number.

Click **Done**.

### Step 4.7 — Root Account

Click **Root Account**.

You have two choices here:
- **Disable root account** (recommended for security — you'll use `sudo` instead)
- Set a root password

For this course, **disable the root account** by checking "Disable root account". We'll use `sudo` for everything.

Click **Done**.

### Step 4.8 — User Creation

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

### Step 4.9 — Begin Installation

Once all warning icons are gone, click **Begin Installation**.

The installation will take a few minutes. You'll see a progress screen as files are copied and configured.

> 📌 **IMAGE PLACEHOLDER**  
> *Screenshot needed: Fedora installation progress screen showing packages being installed*

### Step 4.10 — Reboot

When the installation finishes, click **Reboot System**.

> 📌 **IMAGE PLACEHOLDER**  
> *Screenshot needed: Fedora installation complete screen with "Reboot System" button*

If the VM doesn't reboot cleanly, you can force it off in virt-manager by clicking the power icon and selecting **Force Off**, then start it again.

---

## Part 5: First Login and Initial Setup

### Step 5.1 — Log In

After the reboot, you'll see a plain text login prompt:

```
Fedora Linux 43 (Server Edition)
Kernel 6.x.x on an x86_64

fedora-server login: yourusername
Password:
```

Type your username and press Enter, then type your password (it won't show as you type — that's normal).

### Step 5.2 — Check Your Shell

After logging in, check what shell you're using:

```bash
echo $SHELL
```

Fedora uses `bash` by default, so you should see `/bin/bash`. 

### Step 5.3 — Update the System

Before doing anything else, let's make sure the system is up to date:

```bash
sudo dnf update -y
```

This will download and install the latest updates. The first time can take a while.

---

## Part 6: Installing and Configuring SSH

SSH lets you log into your VM from a terminal on your host machine — much more convenient than typing in the VM window.

### Step 6.1 — Install OpenSSH Server

Fedora Server usually has SSH pre-installed, but let's check and install it if needed:

```bash
sudo dnf install -y openssh-server
```

### Step 6.2 — Check SSH Status

```bash
sudo systemctl status sshd
```

You should see `Active: active (running)`. If not:

```bash
sudo systemctl enable --now sshd
```

### Step 6.3 — Configure SSH

By default, Fedora's SSH is configured reasonably well, but let's make a few adjustments for our learning environment.

Open the SSH configuration file:

```bash
sudo nano /etc/ssh/sshd_config
```

Find and change (or uncomment) these lines:

```
Port 2222
PasswordAuthentication yes
```

> 💡 We change the port to `2222` to avoid conflicts if your host machine also runs SSH on port 22.

Press **Ctrl+S** to save, then **Ctrl+X** to exit.

Restart SSH to apply the changes:

```bash
sudo systemctl restart sshd
sudo systemctl status sshd
```

You should see it's now listening on port 2222:

```
● sshd.service - OpenSSH server daemon
     Active: active (running)
     ...
Mar 29 ... sshd[...]: Server listening on 0.0.0.0 port 2222.
```

### Step 6.4 — Open the Firewall for Port 2222

Fedora has a firewall enabled by default. We need to allow traffic on port 2222:

```bash
sudo firewall-cmd --permanent --add-port=2222/tcp
sudo firewall-cmd --reload
```

Verify it worked:

```bash
sudo firewall-cmd --list-ports
```

You should see `2222/tcp` in the output.

### Step 6.5 — Find Your VM's IP Address

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

## Part 7: Connecting via SSH from Your Host

On your **host machine** (not inside the VM), open a terminal and connect:

```bash
ssh yourusername@192.168.122.XX -p 2222
```

For example:

```bash
ssh adam@192.168.122.15 -p 2222
```

When prompted "Are you sure you want to continue connecting?", type `yes`.

Enter your password when asked.

You should now see a prompt like:

```bash
[adam@fedora-server ~]$
```

Congratulations — you're logged into your VM over SSH! 🎉

Let's verify who we are and test `sudo`:

```bash
whoami
# Output: adam

sudo whoami
# Output: root
```

### Shutting Down Your VM Gracefully

At the end of class, always shut down properly:

```bash
sudo shutdown now
```

---

## Summary

You've successfully:

- Installed QEMU/KVM on your host machine
- Created a Fedora Server 43 virtual machine
- Installed Fedora Server with a minimal configuration
- Set up SSH for remote access
- Connected to your VM from your host

In the next lesson, we'll add a second network card to give your VM its own IP address on the local network.