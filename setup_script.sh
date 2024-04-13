#!/bin/bash

# This script automates the setup process for a Linux server, specifically tailored for
# environments where file system support, network tools, printing services, and user
# management are required. It updates the system, installs necessary packages, configures
# Samba for network file sharing, configures CUPS for printing services, and adds a user
# to groups for printing and serial communication. This script is designed to streamline
# the setup process for servers that require these functionalities, ensuring a smooth
# and efficient setup.

# Main function that orchestrates the setup process
main() {
    update_system
    install_packages
    configure_samba
    configure_cups
    add_user_to_groups
}

# Updates the system by performing an apt update and upgrade
update_system() {
    echo "Updating system..."
    sudo apt update && sudo apt -y upgrade
}

# Installs necessary packages for file system support, network tools, and printing services
install_packages() {
    echo "Installing packages..."
    sudo apt -y install dosfstools ntfs-3g fuse3 exfat-fuse hfsutils net-tools poppler-utils samba samba-common-bin python3 python3-pip python3-venv python3-dev python3-pyudev cups cups-client cups-common cups-pdf libcups2-dev printer-driver-escpr cups-filters printer-driver-gutenprint python3-cups python3-serial python3-magic
}

# Configures Samba for network file sharing, adds a user to the Samba group, and sets up a shared directory
configure_samba() {
    echo "Configuring Samba..."
    sudo groupadd smb
    sudo usermod -aG smb admin99
    sudo systemctl restart smbd nmbd
    sudo smbpasswd -a admin99 MYPASSWORD
    mkdir -m 777 /home/admin99/smb
    echo -e "[admin99]\n\tpath = /home/admin99\n\tbrowseable = yes\n\twritable = yes\n\tvalid users = admin99" | sudo tee -a /etc/samba/smb.conf
}

# Configures CUPS for printing services, allowing remote access
configure_cups() {
    echo "Configuring CUPS..."
    sudo cupsctl --remote-any
    sudo systemctl restart cups
}

# Adds the user to necessary groups for printing and serial communication
add_user_to_groups() {
    echo "Adding user to groups..."
    sudo usermod -a -G lpadmin admin99
    sudo usermod -a -G dialout admin99
}

# Executes the main function to start the setup process
main

