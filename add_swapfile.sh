# This script safely adds a 1GB swapfile to an Armbian system.
# To use the script, simply type the following command:
# $ chmod +x add_swapfile.sh
# $ ./add_swapfile.sh

if [ -f /swapfile ]; then
  echo "A swapfile is already present. Please remove the swapfile before running this script."
  exit 1
fi

echo "Creating a 1GB swapfile..."
sudo fallocate -l 1G /swapfile

sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo "Showing swap usage..."
sudo swapon --show

sudo cp /etc/fstab /etc/fstab.bak

if sudo grep -q '/swapfile' /etc/fstab; then
  echo "The swapfile entry already exists in /etc/fstab."
else
  echo 'Adding swapfile entry to /etc/fstab...'
  sudo echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

if [ $(sudo grep -c '/swapfile' /proc/swaps) -eq 1 ]; then
  echo "Swapfile added and mounted successfully."
else
  echo "Failed to add swapfile. Please check the script output for errors."
  exit 1
fi
