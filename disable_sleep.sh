#!/bin/bash

# This script is tailored for configuring power management settings on an Armbian Linux server
# running on an Orange Pi One. It aims to prevent the server from entering sleep or hibernation
# modes due to inactivity. This is crucial for maintaining server uptime and performance,
# especially in environments where continuous operation is required.

# Function to comment out existing settings in /etc/systemd/logind.conf
comment_out_setting() {
 local setting=$1 # The setting name to comment out
 # Comment out the setting if it exists
 sudo sed -i "s/^\($setting.*\)/#\1/" /etc/systemd/logind.conf
}

# Function to add or modify a setting in /etc/systemd/logind.conf
add_or_modify_setting() {
 local setting=$1 # The setting name to add or modify
 local value=$2   # The value to set for the setting
 # Comment out any existing setting
 comment_out_setting "$setting"
 # Add the new setting
 echo "$setting=$value" | sudo tee -a /etc/systemd/logind.conf
}

# Prevent sleep and hibernation due to inactivity
add_or_modify_setting "IdleAction" "ignore"
add_or_modify_setting "IdleActionSec" "0"

# Since the Orange Pi One does not have a lid to close or a suspend key, settings related to
# lid close actions or suspend key presses are not applicable. However, disabling runtime
# power management is still important to ensure that power management features do not
# interfere with the server's operation.
add_or_modify_setting "RuntimePowerManagement" "ignore"

# Restart systemd-logind to apply the changes
# After modifying the settings, the systemd-logind service needs to be restarted to
# apply the changes. This is a standard procedure for applying configuration changes.
sudo systemctl restart systemd-logind.service

echo "Power management settings updated. The server will remain active."
echo "Please press Enter to reboot the server."
read -p ""

# Reboot the server
# Rebooting ensures that all changes are fully applied and that the server operates
# with the new power management settings.
sudo reboot
