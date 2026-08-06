# Cisco 2960 VLAN Separation — Cognitive Task Analysis

> Thinking scaffold for a student who needs to understand *why* VLANs separate traffic, not just *how* to configure them.

---

## Goal

| Overall Goal |
|---|
| Assign switch ports to separate VLANs so that two groups of PCs with overlapping IP addresses cannot communicate with each other, proving Layer 2 isolation. |

---

## Subgoals

| **Subgoal 1** | **Subgoal 2** | **Subgoal 3** |
|---|---|---|
| **Create the VLANs** | **Assign ports to VLANs** | **Prove isolation** |
| The switch needs named VLANs in its database before ports can join them. VLAN 1 is the default — every port starts here. | Each port carrying a PC must be explicitly placed into the correct VLAN. Access mode locks the port to one VLAN only. | Ping tests within and across VLANs confirm that same-VLAN traffic flows and cross-VLAN traffic is silently dropped. |

---

## Decisions

| # | Question | Answer |
|---|---|---|
| 1 | Which VLAN IDs should I use? | Any unused ID from 2–1001. VLAN 1 is the default and best avoided for user traffic. Use 10 for VLAN_TOP and 20 for VLAN_BOTTOM. |
| 2 | Should the ports be access or trunk? | Access. These ports connect to end devices (PCs), not to other switches or routers. Each port should carry exactly one VLAN. |
| 3 | Do I need a router? | Not for this task. The goal is to prove isolation, so no inter-VLAN routing is desired. Leaving the gateway blank on the PCs enforces this. |
| 4 | Why can both VLANs share 192.168.1.1 and 192.168.1.2? | Each VLAN is an independent broadcast domain. ARP requests from VLAN 10 never reach VLAN 20, so both can use the same address space without conflict. |
| 5 | How do I confirm the configuration worked? | Run `show vlan brief` on the switch and perform ping tests from each PC. |

---

## Reading the `show vlan brief` Output

| Field | What It Tells You |
|---|---|
| VLAN number (e.g. `10`) | The VLAN ID you created |
| Name (e.g. `VLAN_TOP`) | The human-readable label assigned with `name` |
| Status: `active` | The VLAN exists and is operational |
| Ports column (e.g. `Fa0/1, Fa0/2`) | Which physical ports belong to this VLAN — this is your confirmation |
| VLAN 1 with remaining ports | Any port not explicitly assigned stays in the default VLAN |

---

## Actions — In Order

| Step | Action | Detail |
|---|---|---|
| 01 | Enter privileged exec mode | `enable` |
| 02 | Enter global configuration mode | `configure terminal` |
| 03 | Create VLAN 10 and name it | `vlan 10` → `name VLAN_TOP` |
| 04 | Create VLAN 20 and name it | `vlan 20` → `name VLAN_BOTTOM` |
| 05 | Configure Fa0/1 for VLAN_TOP | `interface Fa0/1` → `switchport mode access` → `switchport access vlan 10` |
| 06 | Configure Fa0/2 for VLAN_TOP | Same commands as step 05, VLAN 10 |
| 07 | Configure Fa0/23 for VLAN_BOTTOM | `interface Fa0/23` → `switchport mode access` → `switchport access vlan 20` |
| 08 | Configure Fa0/24 for VLAN_BOTTOM | Same commands as step 07, VLAN 20 |
| 09 | Exit and save | `end` → `write memory` |
| 10 | Verify on switch | `show vlan brief` |
| 11 | Test within VLAN_TOP | Ping from PC0 (192.168.1.1) to C1 (192.168.1.2) — expect **success** |
| 12 | Test within VLAN_BOTTOM | Ping from PC2 (192.168.1.1) to PC3 (192.168.1.2) — expect **success** |
| 13 | Test across VLANs | Ping from PC0 to PC2's IP — expect **failure** |

---

## The Full Verification Result

```
VLAN  Name          Status    Ports
----  ------------- --------- ---------------------------
1     default       active    Fa0/3 ... Fa0/22
10    VLAN_TOP      active    Fa0/1, Fa0/2
20    VLAN_BOTTOM   active    Fa0/23, Fa0/24
```

---

## Access Port vs Trunk Port Mental Model

| Access Port Thinking | Trunk Port Thinking |
|---|---|
| "This port belongs to exactly one VLAN" | "This port carries many VLANs simultaneously" |
| Used for PCs and end devices | Used for switch-to-switch or switch-to-router links |
| Frame leaves the port **untagged** | Frame is **802.1Q tagged** with VLAN ID |
| Wrong VLAN = device is invisible to the rest of the network | Wrong allowed VLAN list = traffic silently dropped across the link |
| `switchport mode access` | `switchport mode trunk` |

---

## Common Errors

| ⚠️ Error | ✅ Correction |
|---|---|
| Port still shows in VLAN 1 on `show vlan brief` | You likely only ran `switchport mode access` without `switchport access vlan <id>` |
| Ping within same VLAN fails | Check PC IP and subnet mask — both PCs must be on the same subnet (e.g. 192.168.1.0/24) |
| Cross-VLAN ping unexpectedly succeeds | Port may still be in VLAN 1 (default) — verify with `show vlan brief` |
| VLAN doesn't appear in `show vlan brief` | You must explicitly create it with `vlan <id>` in config mode |
| Config missing after reload | You forgot `write memory` — always save after changes |
| ✅ Rule of thumb | If in doubt, run `show vlan brief` first. The ports column is the ground truth for what VLAN each port is actually in. |