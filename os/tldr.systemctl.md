# tldr: systemctl

## Description

Controls the `systemd` system and service manager — the thing that starts, stops, and monitors every service running on your Fedora server. Use it to start and stop services, check whether they're running, and configure whether they start automatically on boot.

---

## Simple Examples

```bash
# Check the status of a service
sudo systemctl status sshd

# Start a service right now
sudo systemctl start sshd

# Stop a service
sudo systemctl stop sshd

# Restart a service (stop then start)
sudo systemctl restart sshd

# Reload config without fully restarting (not all services support this)
sudo systemctl reload sshd

# Enable a service to start automatically on boot
sudo systemctl enable sshd

# Disable a service from starting on boot
sudo systemctl disable sshd

# Start now AND enable on boot in one command
sudo systemctl enable --now sshd

# List all running services
systemctl list-units --type=service --state=running
```

---

## Composite Example

Installing SSH, starting it, enabling it on boot, and verifying it's listening:

```bash
sudo dnf install -y openssh-server
sudo systemctl enable --now sshd
sudo systemctl status sshd
```

```
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; preset: enabled)
     Active: active (running) since Mon 2024-01-01 10:00:00 UTC
   Main PID: 753 (sshd)
...
Jan 01 10:00:00 hostname sshd[753]: Server listening on 0.0.0.0 port 2222.
```

Key things to check in the output:
- `enabled` in the `Loaded` line — means it will start on boot
- `active (running)` — means it's running right now
- The log line confirming which port it's listening on

After editing the SSH config file, apply changes with:

```bash
sudo systemctl restart sshd
sudo systemctl status sshd
```

---

## Notes for Students

- **`enable` and `start` are different things.** `enable` means "start on boot." `start` means "start right now." A service can be enabled but not running (it will start next boot), or running but not enabled (it won't survive a reboot). Use `enable --now` to do both at once.
- `status` is your first diagnostic tool. If something isn't working, run `systemctl status servicename` — it shows the last few log lines and tells you if the service crashed, failed to start, or is running fine.
- Service names on Fedora: SSH is `sshd` (not `ssh` as on Ubuntu). Network management is `systemd-networkd` or `NetworkManager`. If you're not sure of the name, `systemctl list-units --type=service` will show everything.
- `sudo systemctl restart sshd` is the command you'll run most often in this course — any time you edit `/etc/ssh/sshd_config`, you need to restart the service for the changes to take effect.
- `journalctl -u sshd` shows the full log history for a service. Essential when `status` doesn't give you enough detail to diagnose a problem.
