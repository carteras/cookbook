# Cisco 2960 VLAN Separation — Cheatsheet

> Quick-reference for configuring and verifying VLAN separation on a Cisco 2960 switch.

---

## The Commands

```
enable
configure terminal

vlan 10
 name VLAN_TOP
vlan 20
 name VLAN_BOTTOM

interface FastEthernet0/1
 switchport mode access
 switchport access vlan 10
interface FastEthernet0/2
 switchport mode access
 switchport access vlan 10

interface FastEthernet0/23
 switchport mode access
 switchport access vlan 20
interface FastEthernet0/24
 switchport mode access
 switchport access vlan 20

end
write memory
```

---

## Breaking Down the Commands

| Command | Meaning | Example |
|---|---|---|
| `vlan <id>` | Creates a VLAN in the database | `vlan 10` |
| `name <string>` | Assigns a human-readable name to the VLAN | `name VLAN_TOP` |
| `switchport mode access` | Forces port to carry exactly one VLAN, no trunking | `switchport mode access` |
| `switchport access vlan <id>` | Assigns the port to a specific VLAN | `switchport access vlan 10` |
| `show vlan brief` | Displays VLAN-to-port mapping summary | `show vlan brief` |
| `write memory` | Saves running config to NVRAM | `write memory` |

---

## Access Port vs Trunk Port

| Property | Access Port | Trunk Port |
|---|---|---|
| VLANs carried | One | Many |
| Tagging | None (untagged) | 802.1Q tagged |
| Typical use | End device (PC, printer) | Switch-to-switch, switch-to-router |
| Command | `switchport mode access` | `switchport mode trunk` |
| VLAN assigned by | `switchport access vlan <id>` | `switchport trunk allowed vlan <list>` |

---

## What Each Stage Produces

| Stage | Output | What It Means |
|---|---|---|
| `vlan 10` / `vlan 20` | VLAN entries in VLAN database | VLANs exist but have no ports yet |
| `switchport mode access` | Port locked to access mode | Port will not negotiate trunking |
| `switchport access vlan 10` | Port membership assigned | Port's frames belong to VLAN 10 |
| `show vlan brief` | Table of VLANs and their ports | Confirms correct port-to-VLAN mapping |
| `write memory` | Saved startup-config | Config survives reboot |

---

## Common Variations

| Goal | What to Change |
|---|---|
| Use different VLAN IDs | Replace `10` / `20` with any valid ID (2–1001) |
| Add more PCs to VLAN_TOP | Repeat `switchport` commands on additional interfaces |
| Rename a VLAN | Re-enter `vlan <id>` then `name <new-name>` |
| Verify a single port's VLAN | `show interfaces FastEthernet0/1 switchport` |
| Remove a port from a VLAN | `no switchport access vlan` (returns to VLAN 1) |
| Delete a VLAN entirely | `no vlan 10` in global config mode |

---

## Gotchas

| ⚠️ Pitfall | ✅ Fix |
|---|---|
| Port stays in VLAN 1 after assignment | Confirm with `show vlan brief` — check you ran `switchport access vlan <id>`, not just `switchport mode access` |
| Duplicate IPs don't cause errors | Intentional — each VLAN is an isolated broadcast domain; duplicate IPs are valid across VLANs |
| Pinging across VLANs silently fails | Expected — no router present; cross-VLAN traffic requires inter-VLAN routing |
| VLAN created but not showing on port | You must assign the port explicitly — creating a VLAN does not auto-assign any ports |
| Config lost after reboot | Always run `write memory` after making changes |
| `switchport mode access` missing | Without it, port may auto-negotiate to trunk and carry unintended VLANs |