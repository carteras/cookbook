# TLDR: Configuring DHCP on a Cisco Router 

We can configure DHCP on a router 

## Configuring basic DHCP range

### Get into configuration mode

```bash
enable
configure terminal
```

### define the DHCP pool name: 

```bash
ip dhcp pool MYPOOL
```

Replace MYPOOL with your desired pool name.

### Specify the Network and Subnet Mask

```bash
network 192.168.1.0 255.255.255.0
```

### Set the Default Gateway (Router IP)

```bash
default-router 192.168.1.1
```

Replace 192.168.1.1 with your router's IP address.

### Set the DNS Server (Optional)

```bash
dns-server 8.8.8.8
```

Replace 8.8.8.8 with your DNS server's IP.

### Exclude a Range of IP Addresses

From Global Config Mode, Exclude IPs

```bash
ip dhcp excluded-address 192.168.1.1 192.168.1.10
```

This command excludes IP addresses from 192.168.1.1 to 192.168.1.10 from being assigned by DHCP.

### Forward DNS Requests

For DNS, Ensure Your DHCP Pool Specifies a DNS Server
Already covered under setting the DNS server in the DHCP pool configuration.

### Save Configuration


Exit Configuration Mode

```bash
exit
```
## 
 
View DHCP settings

### Enter Privileged EXEC Mode

```
enable
```

### Show DHCP Bindings

```
show ip dhcp binding
```

This command displays all the IP addresses that have been assigned by the DHCP server, along with their MAC addresses, lease time, type, and client ID.

### Show DHCP Pool

```
show ip dhcp pool
```

This command provides detailed information about each DHCP pool on the router, including the network for which the pool is responsible, the default router (gateway), DNS server settings, excluded addresses, and lease time.

### Show DHCP Server Statistics

```
show ip dhcp server statistics
```

This command displays statistical information about the DHCP server's operation, including the number of messages sent, received, and the number of addresses that have been allocated.

## TLDR code summary

```bash
enable
configure terminal
ip dhcp pool MYPOOL
network 192.168.1.0 255.255.255.0
default-router 192.168.1.1
dns-server 8.8.8.8
ip dhcp excluded-address 192.168.1.1 192.168.1.10
exit
```


