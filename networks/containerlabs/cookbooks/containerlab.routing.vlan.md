

FRRouting

Configure VLANs on the host:
First, you need to create VLAN interfaces on your host operating system. For example, on a Linux system, you can use the ip command to create VLAN interfaces:

```bash
sudo ip link add link eth0 name eth0.100 type vlan id 100
sudo ip link set dev eth0.100 up
sudo ip addr add 192.168.100.1/24 dev eth0.100
```

This example creates a VLAN interface eth0.100 with VLAN ID 100 on the eth0 interface and assigns it an IP address


Configure FRRouting to use the VLAN interfaces:
Once you have the VLAN interfaces set up on your host, you can configure FRRouting to use these interfaces in your routing configurations.

Open Shortest Path First (OSPF) is an IP routing protocol that uses a mathematical algorithm to calculate the most efficient path to direct traffic on IP networks.

Here is an example of configuring OSPF on a VLAN interface using FRRouting:

```bash
vtysh

```

```bash
configure terminal
router ospf
network 192.168.100.0/24 area 0
exit
interface eth0.100
ip ospf area 0
exit
write memory
show ip ospf neighbor
show ip ospf interface

```