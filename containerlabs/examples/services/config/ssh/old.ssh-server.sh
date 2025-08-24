#!/bin/sh 

apk update
apk add bash iproute2 openrc openssh rsyslog

echo "export HISTFILE=/dev/null"

# Ensure OpenRC directories exist
mkdir -p /run/openrc
touch /run/openrc/softlevel

# Start and enable rsyslog
rc-service rsyslog start
rc-update add rsyslog

# Add and prepare SSHD
sh /config/services.sshd.sh 22
rc-status -a

# Enable and start SSHD service
rc-service sshd start
rc-update add sshd

# Verify SSHD status
rc-status -a