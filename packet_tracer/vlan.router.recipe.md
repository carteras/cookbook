# Router-on-a-Stick VLAN with DHCP — Recipe

*A conceptual and practical guide to inter-VLAN routing and DHCP using a Cisco 2960 switch and ISR4331 router in Cisco Packet Tracer.*

---

## Introduction

In the previous VLAN tutorial, two groups of PCs were isolated from each other — that was the goal. But in most real networks, VLANs need to be able to talk to each other under controlled conditions. The way to do this without buying a Layer 3 switch is called **Router-on-a-Stick (ROAS)**: a single cable connects the switch to a router, and the router handles all inter-VLAN traffic by routing packets from one VLAN's subnet to another.

This document covers everything needed to make that work: configuring the switch trunk port, understanding 802.1Q tagging, creating router subinterfaces, binding them to VLANs with `encapsulation dot1Q`, and setting up the router as a DHCP server for both VLANs. It is written for Cisco Packet Tracer using a 2960 switch and ISR4331 router, but the concepts apply equally to real hardware.

The official Cisco reference for inter-VLAN routing is available at the [Cisco Inter-VLAN Routing Configuration Guide](https://www.cisco.com/c/en/us/support/docs/lan-switching/inter-vlan-routing/14976-50.html).

---

## How Router-on-a-Stick Thinks

Without a router, VLAN 10 and VLAN 20 can never communicate — the switch enforces that boundary. The router's job is to sit above that boundary: it has one logical "foot" in each VLAN (via subinterfaces), and when a packet from VLAN 10 needs to reach VLAN 20, the router receives it, makes a routing decision, and sends it back out tagged for VLAN 20.

The "stick" is the single trunk link between the switch and the router. Every frame that crosses it is tagged with its VLAN ID using 802.1Q. The router reads that tag, decides which subinterface should handle it, processes the packet, and sends it back — tagged for the destination VLAN.

```
PC0 (VLAN 10)                          PC1 (VLAN 20)
     │                                       │
     │ untagged                   untagged   │
     ▼                                       ▼
  Fa0/1                                   Fa0/24
  [Switch]──────────────────────────────[Switch]
          │                           │
          │  trunk (802.1Q tagged)    │
          │  VLAN 10 ──────────────►  │
          │  VLAN 20 ◄──────────────  │
          ▼                           ▲
       Gi0/1                       Gi0/1
       [Switch trunk port]
          │
          │ 802.1Q tagged frames
          ▼
       Gi0/0/0 (physical - must be no shutdown)
          │
          ├── Gi0/0/0.10  (encapsulation dot1Q 10)
          │   IP: 10.13.36.1  ← gateway for VLAN 10
          │
          └── Gi0/0/0.20  (encapsulation dot1Q 20)
              IP: 10.13.37.1  ← gateway for VLAN 20
            [Router0]
```

---

## Understanding Trunk Ports

An **access port** carries traffic for exactly one VLAN. The frames are untagged — the connected PC has no awareness of VLANs at all. This is correct for any port connected to an end device.

A **trunk port** carries traffic for multiple VLANs simultaneously. To keep them separate, each frame is wrapped with an **802.1Q tag** — a small header inserted into the Ethernet frame that contains the VLAN ID. When the frame arrives at the other end (the router in this case), the tag is read and the frame is directed to the correct subinterface.

The command `switchport mode trunk` forces the port into trunk mode. Without it, the port might try to auto-negotiate its mode via DTP (Dynamic Trunking Protocol), which is unreliable and a security risk.

### `switchport trunk allowed vlan`

By default, a trunk port carries **all VLANs** that exist on the switch. This is often more than you want. The `switchport trunk allowed vlan 10,20` command creates a whitelist — only VLAN 10 and VLAN 20 frames are permitted across this trunk. Any other VLAN is silently dropped at the trunk port.

This matters for two reasons:

1. **Security** — VLANs you didn't intend to expose won't leak across the link.
2. **Troubleshooting** — it is much easier to diagnose a trunk when you know exactly which VLANs should be on it.

```
# Trunk carrying all VLANs (default — avoid)
interface GigabitEthernet0/1
 switchport mode trunk

# Trunk restricted to only VLAN 10 and 20 (correct)
interface GigabitEthernet0/1
 switchport mode trunk
 switchport trunk allowed vlan 10,20
```

| `show interfaces trunk` field | What It Tells You |
|---|---|
| `Mode: on` | Port is statically set to trunk (good — not relying on DTP) |
| `Encapsulation: 802.1q` | Using the standard 802.1Q tagging |
| `Status: trunking` | Physical link is up and trunk is active |
| `VLANs allowed and active` | The VLANs actually passing over this trunk right now |

---

## Understanding `encapsulation dot1Q`

On the router, a single physical interface (`GigabitEthernet0/0/0`) receives frames tagged for multiple VLANs. The router needs a way to sort those frames — that is what subinterfaces are for.

A **subinterface** is a logical subdivision of a physical interface. You can create as many as you need. Each one is bound to a specific VLAN tag using `encapsulation dot1Q <vlan-id>`. When a frame arrives tagged with VLAN 10, the router delivers it to the subinterface configured with `encapsulation dot1Q 10`. Every other subinterface ignores it.

```
# Without encapsulation — router has no idea which VLAN this subinterface belongs to
interface GigabitEthernet0/0/0.10
 ip address 10.13.36.1 255.255.255.0   ← won't work correctly

# With encapsulation — router matches VLAN 10 tagged frames to this subinterface
interface GigabitEthernet0/0/0.10
 encapsulation dot1Q 10
 ip address 10.13.36.1 255.255.255.0   ← correct
```

The number after `dot1Q` **must exactly match** the VLAN ID configured on the switch. A mismatch means frames are silently dropped — one of the most common sources of confusion in this setup.

| Subinterface | `encapsulation dot1Q` | IP Address | Role |
|---|---|---|---|
| `Gi0/0/0.10` | `dot1Q 10` | `10.13.36.1` | Gateway for VLAN_TOP |
| `Gi0/0/0.20` | `dot1Q 20` | `10.13.37.1` | Gateway for VLAN_BOTTOM |

### Why the physical interface must be `no shutdown` first

Subinterfaces do not have their own independent physical link state. They inherit it from the parent interface. If `GigabitEthernet0/0/0` is shut down, every subinterface under it is also down — even if those subinterfaces are individually configured with `no shutdown`. Always bring the physical interface up first.

```
# Always do this first
interface GigabitEthernet0/0/0
 no shutdown

# Then configure subinterfaces
interface GigabitEthernet0/0/0.10
 encapsulation dot1Q 10
 ip address 10.13.36.1 255.255.255.0
 no shutdown
```

---

## Understanding DHCP on the Router

The router acts as the DHCP server for both VLANs. Because it has a subinterface in each VLAN, it can receive DHCP discovery broadcasts from clients in both subnets directly — no DHCP relay is needed in this topology.

### `ip dhcp excluded-address`

This command tells the router to never hand out certain IP addresses as DHCP leases. You must exclude at minimum the gateway IP itself — otherwise the router might offer it to a client, which would break routing for the entire VLAN.

The exclusion must be configured **before** the pool. Always exclude the full range of static IPs you plan to use (servers, gateways, printers, etc.).

```
# Exclude IPs .1 through .50 — DHCP leases start at .51
ip dhcp excluded-address 10.13.36.1 10.13.36.50
ip dhcp excluded-address 10.13.37.1 10.13.37.50
```

### The DHCP Pool

```
ip dhcp pool VLAN_TOP
 network 10.13.36.0 255.255.255.0
 default-router 10.13.36.1
 dns-server 8.8.8.8
```

| Line | Purpose |
|---|---|
| `network` | The subnet this pool serves. Defines the full range of possible IPs before exclusions. |
| `default-router` | The gateway IP pushed to every client. Must match the subinterface IP exactly. |
| `dns-server` | The DNS resolver pushed to every client. |

---

## Recipes

### Create VLANs on the Switch

```
enable
configure terminal

vlan 10
 name VLAN_TOP

vlan 20
 name VLAN_BOTTOM
```

### Assign PC Ports as Access Ports

```
interface FastEthernet0/1
 switchport mode access
 switchport access vlan 10

interface FastEthernet0/24
 switchport mode access
 switchport access vlan 20
```

### Configure the Trunk Port to the Router

```
interface GigabitEthernet0/1
 switchport mode trunk
 switchport trunk allowed vlan 10,20

end
write memory
```

### Bring Up the Router Physical Interface

```
enable
configure terminal

interface GigabitEthernet0/0/0
 no shutdown
```

### Create Router Subinterfaces

```
interface GigabitEthernet0/0/0.10
 encapsulation dot1Q 10
 ip address 10.13.36.1 255.255.255.0
 no shutdown

interface GigabitEthernet0/0/0.20
 encapsulation dot1Q 20
 ip address 10.13.37.1 255.255.255.0
 no shutdown
```

### Configure DHCP Pools

```
ip dhcp excluded-address 10.13.36.1 10.13.36.50
ip dhcp pool VLAN_TOP
 network 10.13.36.0 255.255.255.0
 default-router 10.13.36.1
 dns-server 8.8.8.8

ip dhcp excluded-address 10.13.37.1 10.13.37.50
ip dhcp pool VLAN_BOTTOM
 network 10.13.37.0 255.255.255.0
 default-router 10.13.37.1
 dns-server 8.8.8.8

end
write memory
```

### Verify Everything

```
# On the switch
show vlan brief
show interfaces trunk

# On the router
show ip interface brief
show ip dhcp binding
show ip route
```

### Clear DHCP Bindings (if re-testing)

```
clear ip dhcp binding *
```

---

## Reading an Unknown Configuration

| What You Need | Where to Get It |
|---|---|
| Which VLANs exist on the switch | `show vlan brief` |
| Whether the trunk is active | `show interfaces trunk` |
| Which VLANs are allowed on the trunk | `show interfaces GigabitEthernet0/1 switchport` |
| Whether subinterfaces are up | `show ip interface brief` on router |
| What VLAN tag a subinterface uses | `show interfaces GigabitEthernet0/0/0.10` |
| Who has received a DHCP lease | `show ip dhcp binding` on router |
| Whether the router can reach both subnets | `show ip route` on router |

---

## What Can Go Wrong

| Symptom | Likely Cause |
|---|---|
| `show interfaces trunk` is empty | Physical link between switch and router is down — `no shutdown` the router's physical interface |
| `Operational Mode: down` on switch trunk port | Router's `Gi0/0/0` is shutdown — fix on the router |
| PC not receiving DHCP address | Trunk is down, or `encapsulation dot1Q` is missing/wrong on the subinterface |
| Ping to gateway fails from PC | PC didn't get a DHCP address, or the subinterface IP doesn't match the `default-router` in the pool |
| Ping across VLANs fails | Check `show ip interface brief` — both subinterfaces must be `up/up` |
| Router handed out the gateway IP | `excluded-address` was missing or set after the pool — clear bindings and redo |
| DHCP clients get wrong subnet | `network` statement in pool doesn't match the subinterface subnet |
| Subinterfaces show `up/down` | Physical interface is still shut — run `no shutdown` on `Gi0/0/0` |

---

## Further Reading

- [Cisco Inter-VLAN Routing Configuration Guide](https://www.cisco.com/c/en/us/support/docs/lan-switching/inter-vlan-routing/14976-50.html)
- [Cisco DHCP Configuration Guide (IOS)](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/ipaddr_dhcp/configuration/15-sy/dhcp-15-sy-book/config-dhcp-server.html)
- [802.1Q VLAN Tagging Explained — Cisco](https://www.cisco.com/c/en/us/support/docs/lan-switching/8021q/17056-741-4.html)
- [Catalyst 2960 Software Configuration Guide](https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst2960/software/release/15-0_2_se/configuration/guide/scg2960.html)
- [Packet Tracer Download — Cisco NetAcad](https://www.netacad.com/courses/packet-tracer)