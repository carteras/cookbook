#!/bin/sh
# Description: This script adds users and assigns them to multiple groups
# Usage: ./init.workstation.add-user.sh <username> <password> [group1,group2,...]
# Example: ./init.workstation.add-user.sh testuser password1 group1,group2

USERNAME=$1
PASSWORD=$2
GROUPS=${3:-$USERNAME}  # If no groups are provided, use the username as the group

# Check if required arguments are missing
if [[ -z $USERNAME || -z $PASSWORD ]]; then
    echo "Usage: $0 <USERNAME> <PASSWORD> [GROUPS]"
    exit 1
fi

echo "Adding ${USERNAME} to this machine"

# Split the GROUPS string by commas into a list (sh doesn't support arrays)
GROUP_ARRAY=$(echo "$GROUPS" | tr ',' ' ')

# Create each group if it doesn't exist and add the user to each group
for GROUP_NAME in "${GROUP_ARRAY[@]}"; do
    if ! getent group "$GROUP_NAME" >/dev/null; then
        addgroup "$GROUP_NAME"
        echo "Group $GROUP_NAME created"
    fi
    adduser "$USERNAME" "$GROUP_NAME"
    echo "User $USERNAME added to group $GROUP_NAME"
done

# Set the user's password
echo "$USERNAME:$PASSWORD" | chpasswd

echo "User $USERNAME created and assigned to groups: $GROUPS with the provided password."
