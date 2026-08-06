# Router-on-a-Stick VLAN with DHCP — Cheatsheet

> Quick-reference for configuring inter-VLAN routing and DHCP on a Cisco 2960 switch + ISR4331 router.

---

## The Commands

### Switch

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

interface FastEthernet0/24
 switchport mode access
 switchport access vlan 20

interface GigabitEthernet0/1
 switchport mode trunk
 switchport trunk allowed vlan 10,20

end
write memory
```

### Router

```
enable
configure terminal

interface GigabitEthernet0/0/0
 no shutdown

interface GigabitEthernet0/0/0.10
 encapsulation dot1Q 10
 ip address 10.13.36.1 255.255.255.0
 no shutdown

interface GigabitEthernet0/0/0.20
 encapsulation dot1Q 20
 ip address 10.13.37.1 255.255.255.0
 no shutdown

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

---

## Breaking Down the Key Commands

| Command | Where | Meaning | Example |
|---|---|---|---|
| `switchport mode trunk` | Switch | Forces the port to carry multiple VLANs using 802.1Q tagging | `switchport mode trunk` |
| `switchport trunk allowed vlan <list>` | Switch | Restricts which VLANs are permitted over the trunk — all others are dropped | `switchport trunk allowed vlan 10,20` |
| `encapsulation dot1Q <id>` | Router | Tells the subinterface which 802.1Q VLAN tag to listen for and respond to | `encapsulation dot1Q 10` |
| `no shutdown` | Router | Brings the physical or subinterface up — **required on the physical interface first** | `no shutdown` |
| `ip dhcp excluded-address` | Router | Reserves a range of IPs so DHCP never hands them out | `ip dhcp excluded-address 10.13.36.1 10.13.36.50` |
| `network` (DHCP pool) | Router | Tells the DHCP pool which subnet to serve addresses from | `network 10.13.36.0 255.255.255.0` |
| `default-router` (DHCP pool) | Router | Sets the gateway IP sent to DHCP clients | `default-router 10.13.36.1` |

---

## Trunk vs Access Port

| Property | Access Port | Trunk Port |
|---|---|---|
| VLANs carried | One | Many |
| Frame tagging | None (untagged) | 802.1Q tagged |
| Typical use | PC, printer | Switch-to-switch, switch-to-router |
| Command | `switchport mode access` | `switchport mode trunk` |
| VLAN set by | `switchport access vlan <id>` | `switchport trunk allowed vlan <list>` |

---

## What Each Stage Produces

| Stage | Output | What It Means |
|---|---|---|
| `vlan 10` / `vlan 20` | VLANs in database | VLANs exist; no ports assigned yet |
| `switchport mode access` + `switchport access vlan <id>` | Port locked to one VLAN | PC frames belong to that VLAN only |
| `switchport mode trunk` + `switchport trunk allowed vlan 10,20` | Trunk carrying VLAN 10 and 20 | Both VLANs can travel to the router |
| `interface Gi0/0/0.10` + `encapsulation dot1Q 10` | Subinterface bound to VLAN 10 | Router receives/sends VLAN 10 tagged frames |
| `ip address 10.13.36.1` on subinterface | Gateway IP for VLAN 10 | PCs in VLAN 10 use this as their default gateway |
| `ip dhcp pool VLAN_TOP` | DHCP pool active | Router will hand out IPs to VLAN 10 clients |
| `show interfaces trunk` | Trunk status table | Confirms which VLANs are active over the trunk |
| `show ip dhcp binding` | Lease table | Confirms which PCs have received DHCP addresses |

---

## Common Variations

| Goal | What to Change |
|---|---|
| Add a third VLAN | Create `vlan 30`, assign a port, add `30` to `switchport trunk allowed vlan`, add subinterface `Gi0/0/0.30`, add DHCP pool |
| Change DHCP lease range | Adjust `ip dhcp excluded-address` range |
| Use a different DNS server | Change `dns-server` in the DHCP pool |
| Check if a PC got a DHCP address | `show ip dhcp binding` on router |
| Check trunk is active | `show interfaces trunk` on switch |
| Check subinterface status | `show ip interface brief` on router |

---

## Gotchas

| ⚠️ Pitfall | ✅ Fix |
|---|---|
| `show interfaces trunk` shows nothing | Physical link is down — check `no shutdown` on router's physical interface |
| `Operational Mode: down` on trunk port | Router interface is shut down — run `no shutdown` on `Gi0/0/0` |
| `encapsulation dot1Q` missing on subinterface | Router won't match VLAN-tagged frames — always set this before the IP address |
| VLAN ID in `dot1Q` doesn't match switch VLAN | Frames are silently dropped — `dot1Q 10` must match `vlan 10` exactly |
| `switchport trunk allowed vlan` not set | All VLANs pass by default, but best practice is to restrict to only `10,20` |
| PC not getting DHCP address | Check `show ip dhcp binding`; confirm trunk is up; confirm PC is set to DHCP |
| `excluded-address` set after pool | Always exclude IPs **before** defining the pool or the gateway IP may be handed out |
| Subinterface up but no routing | Confirm `ip routing` is enabled on the router (it is by default on IOS but check with `show ip route`) |