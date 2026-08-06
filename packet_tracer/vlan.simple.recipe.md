# Cisco 2960 VLAN Separation — Recipe

*A conceptual and practical guide to configuring VLAN separation on a Cisco 2960 switch in Cisco Packet Tracer.*

---

## Introduction

A VLAN (Virtual Local Area Network) is a way of partitioning a single physical switch into multiple independent logical networks. Devices on different VLANs cannot communicate with each other at Layer 2 — even if they share the same IP address range — unless a router or Layer 3 device explicitly routes traffic between them.

This document covers the full process of creating two isolated VLANs on a Cisco Catalyst 2960 switch using Cisco IOS 15, assigning access ports to each VLAN, and verifying isolation through ping tests. It is written for students using Cisco Packet Tracer but applies equally to real hardware. The official Cisco reference for VLAN configuration is available at the [Cisco Catalyst 2960 Software Configuration Guide](https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst2960/software/release/15-0_2_se/configuration/guide/scg2960.html).

The scenario used throughout this document has four PCs connected to a single 2960 switch. PC0 and C1 belong to VLAN_TOP (VLAN 10); PC2 and PC3 belong to VLAN_BOTTOM (VLAN 20). Both groups deliberately share the IP addresses 192.168.1.1 and 192.168.1.2 to demonstrate that VLANs create completely separate address spaces.

---

## How the 2960 Thinks About VLANs

When a frame arrives on a switch port, the switch looks up which VLAN that port belongs to. It then only forwards the frame to other ports in the **same** VLAN. Ports in other VLANs never see the frame — not even as a dropped packet. This happens entirely at Layer 2, before any IP logic is involved.

```
PC sends frame
      │
      ▼
 Ingress Port
      │
      ▼
 Switch checks: "Which VLAN does this port belong to?"
      │
      ├── VLAN 10? ──► Forward only to other VLAN 10 ports
      │
      └── VLAN 20? ──► Forward only to other VLAN 20 ports
                              │
                              └── VLAN 10 ports never see this frame
```

The MAC address table is maintained **per VLAN**. This means the switch can have two different devices each using 192.168.1.1 — one in VLAN 10, one in VLAN 20 — and correctly keep them separate, because MAC table entries are tagged with the VLAN ID.

---

## Anatomy of the Command

Full port-assignment command sequence:

```
interface FastEthernet0/1
 switchport mode access
 switchport access vlan 10
```

| Part | Job |
|---|---|
| `interface FastEthernet0/1` | Selects the physical port to configure |
| `switchport mode access` | Locks the port to access mode — it will not negotiate trunking with anything connected to it |
| `switchport access vlan 10` | Places the port into VLAN 10's broadcast domain |

---

## Choosing VLAN IDs

On a Cisco 2960, standard-range VLANs run from **1 to 1005**. VLAN 1 is the factory default — all ports start here. It is best practice to leave VLAN 1 unused for user traffic because it cannot be deleted and has special handling in some Cisco features.

| VLAN ID Range | Type | Notes |
|---|---|---|
| 1 | Default | All ports start here; avoid for user traffic |
| 2–1001 | Standard | Normal user VLANs; stored in `vlan.dat` |
| 1002–1005 | Reserved | Legacy FDDI/Token Ring; do not use |
| 1006–4094 | Extended | Requires VTP transparent mode; not needed here |

For this scenario, VLAN 10 and VLAN 20 are good choices — they are well within the standard range, unambiguous, and easy to remember.

---

## Access Ports vs Trunk Ports

An **access port** carries traffic for exactly one VLAN. Frames leaving the port are untagged — the connected device (a PC) has no idea VLANs exist. This is the correct mode for any port connected to an end device.

A **trunk port** carries traffic for multiple VLANs simultaneously, using 802.1Q tags to label each frame with its VLAN ID. Trunk ports are used between switches, or between a switch and a router doing inter-VLAN routing.

Using `switchport mode access` is important not just for correctness but for security. Without it, a port may auto-negotiate to trunk mode via DTP (Dynamic Trunking Protocol), which could allow a connected device to access multiple VLANs unintentionally.

| Property | Access Port | Trunk Port |
|---|---|---|
| VLANs carried | One | Many |
| Frame tagging | None (untagged) | 802.1Q tagged |
| Typical device connected | PC, printer, server | Switch, router |
| Config command | `switchport mode access` | `switchport mode trunk` |
| VLAN assignment | `switchport access vlan <id>` | `switchport trunk allowed vlan <list>` |

---

## Why Duplicate IPs Work Across VLANs

In a normal (non-VLAN) network, two devices cannot share the same IP address on the same subnet — the ARP process would produce conflicts. VLANs solve this because ARP is a **broadcast** protocol, and broadcasts are contained within a single VLAN.

PC0 in VLAN 10 broadcasts an ARP request for 192.168.1.2 — only C1 (also in VLAN 10) hears it. PC2 in VLAN 20 never receives the broadcast, and vice versa. The result is two completely independent ARP tables, one per VLAN, allowing the same IP address to coexist without conflict.

---

## Recipes

### Create VLANs

```
enable
configure terminal

vlan 10
 name VLAN_TOP

vlan 20
 name VLAN_BOTTOM
```

### Assign Ports — VLAN_TOP

```
interface FastEthernet0/1
 switchport mode access
 switchport access vlan 10

interface FastEthernet0/2
 switchport mode access
 switchport access vlan 10
```

### Assign Ports — VLAN_BOTTOM

```
interface FastEthernet0/23
 switchport mode access
 switchport access vlan 20

interface FastEthernet0/24
 switchport mode access
 switchport access vlan 20
```

### Save Configuration

```
end
write memory
```

### Verify VLAN Membership

```
show vlan brief
```

### Verify a Single Port

```
show interfaces FastEthernet0/1 switchport
```

### Remove a Port from a VLAN (return to default)

```
interface FastEthernet0/1
 no switchport access vlan
```

### Delete a VLAN

```
configure terminal
no vlan 10
```

---

## Reading an Unknown Switch Configuration

If you inherit a switch and need to understand its VLAN setup:

| What You Need | Where to Get It |
|---|---|
| Which VLANs exist | `show vlan brief` |
| Which ports are in which VLAN | `show vlan brief` (ports column) |
| Whether a specific port is access or trunk | `show interfaces <port> switchport` |
| The running configuration | `show running-config` |
| MAC address table per VLAN | `show mac address-table vlan <id>` |
| Whether config is saved | Compare `show running-config` vs `show startup-config` |

---

## What Can Go Wrong

| Symptom | Likely Cause |
|---|---|
| Port still shows in VLAN 1 on `show vlan brief` | `switchport access vlan <id>` was not run, or was run before `switchport mode access` |
| Ping within the same VLAN fails | PCs have incorrect IP or subnet mask; gateway misconfigured |
| Cross-VLAN ping unexpectedly succeeds | Both ports are still in VLAN 1 (default) — VLAN assignment never applied |
| VLAN missing from `show vlan brief` | VLAN was never created with `vlan <id>` in config mode |
| Configuration lost after reboot | `write memory` was not run after changes |
| Port negotiates to trunk unexpectedly | `switchport mode access` was omitted; DTP negotiated trunk mode |
| Packet Tracer shows link as orange/amber | Port is in STP blocking state — wait a few seconds for convergence |

---

## Further Reading

- [Cisco Catalyst 2960 Software Configuration Guide (IOS 15)](https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst2960/software/release/15-0_2_se/configuration/guide/scg2960.html)
- [Cisco VLAN Configuration Guide](https://www.cisco.com/c/en/us/support/docs/lan-switching/vlan/10023-3.html)
- [802.1Q VLAN Tagging Explained — Cisco](https://www.cisco.com/c/en/us/support/docs/lan-switching/8021q/17056-741-4.html)
- [Packet Tracer Download — Cisco NetAcad](https://www.netacad.com/courses/packet-tracer)