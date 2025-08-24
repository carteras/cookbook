#!/bin/sh

# This script configures FRRouting (FRR) and assigns IP addresses to network interfaces.
# It takes pairs of Ethernet interfaces and corresponding IP addresses as arguments.
# For each interface, the script waits until the interface is up, then configures it with the provided IP address.
# It is designed to run in a Containerlab environment.
# Usage example: ./script.sh eth1 10.0.0.1/24 eth2 10.13.36.1/24 eth3 10.10.10.1/24

# Validate that the correct number of arguments is passed (must be in pairs)
if [ $(($# % 2)) -ne 0 ]; then
    echo "Incorrect number of arguments. Pass interfaces and IP addresses in pairs."
    echo "Example: ./script.sh eth1 10.0.0.1/24 eth2 10.13.36.1/24"
    exit 1
fi

# Store the interfaces and IP addresses in pairs
interfaces_and_ips="$@"

# Start FRRouting daemons and output status immediately
echo "Starting up FRR daemons..."
/etc/init.d/frr start &

# Notify user that FRR is starting in the background
echo "FRR daemons are starting... the script will continue setting up interfaces."

# Wait for each interface to be up, and echo status for each
echo "Waiting for interfaces to load up..."
while [ "$#" -gt 0 ]; do
    iface=$1
    ip_addr=$2

    # Check each interface in the background and notify when ready
    (
      echo "Checking interface $iface..."
      while ! ip link show $iface up > /dev/null 2>&1; do
          sleep 1
      done
      echo "$iface is up!"
    ) &

    # Move to the next pair
    shift 2
done

# Wait for all background processes to finish checking interfaces
wait

# Configure router using vtysh for all interfaces
echo "Configuring the router with the provided interfaces and IP addresses..."
set -- $interfaces_and_ips

while [ "$#" -gt 0 ]; do
    iface=$1
    ip_addr=$2

    echo "Configuring $iface with IP $ip_addr..."

    vtysh << EOF
configure terminal
interface $iface
 ip address $ip_addr
EOF

    echo "$iface configured with IP $ip_addr."

    # Move to the next interface/IP pair
    shift 2
done

# Finalize the configuration and write it to memory
vtysh << EOF
end
write memory
EOF

# Notify user that the script is complete
echo "Router setup completed successfully!"
