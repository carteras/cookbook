# Fedora Server 43 — Systems & Virtualisation Lessons

A practical, hands-on course for people building and managing Linux servers for the first time. All lessons use **Fedora Server 43** running under **QEMU/KVM**.

---

## Lesson Sequence

| # | File | Topic | Prerequisites |
|---|------|--------|---------------|
| 1 | `lesson_01_virtual-machines_introduction.md` | Installing Fedora Server 43 in QEMU/KVM | None |
| 2 | `lesson_02_virtual-machines_configure_second_network.md` | Adding a bridged second network card | Lesson 1 |
| 3 | `lesson_03_systems_adduser.md` | Creating a new user with `useradd` | Lessons 1–2 |
| 4 | `lesson_04_systems_passwd.md` | Setting passwords with `passwd` | Lesson 3 |
| 5 | `lesson_05_systems_chown.md` | Changing file ownership with `chown` | Lessons 3–4 |
| 6 | `lesson_06_systems_chmod.md` | Changing file permissions with `chmod` | Lesson 5 |
| 7 | `lesson_07_systems_touch.md` | Creating files with `touch` — bringing it all together | Lessons 3–6 |

---

## Image Placeholders

Several lessons reference screenshots that need to be captured on a working Fedora 43 system. They are marked in each lesson with `📌 IMAGE PLACEHOLDER`. Here's a master list:

### Lesson 1
1. virt-manager ISO browser dialog — file picker with Fedora ISO selected
2. Fedora Anaconda installer language selection screen
3. Fedora Software Selection screen — "Minimal Install" highlighted
4. Fedora Installation Destination — virtual disk selected
5. Fedora installation progress screen
6. Fedora installation complete — "Reboot System" button

### Lesson 2
7. virt-manager "Add New Virtual Hardware" — Network, Bridge device, br0

---

## Environment Notes

- **Host OS**: Any modern Linux with KVM support (Fedora, Ubuntu, Debian, etc.)
- **Guest OS**: Fedora Server 43 (Minimal Install)
- **Hypervisor**: QEMU/KVM via `virt-manager`
- **Network Setup**:
  - NIC 1: NAT (`192.168.122.x`) — internet access for the VM
  - NIC 2: Bridge to `br0` (`10.13.37.x`) — classroom/local network access
- **SSH port**: `2222` (changed from default `22`)

---

## Key Commands Reference

```bash
# Virtualisation
sudo systemctl enable --now libvirtd     # Start the VM manager service
virt-manager                             # Open the graphical VM manager

# Users
sudo useradd -m username                 # Create user with home directory
sudo passwd username                     # Set user's password
su - username                            # Switch to another user

# Ownership
sudo chown user:group path               # Change owner and group
sudo chown -R user:group directory/      # Recursive change

# Permissions
sudo chmod u+rw,g+r file                 # Add read/write for owner, read for group
sudo chmod o-r file                      # Remove read from others
sudo chmod 644 file                      # Set rw-r--r-- numerically

# Files
touch filename                           # Create empty file

# Networking
ip a                                     # Show all IP addresses
sudo dhclient enp7s0                     # Request IP via DHCP
sudo firewall-cmd --permanent --add-port=2222/tcp  # Open firewall port

# SSH
ssh username@ip-address -p 2222          # Connect to VM via SSH
sudo systemctl enable --now sshd         # Start and enable SSH server
sudo systemctl status sshd               # Check SSH status
```