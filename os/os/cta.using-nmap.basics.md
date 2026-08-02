# Scanning & Connecting to a Machine on Your Network

**Audience:** Someone with some Linux experience, new to networking tools
**Goal:** Scan a local machine, verify a port, connect via SSH, then discover the wider network

---

## Mental Model First

Before doing anything, the learner needs to hold this picture in their head:

```
Your PC ──── switch/router ──── other machines on the network
  │
  └── has 2 network interfaces:
        eth0 = Docker network (172.x.x.x) ← looks "internal" but it's Docker, not your LAN
        eth1 = internal LAN (192.168.x.x) ← this is the one we care about
```

> **Key concept:** Docker creates its own virtual network using `172.16–31.x.x` addresses. This can look like an internal network, but it only connects Docker containers — not your real LAN. You want the `192.168.x.x` interface instead.

---

## Task 1: Find Out Which Interface is Internal Using `ip a`

### What the learner needs to know
- A machine can have multiple network interfaces
- Each interface has an IP address and a name (`eth0`, `eth1`, etc.)
- Internal (LAN) addresses are almost always in a private range
- External addresses are public (or assigned by your ISP)

### Private IP ranges to recognise
| Range | Looks like |
|---|---|
| `10.x.x.x` | Corporate / large networks |
| `172.16–31.x.x` | Docker virtual networks ← **ignore this one** |
| `192.168.x.x` | Home / small office LAN — this is the one you want |

### What to do
```bash
ip a
```

### What to look for
```
2: eth0: ...
    inet 172.17.0.3/24        ← 172.x.x.x = Docker virtual network, ignore this

3: eth1: ...
    inet 192.168.1.10/24      ← 192.168.x.x = real LAN = internal  ✓
```

### Decision the learner must make
> "Ignore any `172.x.x.x` address — that's Docker, not your real network. The `192.168.x.x` address on `eth1` is the one to use."

---

## Task 2: Work Out the Subnet for nmap

### What the learner needs to know
- The IP address and the `/24` prefix together define the network
- `/24` means the first 3 numbers are the network; the last number is the host
- To scan the whole network, replace the last number with `0`

### The mental step
```
eth1 address:  192.168.1.10/24
                └──────┘ └──┘
                network  host

Subnet to scan: 192.168.1.0/24   ← replace host part with 0
```

### Common mistake to avoid
> Don't use the `eth0` (external) address — you'll be scanning the internet, not your local network.

---

## Task 3: Scan Your Own Machine for Port 2222

### What the learner needs to know
- nmap sends packets to ports and listens for responses
- Scanning ports 1–10000 covers almost all commonly used ports
- You need to know if port 2222 is open before trying to SSH into it

### What to do
```bash
nmap -p 1-10000 192.168.1.10
```
*(use the machine's actual IP from `ip a`)*

### What to look for in the output
```
PORT     STATE  SERVICE
22/tcp   open   ssh
2222/tcp open   EtherNetIP-1   ← this is what you want to see
```

### Decision the learner must make
> "Is `2222/tcp` listed as `open`? If yes, proceed. If not listed or `closed`, SSH on that port won't work."

---

## Task 4: SSH into the Machine on Port 2222

### What the learner needs to know
- SSH defaults to port 22; `-p` overrides that
- You need a valid username on the remote machine
- The IP is the internal address you found with `ip a`

### What to do
```bash
ssh -p 2222 username@192.168.1.10
```

### What success looks like
```
username@192.168.1.10's password:
Welcome to Ubuntu 22.04...
username@remotemachine:~$    ← you're in
```

### Common mistakes
| Mistake | What happens | Fix |
|---|---|---|
| Forgetting `-p 2222` | Connection refused or times out | Always add `-p 2222` |
| Using the wrong IP | No route to host | Double-check `ip a` output |
| Wrong username | Permission denied | Confirm the account exists on the remote machine |

---

## Task 5: Scan the Whole /24 Network for Live Hosts

### What the learner needs to know
- A `/24` network has 254 possible host addresses
- A ping sweep finds which of those are alive, without scanning ports
- This gives you a map of what's on the network

### What to do
```bash
nmap -sn 192.168.1.0/24
```

### What to look for
```
Nmap scan report for 192.168.1.1    ← router
Host is up (0.002s latency).

Nmap scan report for 192.168.1.10   ← your machine
Host is up.

Nmap scan report for 192.168.1.42   ← something else on the network
Host is up (0.008s latency).
```

### What to do next
> Once you have a list of live IPs, you can target any of them with a port scan (Task 3) to see what's running.

---

## End-to-End Sequence (Summary)

```
1.  ip a
      └─ identify eth1 as internal → note its IP (e.g. 192.168.1.10)
      └─ derive subnet: 192.168.1.0/24

2.  nmap -p 1-10000 192.168.1.10
      └─ confirm port 2222 is open

3.  ssh -p 2222 username@192.168.1.10
      └─ connect to the machine

4.  nmap -sn 192.168.1.0/24
      └─ discover all other live hosts on the network
```

---

## What Learners Often Get Wrong

- **Scanning the Docker interface (`172.x.x.x`)** — this only reaches other Docker containers, not your real LAN; always use the `192.168.x.x` address
- **Assuming port 2222 is open** — always verify with nmap first
- **Forgetting `-p 2222` in SSH** — the error message ("connection refused") can be confusing without this context
- **Not running nmap as sudo** — works without it, but you get less information (no MAC addresses, slower)