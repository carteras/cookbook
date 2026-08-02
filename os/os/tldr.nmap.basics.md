# `nmap` Cheatsheet — Port Scanning & Subnet Discovery

## Scan Ports 1–10,000 on a Local Machine

```bash
nmap -p 1-10000 localhost          # Scan ports 1–10000 (TCP, SYN scan if root)
nmap -p 1-10000 -T4 localhost      # Faster scan (aggressive timing)
nmap -p 1-10000 -sV localhost      # Also detect service/version on open ports
nmap -p 1-10000 -sU localhost      # UDP ports (slow, run as root)
nmap -p 1-10000 -sS localhost      # SYN "stealth" scan (requires root)
nmap -p 1-10000 -sT localhost      # Full TCP connect scan (no root needed)
```


```bash
nmap -p 1-10000 10.13.37.21          # Scan ports 1–10000 (TCP, SYN scan if root)
nmap -p 1-10000 -T4 10.13.37.21      # Faster scan (aggressive timing)
nmap -p 1-10000 -sV 10.13.37.21      # Also detect service/version on open ports
nmap -p 1-10000 -sU 10.13.37.21      # UDP ports (slow, run as root)
nmap -p 1-10000 -sS 10.13.37.21      # SYN "stealth" scan (requires root)
nmap -p 1-10000 -sT 10.13.37.21      # Full TCP connect scan (no root needed)
```

### Useful flags to add

| Flag | Effect |
|---|---|
| `-T1` to `-T5` | Timing: 1=slow/stealthy, 4=fast, 5=aggressive |
| `-sV` | Detect service versions on open ports |
| `-O` | OS detection (requires root) |
| `-v` | Verbose — shows results as they come in |
| `--open` | Only show open ports (hides filtered/closed) |
| `-oN out.txt` | Save results to a file |

---

## Find All IP Addresses on a /24 Subnet

```bash
nmap -sn 192.168.1.0/24               # Ping sweep — find live hosts, no port scan
nmap -sn 192.168.1.0/24 --open        # Same, only show responding hosts
nmap -sn -T4 192.168.1.0/24           # Faster ping sweep
```

> `-sn` = "scan no ports" — just discovers which hosts are up.

### Get a clean list of live IPs

```bash
nmap -sn 192.168.1.0/24 | grep 'Nmap scan report' | awk '{print $NF}'
```

### Also get hostnames and MAC addresses

```bash
sudo nmap -sn 192.168.1.0/24          # Root gives you MAC addresses too
```

Output includes:
```
Nmap scan report for router.local (192.168.1.1)
Host is up (0.0034s latency).
MAC Address: AA:BB:CC:DD:EE:FF (Vendor Name)
```

---

## Find Critical Ports Across a /24 Network

### Common critical ports only (fast)

```bash
nmap -p 22,23,25,53,80,110,139,143,443,445,3306,3389,5900,8080 192.168.1.0/24
```

### Top 100 most common ports

```bash
nmap --top-ports 100 192.168.1.0/24
```

### Top 1000 most common ports (nmap default)

```bash
nmap 192.168.1.0/24
```

### With service detection — good for auditing

```bash
nmap -sV --top-ports 100 -T4 192.168.1.0/24
```

---

## Critical Ports Reference

| Port | Service | Why it matters |
|---|---|---|
| 22 | SSH | Remote access |
| 23 | Telnet | Remote access, unencrypted — bad sign |
| 25 | SMTP | Mail server |
| 53 | DNS | Name resolution |
| 80 | HTTP | Web server |
| 443 | HTTPS | Secure web server |
| 139/445 | SMB | Windows file sharing — ransomware target |
| 3306 | MySQL | Database |
| 3389 | RDP | Windows remote desktop |
| 5900 | VNC | Remote desktop, often unencrypted |
| 8080 | HTTP-alt | Web apps, admin panels |

---

## Putting It Together — Typical Workflow

```bash
# Step 1: find live hosts
nmap -sn -T4 192.168.1.0/24

# Step 2: scan a specific live host thoroughly
nmap -p 1-10000 -sV -T4 192.168.1.42

# Step 3: sweep the whole subnet for critical ports
nmap -p 22,23,80,443,445,3389,5900 -T4 --open 192.168.1.0/24
```

---

## Tips

- Run as **root/sudo** for best results — unprivileged scans fall back to slower TCP connect scans and miss MAC addresses.
- `-T4` is a good default; use `-T2` if you're worried about triggering IDS/firewalls.
- A `/24` subnet has 254 usable hosts — a full port scan of all of them takes a while; use `--top-ports` or a targeted port list for speed.
- **Only scan networks you own or have permission to scan.**