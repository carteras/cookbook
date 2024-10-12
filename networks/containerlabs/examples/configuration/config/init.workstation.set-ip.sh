#!/bin/bash
# Description: This script configures an IP address and brings up the network interface.
# Usage: ./init.workstation.set-ssh.sh <IP_ADDRESS> <SUBNET_MASK> <INTERFACE>
# Example: ./init.workstation.set-ssh.sh 192.168.1.100 24 eth0

# Set variables for IP, subnet, and ethernet interface from script arguments
MY_IP=$1           # IP address to assign
MY_SUBNET=$2       # Subnet mask (e.g., 24 for 255.255.255.0)
MY_ETHERNET=$3     # Ethernet interface to configure (e.g., eth0)

# Check if all required arguments are provided
if [[ -z "$MY_IP" || -z "$MY_SUBNET" || -z "$MY_ETHERNET" ]]; then
    echo "Usage: $0 <IP_ADDRESS> <SUBNET_MASK> <INTERFACE>"
    exit 1
fi

echo "Waiting for interfaces to load up..."

# Loop until the specified network interface is up
for iface in $MY_ETHERNET; do
    while ! ip link show $iface up > /dev/null 2>&1; do
        echo "Waiting for $iface to be up..."
        sleep 1  # Adding a short delay to avoid excessive CPU usage in the loop
    done
done

echo "Setting up IP address..."

# Add the IP address to the specified interface
ip address add $MY_IP/$MY_SUBNET dev $MY_ETHERNET

# Bring up the network interface
ip link set $MY_ETHERNET up

# Display the current IP configuration for all interfaces
ip addr show

# Exit the script successfully
exit 0
