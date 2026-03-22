# tldr: dhclient

## Description

Sends a DHCP request on a network interface, asking the local DHCP server to assign it an IP address, subnet mask, gateway, and DNS servers. Used when an interface is up but has no IP address — most commonly after adding a second network card to a VM.

---

## Simple Examples

```bash
# Request an IP address on a specific interface
sudo dhclient enp7s0

# Request an IP and show verbose output (useful for debugging)
sudo dhclient -v enp7s0

# Release the current IP address back to the DHCP server
sudo dhclient -r enp7s0

# Release and immediately request a new IP
sudo dhclient -r enp7s0 && sudo dhclient enp7s0
```

---

## Composite Example

Adding a second network card to a VM, identifying it, then getting it an IP address:

```bash
# Check what interfaces exist — the new one will have no inet address
ip a
```

```
1: lo:        inet 127.0.0.1/8
2: enp1s0:    inet 192.168.122.15/24    ← original NAT card, already has IP
3: enp7s0:                              ← new bridge card, no IP yet
```

```bash
# Request an IP on the new interface
sudo dhclient enp7s0

# Verify it got one
ip a show enp7s0
```

```
3: enp7s0: <BROADCAST,MULTICAST,UP,LOWER_UP>
    inet 10.13.37.42/24    ← now has an IP from the classroom DHCP server
```

Note the address down — other machines on the `10.13.37.x` network can now reach your VM at that address.

---

## Notes for Students

- `dhclient` only lasts until reboot. To make the IP assignment permanent across reboots, you need a `systemd-networkd` config file (covered in Lesson 2). Think of `dhclient` as "get me an IP right now" and the `.network` file as "always get an IP when this card comes up."
- If `dhclient` hangs or times out, it means no DHCP server responded. Check that the bridge (`br0`) is set up correctly on the host and that the interface is actually up (`ip link show enp7s0` should say `UP`).
- `dhclient -v` (verbose) shows the full DHCP conversation — DISCOVER, OFFER, REQUEST, ACK. This is useful for understanding how DHCP works and for debugging when it doesn't.
- On modern Fedora systems, `NetworkManager` typically handles DHCP automatically. `dhclient` is the manual tool when you're managing interfaces with `systemd-networkd` instead, or when you just need to quickly refresh an address.
- The interface name (`enp7s0`) will vary. Always confirm the name with `ip a` first — using the wrong name means dhclient looks for an interface that doesn't exist and fails silently.
