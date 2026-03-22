# tldr: firewall-cmd

## Description

Manages Fedora's `firewalld` — the firewall that controls which network traffic is allowed in and out of your server. Unlike older `iptables` commands, `firewall-cmd` uses the concept of **zones** (named rulesets) and **services** (named port groups). Changes can be made temporarily (lost on reboot) or permanently. Almost every server config task that opens a new port requires a `firewall-cmd` step.

---

## Simple Examples

```bash
# Check the firewall is running
sudo systemctl status firewalld

# Show currently active zones and which interfaces belong to them
sudo firewall-cmd --get-active-zones

# List all rules in the default (public) zone
sudo firewall-cmd --list-all

# Allow a specific port permanently (survives reboots)
sudo firewall-cmd --permanent --add-port=2222/tcp

# Allow a named service permanently (firewalld knows common service names)
sudo firewall-cmd --permanent --add-service=http

# Remove a port rule permanently
sudo firewall-cmd --permanent --remove-port=2222/tcp

# Apply all --permanent changes immediately (required after every --permanent change)
sudo firewall-cmd --reload

# Check what ports are currently open in the public zone
sudo firewall-cmd --list-ports

# Add an interface to a zone permanently
sudo firewall-cmd --permanent --zone=public --add-interface=enp7s0
```

---

## Composite Example

Opening port 2222 for SSH after changing the default SSH port in `sshd_config`:

```bash
# Open the new port
sudo firewall-cmd --permanent --add-port=2222/tcp

# Apply the change
sudo firewall-cmd --reload

# Verify the port is now listed
sudo firewall-cmd --list-ports
# 2222/tcp

# If you want, also remove the default port 22 so it's not open unnecessarily
sudo firewall-cmd --permanent --remove-service=ssh
sudo firewall-cmd --reload
```

Adding the second bridged network interface to the public zone so traffic flows through:

```bash
sudo firewall-cmd --permanent --zone=public --add-interface=enp7s0
sudo firewall-cmd --reload
sudo firewall-cmd --get-active-zones
# public
#   interfaces: enp1s0 enp7s0
```

---

## Notes for Students

- **Always follow a `--permanent` command with `--reload`.** The `--permanent` flag writes the rule to disk but doesn't activate it yet. `--reload` applies all saved permanent rules. If you skip the reload, your change won't take effect until the next reboot.
- Without `--permanent`, a rule is applied immediately but **lost on reboot**. Useful for testing a rule before committing it permanently.
- `--list-all` is your best diagnostic tool — it shows zones, interfaces, services, and ports all at once.
- **Zones** are named security profiles: `public` is the default for external-facing interfaces, `trusted` allows all traffic, `drop` silently drops everything. Most setups just use `public`.
- Fedora's firewall is on by default. Ubuntu Server does not enable a firewall by default. This is one of the most common sources of "why can't I connect?" confusion when switching between distros — always check `firewall-cmd --list-all` first.
- Named services (`--add-service=http`) are just named shortcuts for port rules. `firewall-cmd --get-services` lists all the service names firewalld knows about.
