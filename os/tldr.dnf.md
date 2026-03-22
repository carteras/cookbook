# tldr: dnf

## Description

Fedora's package manager — installs, removes, and updates software from online repositories. Short for "Dandified YUM" (the tool it replaced). Think of it as an app store for the terminal: you ask for something by name and dnf finds it, downloads it, and installs it along with anything it depends on.

---

## Simple Examples

```bash
# Install a package
sudo dnf install openssh-server

# Install without being prompted to confirm (say yes to everything)
sudo dnf install -y openssh-server

# Remove a package
sudo dnf remove openssh-server

# Update all installed packages to their latest versions
sudo dnf update

# Update a specific package
sudo dnf update openssh-server

# Search for a package by name or description
dnf search "dhcp client"

# Get information about a package (version, description, dependencies)
dnf info openssh-server

# List all installed packages
dnf list installed

# Check what package provides a specific file or command
dnf provides /usr/sbin/sshd
```

---

## Composite Example

Updating the system, then installing the packages needed for a wargame server:

```bash
# Update everything first (good habit before installing new packages)
sudo dnf update -y

# Install OpenSSH server
sudo dnf install -y openssh-server

# Install the DHCP client for the second network card
sudo dnf install -y dhcp-client

# Verify what was installed
dnf list installed | grep -E "openssh|dhcp"
```

```
dhcp-client.x86_64          4.4.3-12.fc43    @updates
openssh-server.x86_64       9.7p1-3.fc43     @updates
```

---

## Notes for Students

- **Always run `sudo dnf update -y` before installing anything new** on a fresh system. This ensures you're getting the latest versions and that the package database is current.
- The `-y` flag auto-confirms all prompts. Useful in scripts or when you're confident. Leave it off the first time you run a command if you want to review what's about to be installed.
- `dnf` handles **dependencies** automatically. If `openssh-server` needs another library, `dnf` installs that too. You don't have to worry about it.
- On Ubuntu/Debian systems the equivalent command is `apt` (or `apt-get`). The concepts are identical, just different syntax. Knowing one makes learning the other easy.
- `dnf search keyword` is invaluable when you know what you need functionally but not the exact package name. For example: `dnf search "network bridge"` to find bridge networking utilities.
- After removing a package with `dnf remove`, its config files may be left behind. `dnf remove --purge` removes config files too (similar to `apt purge` on Debian systems).
