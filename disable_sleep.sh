#!/bin/bash

# Function to comment out existing settings
comment_out_setting() {
  local setting=$1}      # Comment out the setting if it exists
  sudo sed -i "s/^\($setting.*\)/#\1/" /etc/systemd/logind.conf
}

# Function to add or modify a setting
add_or_modify_setting() {
  local setting=$1
  local value=$2}      # Comment out any existing setting
  comment_out_setting "$setting"      # Add the new setting
  echo "$setting=$value" | sudo tee -a /etc/systemd/logind.conf
}

# Prevent sleep and hibernation due to inactivity
add_or_modify_setting "IdleAction" "ignore"
add_or_modify_setting "IdleActionSec" "0"

# Prevent sleep and hibernation for lid close and suspend keys
add_or_modify_setting "HandleSuspendKey" "ignore"
add_or_modify_setting "HandleLidSwitch" "ignore"
add_or_modify_setting "HandleLidSwitchExternalPower" "ignore"
add_or_modify_setting "HandleLidSwitchDocked" "ignore"

# Disable runtime power management
add_or_modify_setting "RuntimePowerManagement" "ignore"

# Restart systemd-logind to apply the changes
sudo systemctl restart systemd-logind.service

echo "Power management settings updated. The system will remain active."
echo "Please press Enter to reboot the system."
read -p ""

# Reboot the system
sudo reboot
