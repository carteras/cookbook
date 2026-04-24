# Static Routing Tutorial in Cisco Packet Tracer

## Overview

In this tutorial, you will configure **static routing** across three networks connected by three routers. By the end, PC0 and PC1 (Network 1) will be able to communicate with PC2 and PC3 (Network 3) through an intermediary network.

### Network Topology

```
[Network 1]          [Network 2]          [Network 3]
  PC0  PC1              (link)            PC2    PC3
   \   /                                   \    /
  Router0 -------- Router1 -------- Router2
```

### IP Addressing Plan

| Device  | Interface        | IP Address     | Subnet Mask     |
|---------|-----------------|----------------|-----------------|
| PC0     | NIC             | 192.168.1.2    | 255.255.255.0   |
| PC1     | NIC             | 192.168.1.3    | 255.255.255.0   |
| Router0 | Fa0/0 (to LAN1) | 192.168.1.1    | 255.255.255.0   |
| Router0 | Se0/0 (to R1)   | 10.0.0.1       | 255.255.255.252 |
| Router1 | Se0/0 (to R0)   | 10.0.0.2       | 255.255.255.252 |
| Router1 | Se0/1 (to R2)   | 10.0.1.1       | 255.255.255.252 |
| Router2 | Se0/0 (to R1)   | 10.0.1.2       | 255.255.255.252 |
| Router2 | Fa0/0 (to LAN3) | 192.168.3.1    | 255.255.255.0   |
| PC2     | NIC             | 192.168.3.2    | 255.255.255.0   |
| PC3     | NIC             | 192.168.3.3    | 255.255.255.0   |

> **Note:** The `/30` subnet (255.255.255.252) on serial links is standard practice — it provides exactly 2 usable host addresses, perfect for a point-to-point link between two routers.

---

## Part 1 — Build the Topology

### Step 1: Place Devices

1. Open **Cisco Packet Tracer**.
2. From the bottom device panel, drag and drop:
   - **3× Router** (e.g., Router-PT or 2911)
   - **4× PC**
   - **2× Switch** (one for Network 1, one for Network 3)
3. Arrange them to match the topology diagram above.

### Step 2: Connect the Devices

Use the **Connections** tool (lightning bolt icon). Choose cable type based on the link:

| Connection | Cable Type |
|---|---|
| PC → Switch | Copper Straight-Through |
| Switch → Router (Fa0/0) | Copper Straight-Through |
| Router → Router (Serial) | Serial DCE (on the left router's end) |

**Network 1:**
- PC0 → Switch0 → Router0 `Fa0/0`
- PC1 → Switch0

**Network 2 (WAN links):**
- Router0 `Se0/0` → Router1 `Se0/0`
- Router1 `Se0/1` → Router2 `Se0/0`

**Network 3:**
- Router2 `Fa0/0` → Switch1
- Switch1 → PC2
- Switch1 → PC3

> **Tip:** When connecting routers with a Serial DCE cable, the router on the **DCE end** must have a clock rate set. This is covered in Part 2.

---

## Part 2 — Configure IP Addresses

### Router0

Click **Router0** → **CLI** tab. Press **Enter** to get started, then:

```
Router> enable
Router# configure terminal
Router(config)# hostname Router0

! LAN interface facing Network 1
Router0(config)# interface FastEthernet0/0
Router0(config-if)# ip address 192.168.1.1 255.255.255.0
Router0(config-if)# no shutdown

! WAN interface facing Router1
Router0(config-if)# interface Serial0/0
Router0(config-if)# ip address 10.0.0.1 255.255.255.252
Router0(config-if)# clock rate 64000
Router0(config-if)# no shutdown
Router0(config-if)# end
```

### Router1

```
Router> enable
Router# configure terminal
Router(config)# hostname Router1

! WAN interface facing Router0
Router1(config)# interface Serial0/0
Router1(config-if)# ip address 10.0.0.2 255.255.255.252
Router1(config-if)# no shutdown

! WAN interface facing Router2
Router1(config-if)# interface Serial0/1
Router1(config-if)# ip address 10.0.1.1 255.255.255.252
Router1(config-if)# clock rate 64000
Router1(config-if)# no shutdown
Router1(config-if)# end
```

### Router2

```
Router> enable
Router# configure terminal
Router(config)# hostname Router2

! WAN interface facing Router1
Router2(config)# interface Serial0/0
Router2(config-if)# ip address 10.0.1.2 255.255.255.252
Router2(config-if)# no shutdown

! LAN interface facing Network 3
Router2(config-if)# interface FastEthernet0/0
Router2(config-if)# ip address 192.168.3.1 255.255.255.0
Router2(config-if)# no shutdown
Router2(config-if)# end
```

### PC0 and PC1 (Network 1)

Click each PC → **Desktop** tab → **IP Configuration**:

| Field | PC0 | PC1 |
|---|---|---|
| IP Address | 192.168.1.2 | 192.168.1.3 |
| Subnet Mask | 255.255.255.0 | 255.255.255.0 |
| Default Gateway | 192.168.1.1 | 192.168.1.1 |

### PC2 and PC3 (Network 3)

| Field | PC2 | PC3 |
|---|---|---|
| IP Address | 192.168.3.2 | 192.168.3.3 |
| Subnet Mask | 255.255.255.0 | 255.255.255.0 |
| Default Gateway | 192.168.3.1 | 192.168.3.1 |

---

## Part 3 — Configure Static Routes

This is the core of the tutorial. Each router only knows about networks directly connected to it. You must tell each router how to **reach the remote networks** by adding static routes.

### Understanding the `ip route` Command

```
ip route [destination network] [subnet mask] [next-hop IP or exit interface]
```

- **Destination network** — the remote network you want to reach
- **Subnet mask** — the mask of that remote network
- **Next-hop IP** — the IP address of the *neighbouring router's interface* you send traffic to

---

### Router0 Static Routes

Router0 directly knows `192.168.1.0/24` and `10.0.0.0/30`.  
It needs routes to reach **Network 3** (`192.168.3.0/24`) and the **Router1↔Router2 link** (`10.0.1.0/30`).

```
Router0# configure terminal

! To reach Network 3, send traffic to Router1's near-side serial IP
Router0(config)# ip route 192.168.3.0 255.255.255.0 10.0.0.2

! To reach the Router1-Router2 WAN link
Router0(config)# ip route 10.0.1.0 255.255.255.252 10.0.0.2

Router0(config)# end
```

---

### Router1 Static Routes

Router1 directly knows `10.0.0.0/30` and `10.0.1.0/30`.  
It needs routes back to **Network 1** and forward to **Network 3**.

```
Router1# configure terminal

! To reach Network 1, send traffic back to Router0
Router1(config)# ip route 192.168.1.0 255.255.255.0 10.0.0.1

! To reach Network 3, send traffic forward to Router2
Router1(config)# ip route 192.168.3.0 255.255.255.0 10.0.1.2

Router1(config)# end
```

---

### Router2 Static Routes

Router2 directly knows `10.0.1.0/30` and `192.168.3.0/24`.  
It needs routes back to **Network 1** and the **Router0↔Router1 link**.

```
Router2# configure terminal

! To reach Network 1, send traffic to Router1's far-side serial IP
Router2(config)# ip route 192.168.1.0 255.255.255.0 10.0.1.1

! To reach the Router0-Router1 WAN link
Router2(config)# ip route 10.0.0.0 255.255.255.252 10.0.1.1

Router2(config)# end
```

---

## Part 4 — Verify the Routing Tables

After configuring, use the following command on each router to view its routing table:

```
Router0# show ip route
```

You will see output like this on **Router0**:

```
C    192.168.1.0/24 is directly connected, FastEthernet0/0
C    10.0.0.0/30    is directly connected, Serial0/0
S    192.168.3.0/24 [1/0] via 10.0.0.2
S    10.0.1.0/30    [1/0] via 10.0.0.2
```

### Reading the Routing Table

| Code | Meaning |
|------|---------|
| `C`  | **Connected** — a network directly attached to this router |
| `S`  | **Static** — a route you manually configured |
| `[1/0]` | Administrative distance / metric (1 = static route default) |
| `via 10.0.0.2` | Next-hop: traffic is forwarded to this IP address |

---

## Part 5 — Test Connectivity

### Ping from PC0 to PC2

1. Click **PC0** → **Desktop** tab → **Command Prompt**
2. Type:
   ```
   ping 192.168.3.2
   ```
3. A successful result looks like:
   ```
   Reply from 192.168.3.2: bytes=32 time=1ms TTL=125
   Reply from 192.168.3.2: bytes=32 time=1ms TTL=125
   Reply from 192.168.3.2: bytes=32 time=1ms TTL=125
   Reply from 192.168.3.2: bytes=32 time=1ms TTL=125
   ```

### Use Packet Tracer's Simulation Mode

1. Switch to **Simulation Mode** (bottom right, clock icon).
2. Send a ping from PC0 to PC2.
3. Click **Play** and watch the packet hop:
   - PC0 → Switch0 → Router0 → Router1 → Router2 → Switch1 → PC2
4. Click on any packet envelope along the path to inspect the **PDU Details** and see the IP headers at each hop.

---

## Troubleshooting Tips

| Symptom | Likely Cause | Fix |
|---|---|---|
| Interface shows `down/down` | Cable not connected or wrong type | Re-check connections and cable type |
| Interface shows `up/down` | `no shutdown` not issued | Enter interface and run `no shutdown` |
| Ping fails between routers | Missing or wrong IP on serial link | Verify IPs with `show ip interface brief` |
| Ping fails across all networks | Missing static route | Check routing tables with `show ip route` |
| Ping works one way only | Return route missing on far router | Add the reverse static route |

---

## Summary

You have successfully:

1. Built a three-network topology in Packet Tracer
2. Assigned IP addresses to all interfaces and end devices
3. Configured static routes on all three routers
4. Verified the routing table with `show ip route`
5. Tested end-to-end connectivity with ping

Static routing gives you full control over how traffic flows through your network, making it ideal for small, stable topologies like this one. For larger or more dynamic networks, consider exploring **dynamic routing protocols** such as **RIP**, **OSPF**, or **EIGRP** as your next step.