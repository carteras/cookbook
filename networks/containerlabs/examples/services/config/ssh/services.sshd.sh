#!/bin/sh

PORT=$1

echo "Setting up SSHD services" 

# Path to the SSH configuration file
SSHD_CONFIG="/etc/ssh/sshd_config"

# Check if PermitRootLogin and PasswordAuthentication are set
if grep -q "^#PermitRootLogin" "$SSHD_CONFIG" || grep -q "^PermitRootLogin" "$SSHD_CONFIG"; then
  # Uncomment or modify PermitRootLogin to allow root login
  sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' "$SSHD_CONFIG"
  sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' "$SSHD_CONFIG"
else
  # Add PermitRootLogin if not present
  echo "PermitRootLogin yes" >> "$SSHD_CONFIG"
fi

if grep -q "^#PasswordAuthentication" "$SSHD_CONFIG" || grep -q "^PasswordAuthentication" "$SSHD_CONFIG"; then
  # Uncomment or modify PasswordAuthentication to allow password authentication
  sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' "$SSHD_CONFIG"
  sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' "$SSHD_CONFIG"
else
  # Add PasswordAuthentication if not present
  echo "PasswordAuthentication yes" >> "$SSHD_CONFIG"
fi

# Check if a custom SSH port is set, and modify it if needed
if grep -q "^#Port " "$SSHD_CONFIG" || grep -q "^Port " "$SSHD_CONFIG"; then
  # Uncomment or modify the Port directive with the new port
  sed -i "s/^#Port .*/Port $PORT/" "$SSHD_CONFIG"
  sed -i "s/^Port .*/Port $PORT/" "$SSHD_CONFIG"
else
  # Add the Port directive if it's not present
  echo "Port $PORT" >> "$SSHD_CONFIG"
fi
    

# Restart SSH service to apply changes
rc-service sshd restart

echo "SSH configuration updated and service restarted."
