#!/bin/bash

# Note: avml memeoty file must be in same dir for volatility.
# Check if the script is running with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with superuser privileges (sudo)."
    exit 1
fi

# Gets current directory
current_directory=$(pwd)

# Define a timestamp for the specific incident
incident_timestamp=$(date +"-%Y\%m\%d-%H:%M:%S")			
incident_dir="incident$incident_timestamp"

# Create the main incident directory if it doesn't exist
if [ ! -d "incident_response" ]; then
    mkdir -p "incident_response"
fi
# Change the current working directory to the incident directory
cd incident_response

# Create the directory for this incident
mkdir "$incident_dir"

# Define the tool incident directory
tools="tools"
# Create the tools directory if it doesn't exist
if [ ! -d "$tools" ]; then
    mkdir -p "$tools"
fi
cd $tools

# Install needed tools
sudo apt install net-tools git wget curl -y

Check if volatility3 is installed
if [ -d "/volatility3" ]; then
    echo "volatility3 is already installed."
else
    # Install volatility3
    echo "Cloning volatility3 repository..."
    git clone https://github.com/volatilityfoundation/volatility3.git
    cd volatility3
    # git clone --recursive https://github.com/VirusTotal/yara-python
    # sudo apt install -y python3 python3-dev python3-pip libpython3-dev python3-pip python3-setuptools python3-wheel 
    # sudo python3 -m pip install -U distorm3 yara dwarfdump yara-python pycryptodome pillow openpyxl ujson pytz ipython capstone
    # cd yara-python && sudo python3 setup.py build && sudo python3 setup.py install &&  sudo python3 setup.py build --dynamic-linking
    cd ..
    # pip3 install -r requirements.txt
    # sudo python setup.py install
fi

# Check if avml is installed
if [ -e "avml" ]; then
    echo "avml is already installed."
else
    # Install
    echo "Downloading avml..."
    wget https://github.com/microsoft/avml/releases/download/v0.11.2/avml
    chmod +x avml
fi

ls
# Run AVML
sudo ./avml memory.mem
# Move the file in Volatility dir 
cp memory.mem $current_directory/incident_response/tools/volatility3/
# Move the file in the incident dir
mv memory.mem $current_directory/incident_response/$incident_dir/
# Starting the Analysis



ir="$current_directory/incident_response/$incident_dir"
# Log system information
echo "Collecting system information..."
uname -a > "$ir/system_info.txt"
lsb_release -a >> "$ir/system_info.txt"
lscpu >> "$ir/system_info.txt"
lsblk >> "$ir/system_info.txt"
df -h >> "$ir/system_info.txt"
dmesg >> "$ir/system_info.txt"
cat /proc/version >> "$ir/system_info.txt"
echo "System information collected and saved to $ir/system_info.txt"

# List running processes
echo "Listing running processes..."
ps aux > "$ir/running_processes.txt"
echo "Running processes listed and saved to $ir/running_processes.txt"

# Gather network information
echo "Collecting network information..."
ifconfig > "$ir/network_info.txt"
route -n >> "$ir/network_info.txt"
cat /etc/resolv.conf >> "$ir/network_info.txt"
echo "Network information collected and saved to $ir/network_info.txt"

# Run netstat connections
echo "Running netstat to gather network connections..."
netstat -tuln > "$ir/network_connections.txt"
echo "Network connections gathered and saved to $ir/network_connections.txt"

# Gather user accounts
echo "Listing user accounts..."
cat /etc/passwd > "$ir/user_accounts.txt"
echo "User accounts listed and saved to $ir/user_accounts.txt"

echo "Incident data collection completed. Find the data in $ir"
