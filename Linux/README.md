# Incident Response Script for Linux

## Overview
This Bash script is designed to assist in basic incident response on a macOS system. It automates the collection of system information, running processes, network details, user accounts, and network information for analysis during an incident. The collected data can be used for initial assessment and further investigation.

## Prerequisites
- This script is designed for Linux.
- Only tested on Ubuntu.
- You need to have Bash shell access on the target Linux system.

## Usage
1. Download the script to your system where you need to perform incident response.

2. Make the script executable:
   ```bash
   chmod +x incident_response.sh
3. Run the script with administrative privileges:
    ```bash
    sudo ./incident_response.sh
