```bash
#!/bin/sh
# Install networking tools
apk update
apk add iproute2

# Assign IP address to the interface
ip addr add 10.0.0.2/24 dev eth1
ip link set eth1 up

# Add a default route pointing to the Cisco router
ip route add default via 10.0.0.1
```