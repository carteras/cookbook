# tldr: shutdown & reboot

## Description

`shutdown` powers off or reboots the system cleanly — flushing disk writes, stopping services, and logging out users in an orderly way. `reboot` is a shortcut for `shutdown -r now`. Never just pull the plug on a running Linux server; always shut down properly to avoid filesystem corruption.

---

## Simple Examples

```bash
# Shut down immediately
sudo shutdown now

# Reboot immediately
sudo reboot

# Shut down and power off (same as 'now' on most systems)
sudo shutdown -h now

# Reboot using shutdown
sudo shutdown -r now

# Schedule a shutdown in 10 minutes with a wall message to logged-in users
sudo shutdown +10 "Server going down for maintenance in 10 minutes"

# Schedule a shutdown at a specific time
sudo shutdown 23:30 "Nightly maintenance window"

# Cancel a scheduled shutdown
sudo shutdown -c
```

---

## Composite Example

Finishing a lab session cleanly — saving work, then shutting down the VM:

```bash
# Make sure nothing important is running
sudo systemctl status sshd

# Shut down gracefully
sudo shutdown now
```

After making changes to the SSH config or network settings, a reboot is a good way to verify everything comes back up correctly:

```bash
sudo reboot
# ... wait for the VM to restart, then reconnect via SSH ...
ssh admin_user@10.13.37.42 -p 2222
whoami
# admin_user
ip a
# verify both network cards have addresses
```

---

## Notes for Students

- **`sudo shutdown now` is always the right way to stop a VM** at the end of class. Inside virt-manager you can also right-click → Shut Down → Shut Down, which sends the same signal.
- If the VM freezes and won't respond to shutdown commands, you can force-stop it from virt-manager (right-click → Force Off), but only as a last resort — it's equivalent to pulling the power.
- `reboot` after a configuration change is the best test that your changes are correct and persistent. If SSH doesn't come back up after a reboot, your config has a problem.
- `shutdown -r now` and `reboot` do the same thing. `reboot` is shorter to type. Both require `sudo`.
- The wall message in `sudo shutdown +10 "message"` is broadcast to every terminal session currently logged in. Useful on shared servers to warn other users before taking the machine down.
