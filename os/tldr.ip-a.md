# `ip a` Cheatsheet — Finding IP Addresses & Interfaces

## Basic Usage

```bash
ip a                   # Show all interfaces and their addresses
ip addr                # Same (long form)
ip address             # Same (longest form)
```

---

## Show a Specific Interface

```bash
ip a show eth0         # Show only eth0
ip a show dev eth0     # Same, explicit 'dev' keyword
ip a show wlan0        # Show only wlan0 (Wi-Fi)
ip a show lo           # Show loopback only
```

---

## Filter by Address Family

```bash
ip -4 a                # IPv4 addresses only
ip -6 a                # IPv6 addresses only
```

---

## Reading the Output

```
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 ...
    link/ether 52:54:00:ab:cd:ef brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.42/24 brd 192.168.1.255 scope global eth0
    inet6 fe80::5054:ff:feab:cdef/64 scope link
```

| Field | Meaning |
|---|---|
| `eth0`, `wlan0`, `lo` | Interface name |
| `UP` / `DOWN` | Interface is active / inactive |
| `link/ether` | MAC address |
| `inet` | IPv4 address |
| `inet6` | IPv6 address |
| `/24`, `/64` | Subnet prefix length (CIDR) |
| `scope global` | Routable address (the one you usually want) |
| `scope link` | Link-local only, not routable |

---

## Common Interface Names

| Name | Typically |
|---|---|
| `lo` | Loopback (`127.0.0.1`) — ignore for networking |
| `eth0`, `ens3`, `enp2s0` | Wired Ethernet |
| `wlan0`, `wlp3s0` | Wi-Fi |
| `docker0`, `virbr0` | Virtual/bridge interfaces |
| `tun0`, `vpn0` | VPN tunnels |

---

## Quick One-Liners

```bash
# Just the IPv4 address of eth0
ip -4 a show eth0 | grep -oP '(?<=inet )\S+'

# All IPv4 addresses (excluding loopback)
ip -4 a | grep inet | grep -v 127.0.0.1 | awk '{print $2}'

# All interface names
ip a | grep '^\d' | awk '{print $2}' | tr -d ':'

# Only UP interfaces with addresses
ip a | grep -A2 'state UP'
```

---

## Tips

- **Multiple addresses on one interface** are normal — you'll see both an IPv4 (`inet`) and IPv6 (`inet6`) address.
- **Link-local IPv6** (`fe80::...`) is auto-assigned and not useful for general connectivity.
- If an interface shows no `inet` line, it has no IP assigned (may be down or unconfigured).
- `ip a` supersedes the old `ifconfig` command — prefer it on modern Linux.