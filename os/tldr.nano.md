# tldr: nano

## Description

A simple, beginner-friendly text editor that runs entirely in the terminal. Unlike `vim`, you don't need to learn modes or special commands to start typing — just open a file and edit it. The most important keyboard shortcuts are shown at the bottom of the screen at all times.

---

## Simple Examples

```bash
# Open a file for editing (creates it if it doesn't exist)
sudo nano /etc/ssh/sshd_config

# Open a file and jump straight to a specific line number
sudo nano +42 /etc/ssh/sshd_config

# Open a file in read-only mode (can't accidentally change anything)
nano -v /etc/passwd
```

### Essential Keyboard Shortcuts

All `nano` shortcuts use `Ctrl` (shown as `^` in the status bar at the bottom).

| Shortcut | Action |
|----------|--------|
| `Ctrl+S` | Save the file |
| `Ctrl+X` | Exit (will prompt to save if there are unsaved changes) |
| `Ctrl+W` | Search (Where is) |
| `Ctrl+R` | Replace |
| `Ctrl+G` | Help |
| `Ctrl+K` | Cut the current line |
| `Ctrl+U` | Paste the cut line |
| `Ctrl+/` | Go to a specific line number |

---

## Composite Example

Editing the SSH server config to change the port and enable password authentication:

```bash
sudo nano /etc/ssh/sshd_config
```

Inside nano, use `Ctrl+W` to search for `Port`. Find the line:

```
#Port 22
```

Edit it to:

```
Port 2222
```

Then search for `PasswordAuthentication` and change:

```
#PasswordAuthentication yes
```

to:

```
PasswordAuthentication yes
```

Save with `Ctrl+S`, exit with `Ctrl+X`, then apply the changes:

```bash
sudo systemctl restart sshd
sudo systemctl status sshd
```

---

## Notes for Students

- **The `^` symbol in the status bar means `Ctrl`.** So `^X` means `Ctrl+X`. This trips everyone up the first time.
- `Ctrl+X` will ask "Save modified buffer?" if you've made changes. Press `Y` then `Enter` to save and exit, or `N` to exit without saving.
- `Ctrl+W` (search) is your friend when editing long config files. You don't need to scroll through hundreds of lines to find the setting you need.
- When editing system files in `/etc/`, you almost always need `sudo nano` — those files are owned by root. If you open without `sudo`, nano will let you edit but refuse to save.
- `nano` is great for beginners. `vim` is faster once you invest time learning it, and you'll encounter it constantly on servers (it's always installed, nano sometimes isn't). Worth learning the basics of both.
