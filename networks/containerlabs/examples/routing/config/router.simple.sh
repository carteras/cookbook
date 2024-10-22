#!/bin/sh 

echo "setting up router"

vtysh << EOF
configure terminal
interface eth1
 ip address 10.0.0.1/24
interface eth2
 ip address 10.13.36.1/24
interface eth3
 ip address 10.10.10.1/24
end
write memory
EOF