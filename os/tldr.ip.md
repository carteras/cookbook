# tldr: ip

## Description

Shows and manages network interfaces, addresses, routes, and links. The modern replacement for the older `ifconfig` command (which is no longer installed by default on Fedora). `ip a` (short for `ip address`) is the subcommand you'll reach for most — it shows all network interfaces and their IP addresses.

---

## Simple Examples

```bash
# Show all network interfaces and their IP addresses
ip a
# or the full form:
ip address show

# Show a specific interface only
ip a show enp1s0

# Show all network links (interfaces, up/down state, MAC addresses)
ip link show

# Show the routing table
ip route show

# Bring an interface up
sudo ip link set enp7s0 up

# Bring an interface down
sudo ip link set enp7s0 down

# Add an IP address to an interface manually
sudo ip address add 10.13.37.5/24 dev enp7s0
```

---

## Composite Example

Identifying network interfaces after adding a second NIC to a VM, then requesting an IP address on the new one:

```bash
ip a
```

```
1: lo: <LOOPBACK,UP,LOWER_UP>
    inet 127.0.0.1/8

2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP>
    inet 192.168.122.15/24        ← NAT interface (original)

3: enp7s0: <BROADCAST,MULTICAST,UP,LOWER_UP>
                                  ← Bridge interface (new, no IP yet)
```

```bash
sudo dhclient enp7s0
ip a show enp7s0
```

```
3: enp7s0: <BROADCAST,MULTICAST,UP,LOWER_UP>
    inet 10.13.37.42/24           ← Got an IP from DHCP
```

Note down that `10.13.37.42` — it's the address other machines on the local network will use to reach your VM.

---

## Notes for Students

- `ip a` is the first command to run when you need to know what your machine's IP address is. On a fresh VM you'll run it constantly.
- Network interface names like `enp1s0` or `enp7s0` encode the PCI bus location. `en` = ethernet, `p` = bus number, `s` = slot number. They'll differ between machines — don't assume your second card is always `enp7s0`. Always check with `ip a` first.
- `127.0.0.1` (the `lo` loopback interface) is always present — it's how the machine talks to itself. `localhost` resolves to this address.
- `inet` lines show IPv4 addresses. `inet6` lines show IPv6. For most of what we do in class, focus on `inet`.
- The number after the slash (e.g. `/24`) is the **subnet mask** in CIDR notation. `/24` means the first 24 bits identify the network — in plain terms, all devices on `10.13.37.x` are on the same local network.
