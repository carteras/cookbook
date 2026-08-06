# Router-on-a-Stick VLAN with DHCP — Cognitive Task Analysis

> Thinking scaffold for a student who needs to understand *why* each piece exists, not just what commands to type.

---

## Goal

| Overall Goal |
|---|
| Configure a switch and router so that two VLANs are isolated at Layer 2, can reach each other through the router at Layer 3, and receive IP addresses automatically via DHCP from the router. |

---

## Subgoals

| **Subgoal 1** | **Subgoal 2** | **Subgoal 3** | **Subgoal 4** |
|---|---|---|---|
| **Isolate the VLANs on the switch** | **Connect the switch to the router** | **Give the router a presence in each VLAN** | **Serve DHCP from the router** |
| Create VLANs and assign PC ports as access ports. Each PC belongs to exactly one VLAN. | Configure the uplink port as a trunk so both VLANs can travel to the router over one cable. | Create a subinterface per VLAN, each with its own IP — this becomes the default gateway for that VLAN. | Define a DHCP pool per VLAN so PCs get an IP, gateway, and DNS automatically. |

---

## Decisions

| # | Question | Answer |
|---|---|---|
| 1 | Why does the router need subinterfaces instead of separate physical ports? | There is only one cable between the switch and router (the "stick"). Subinterfaces let one physical port handle multiple VLANs by reading the 802.1Q tag on each incoming frame. |
| 2 | What does `encapsulation dot1Q 10` actually do? | It tells that subinterface: "only process frames that arrive tagged with VLAN ID 10." Without it, the subinterface has no idea which VLAN it belongs to and the router ignores the traffic. |
| 3 | Why do I need `switchport trunk allowed vlan 10,20`? | By default a trunk carries all VLANs. Restricting it to `10,20` is best practice — it prevents unintended VLANs from leaking across the link and makes troubleshooting easier. |
| 4 | Why must `no shutdown` be run on the physical interface first? | Subinterfaces inherit their link state from the parent physical interface. If `Gi0/0/0` is shut down, all subinterfaces are also down — regardless of their own config. |
| 5 | Why does `ip dhcp excluded-address` come before the pool? | IOS processes exclusions at lease time. If you define the pool first and the exclusion second, there is a brief window where the gateway IP could be handed out to a client. Always exclude first. |
| 6 | What is the "native VLAN" and do I need to worry about it? | The native VLAN is the one VLAN whose frames travel untagged over a trunk (default: VLAN 1). In this setup it is unused, but mismatched native VLANs between the switch and router can cause unexpected behaviour. Leave it as VLAN 1 on both sides. |

---

## Reading the Key Commands

### `switchport trunk allowed vlan 10,20`

| Part | What It Tells You |
|---|---|
| `switchport` | This is a Layer 2 switching command |
| `trunk` | Applies to the trunk mode of this port |
| `allowed vlan` | Sets the whitelist of permitted VLANs |
| `10,20` | Only VLAN 10 and VLAN 20 frames are permitted — all others are dropped at this port |

### `encapsulation dot1Q 10`

| Part | What It Tells You |
|---|---|
| `encapsulation` | Defines how this subinterface interprets incoming frames |
| `dot1Q` | Uses the IEEE 802.1Q standard for VLAN tagging |
| `10` | This subinterface only processes frames tagged with VLAN ID 10 |

### `ip dhcp pool VLAN_TOP` block

| Line | What It Tells You |
|---|---|
| `network 10.13.36.0 255.255.255.0` | The subnet this pool serves — defines the range of possible IPs |
| `default-router 10.13.36.1` | The gateway IP pushed to every client — must match the subinterface IP |
| `dns-server 8.8.8.8` | The DNS server pushed to every client |

---

## Actions — In Order

### Switch

| Step | Action | Detail |
|---|---|---|
| 01 | Enter privileged exec mode | `enable` |
| 02 | Enter global config | `configure terminal` |
| 03 | Create VLAN 10 | `vlan 10` → `name VLAN_TOP` |
| 04 | Create VLAN 20 | `vlan 20` → `name VLAN_BOTTOM` |
| 05 | Assign Fa0/1 to VLAN 10 | `interface Fa0/1` → `switchport mode access` → `switchport access vlan 10` |
| 06 | Assign Fa0/24 to VLAN 20 | `interface Fa0/24` → `switchport mode access` → `switchport access vlan 20` |
| 07 | Configure trunk to router | `interface GigabitEthernet0/1` → `switchport mode trunk` → `switchport trunk allowed vlan 10,20` |
| 08 | Save | `end` → `write memory` |
| 09 | Verify VLANs | `show vlan brief` |
| 10 | Verify trunk | `show interfaces trunk` |

### Router

| Step | Action | Detail |
|---|---|---|
| 11 | Bring up physical interface | `interface GigabitEthernet0/0/0` → `no shutdown` |
| 12 | Create VLAN 10 subinterface | `interface GigabitEthernet0/0/0.10` → `encapsulation dot1Q 10` → `ip address 10.13.36.1 255.255.255.0` → `no shutdown` |
| 13 | Create VLAN 20 subinterface | `interface GigabitEthernet0/0/0.20` → `encapsulation dot1Q 20` → `ip address 10.13.37.1 255.255.255.0` → `no shutdown` |
| 14 | Exclude gateway IPs from DHCP | `ip dhcp excluded-address 10.13.36.1 10.13.36.50` then `ip dhcp excluded-address 10.13.37.1 10.13.37.50` |
| 15 | Create DHCP pool for VLAN 10 | `ip dhcp pool VLAN_TOP` → `network` → `default-router` → `dns-server` |
| 16 | Create DHCP pool for VLAN 20 | `ip dhcp pool VLAN_BOTTOM` → `network` → `default-router` → `dns-server` |
| 17 | Save | `end` → `write memory` |
| 18 | Verify subinterfaces | `show ip interface brief` |
| 19 | Verify DHCP leases | `show ip dhcp binding` |

### PCs

| Step | Action | Detail |
|---|---|---|
| 20 | Set PC0 to DHCP | Desktop → IP Configuration → DHCP — expect IP in 10.13.36.51+ range |
| 21 | Set PC1 to DHCP | Desktop → IP Configuration → DHCP — expect IP in 10.13.37.51+ range |
| 22 | Test within VLAN_TOP | Ping `10.13.36.1` from PC0 — expect **success** |
| 23 | Test within VLAN_BOTTOM | Ping `10.13.37.1` from PC1 — expect **success** |
| 24 | Test cross-VLAN | Ping PC1's IP from PC0 — expect **success** (routed through router) |

---

## Traffic Flow Mental Model

### Within a VLAN (no routing needed)

| Stage | What Happens |
|---|---|
| PC0 sends frame | Frame is untagged, enters Fa0/1 |
| Switch checks VLAN | Fa0/1 is in VLAN 10 — frame stays in VLAN 10 |
| Switch forwards | Only to other VLAN 10 ports — never to VLAN 20 |

### Cross-VLAN (routing required)

| Stage | What Happens |
|---|---|
| PC0 sends frame to PC1's IP | Destination is in a different subnet — PC0 sends to its gateway (10.13.36.1) |
| Switch tags frame | Frame exits Gi0/1 tagged as VLAN 10 |
| Router subinterface receives | `Gi0/0/0.10` matches the VLAN 10 tag via `encapsulation dot1Q 10` |
| Router makes routing decision | Destination 10.13.37.x → route out `Gi0/0/0.20` |
| Router sends frame | Frame exits tagged as VLAN 20 |
| Switch receives on trunk | Strips tag, forwards untagged to Fa0/24 (VLAN 20) |
| PC1 receives | Frame arrives untagged at PC1 |

---

## Access Port vs Trunk Port vs Subinterface Mental Model

| Concept | What It Is | What It Does |
|---|---|---|
| Access port | A switch port carrying one VLAN | Connects end devices; frames are untagged |
| Trunk port | A switch port carrying many VLANs | Connects to router or other switch; frames are 802.1Q tagged |
| `trunk allowed vlan` | A whitelist on the trunk | Only listed VLANs are permitted across the link |
| Subinterface | A logical division of a physical router port | Each one represents the router's presence in one VLAN |
| `encapsulation dot1Q` | The binding between a subinterface and a VLAN tag | Without this the router cannot distinguish which VLAN a frame belongs to |
| `no shutdown` (physical) | Brings the parent interface up | Must come first — subinterfaces are down if the parent is down |

---

## Common Errors

| ⚠️ Error | ✅ Correction |
|---|---|
| `show interfaces trunk` is empty | Physical link is down — run `no shutdown` on the router's physical `Gi0/0/0` |
| `Operational Mode: down` on switch trunk | Router interface is shut — fix on the router, not the switch |
| PC not getting DHCP address | Check `show ip dhcp binding`; check trunk is up; check `encapsulation dot1Q` is set correctly |
| Ping across VLANs fails | Check `show ip interface brief` on router — both subinterfaces must show `up/up` |
| Router handing out gateway IP to a client | `excluded-address` was not set before the pool — redo exclusions and clear bindings with `clear ip dhcp binding *` |
| Wrong IP range on DHCP clients | `network` statement in pool doesn't match the subinterface subnet |
| ✅ Rule of thumb | Always fix from the bottom up: physical link first, then trunk, then subinterfaces, then DHCP. If the physical link is down, nothing above it will work. |