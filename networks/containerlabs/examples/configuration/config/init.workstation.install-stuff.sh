#!/bin/bash 
# Description: This script updates and installs a range of packages
# Usage: ./init.workstation.install-stuff.sh [<PACKAGE_NAME> ... <PACKAGE_NAME>]
# Example: ./init.workstation.install-stuff.sh bash iproute2

# Capture the list of packages passed as arguments
APK_PACKAGES=$@

# Check if any package names were passed
if [[ -z "$APK_PACKAGES" ]]; then
    echo "Usage: $APK_PACKAGES [<PACKAGE_NAME> ... <PACKAGE_NAME>]"
    exit 1
fi

# Update the package repository
apk update 

# Install the packages
apk add $APK_PACKAGES

# Exit the script successfully
exit 0