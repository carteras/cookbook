#!/bin/bash

echo "Hello switch1!"

# Enable immediate flushing of output
set -o pipefail
exec > >(tee /proc/1/fd/1) 2>&1

# Ensure correct environment variables are set
export PATH=/usr/lib/frr:$PATH
export LD_LIBRARY_PATH=/usr/lib/frr:$LD_LIBRARY_PATH

# Give the system a moment to settle
sleep 5

# Enable IP forwarding (if needed)
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1

# Start FRR daemons
if ! pgrep zebra > /dev/null; then
    echo "Starting up FRR daemons"
    /usr/lib/frr/zebra -d
    # You might not need ospfd or bgpd if you're just switching
else
    echo "FRR daemons are already running"
fi

# Wait for the interfaces to be up
echo "Waiting for interfaces to load up"
sleep 5

# Create a Linux bridge if it doesn't already exist
if ! ip link show br0 > /dev/null 2>&1; then
    brctl addbr br0
fi

# Add all UP interfaces to the bridge, excluding br0 and eth0
for iface in $(ip -br link | awk '$2 == "UP" {print $1}' | cut -d'@' -f1); do
    if [[ "$iface" != "br0" && "$iface" != "eth0" ]]; then
        if ! brctl show br0 | grep -q "$iface"; then
            echo "Adding $iface to bridge br0"
            brctl addif br0 $iface
        fi
    fi
done

# Bring the bridge up
ip link set dev br0 up

# If you want to manage the bridge with FRRouting, configure zebra here
# vtysh -c "conf t" -c "interface br0" -c "ip address 192.168.x.x/24" (if you need an IP)

echo "Bridge setup complete!"

ip -br link

exit 0
