#!/bin/bash

# Incident Response Script:
    # The script is designed for basic incident response on a macOS system. 
    # It creates a directory for the incident, collects system information, running processes, 
    # network information, and user accounts, and logs this information for analysis.

# Define output directory
OUTPUT_DIR="."

# Create a timestamp for the incident
TIMESTAMP=$(date +"%Y\%m\%d-%H:%M:%S")

# Create a directory for this incident
INCIDENT_DIR="$OUTPUT_DIR/incident_$TIMESTAMP"
mkdir -p "$INCIDENT_DIR"

# Log system information - The collected information includes various system parameters, configurations, and kernel information.
echo "Collecting system information..."
sysctl -a > "$INCIDENT_DIR/system_info.txt"

# List running processes - It provides details about each process, including the user, process ID, CPU usage, and more.
echo "Listing running processes..."
ps aux > "$INCIDENT_DIR/running_processes.txt"

# Gather network information - It includes details about network interfaces, IP addresses, and related configurations.
echo "Gathering network information..."
ifconfig -a > "$INCIDENT_DIR/network_info.txt"

# Run netstat connections -  This information display information about network connections, open ports, and routing tables.
echo "Running netstat and logging the output..."
netstat -tuln > "$INCIDENT_DIR/netstat_info.txt"

# Run netstat connections -  This information display information about network connections, open ports, and routing tables.
echo "Running netstat and logging the output..."
netstat > "$INCIDENT_DIR/netstat_info_extensive.txt"

# Gather user accounts - This command lists user accounts on the system 
echo "Listing user accounts..."
dscl . -list /Users > "$INCIDENT_DIR/user_accounts.txt"

# Archive the incident data - 
echo "Archiving incident data..."
tar -czvf "$OUTPUT_DIR/incident_$TIMESTAMP.tar.gz" "$INCIDENT_DIR"

# Cleanup temporary files
echo "Cleaning up..."
rm -rf "$INCIDENT_DIR"

echo "Incident response script completed."

