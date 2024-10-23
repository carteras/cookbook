#!/bin/sh 

USER_NAME=testuser
PASSWORD="password1"
IP=10.0.0.50
SUBNET=24
DEVICE=eth1

echo "adding packages"

apk update
apk add bash iproute2 openrc openssh rsyslog

echo "setting up IP address"

ip address add $MY_IP/$MY_SUBNET dev $MY_ETHERNET
ip link set $MY_ETHERNET up

ip a s

echo "Adding ${USER_NAME} to ssh server"

addgroup $USER_NAME
adduser -D -H $MY_USERNAME
echo "${USER_NAME}:${PASSWORD}" | chpasswd

mkdir /home/${USER_NAME}
chown root:${USER_NAME} /home/${USER_NAME}
chmod 750 /home/${USER_NAME}

# Capture and display the directory permissions for /home/$MY_USERNAME
echo "Listed directory"
DIRECTORY_LIST=$(ls -ld /home/$MY_USERNAME)
echo "$DIRECTORY_LIST"

# disable HISTFILE being stored
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