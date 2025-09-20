#!/bin/bash

##############################################################
# Author: Uzair
# Date: 20/09/2025
# Script: Remote Node Health Check (Multi-Node)
# Version: v3.2
#
# Description:
# This script checks the health of one or more remote Linux nodes.
# It performs:
#   1. Ping reachability check
#   2. SSH login using PEM key
#   3. Remote health commands (uptime, CPU, memory, disk, processes)
#   4. Fetch report locally and display
#   5. Save report with timestamp in ./reports/
#
# Features:
# - Helper function for correct usage
# - User input for node IPs, username, PEM key
# - Multiple node support (-f nodes.txt)
# - Color-coded UP/DOWN output
# - Colored headings inside reports for better readability
# - Detailed, human-readable comments
##############################################################

# =================== Helper Function ===================
show_help() {
    echo "==========================================="
    echo "        Remote Node Health Check v3.2"
    echo "==========================================="
    echo "Usage:"
    echo "  $0                   # Interactive mode (asks for Node IP)"
    echo "  $0 -f nodes.txt      # Run health check for multiple nodes from file"
    echo
    echo "Required:"
    echo "  - PEM key file must be accessible."
    echo "  - nodes.txt must contain one IP per line (for multiple nodes mode)."
    echo
    echo "Examples:"
    echo "  ./nodeHealth.sh"
    echo "  ./nodeHealth.sh -f my_nodes.txt"
    echo "==========================================="
    exit 1
}

# =================== Colors ===================
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

# =================== Prepare Reports Directory ===================
mkdir -p ./reports

# =================== Argument Parsing ===================
if [[ $# -gt 2 ]]; then
    echo "Error: Too many arguments."
    show_help
fi

if [[ $# -eq 1 && $1 != "-f" && $1 != "-h" && $1 != "--help" ]]; then
    echo "Error: Unknown argument '$1'"
    show_help
fi

if [[ $1 == "-h" || $1 == "--help" ]]; then
    show_help
fi

if [[ $1 == "-f" ]]; then
    if [[ -z "$2" ]]; then
        echo "Error: Missing file name after '-f'"
        show_help
    fi
    NODE_FILE="$2"
    if [[ ! -f $NODE_FILE ]]; then
        echo "Error: File '$NODE_FILE' not found!"
        exit 1
    fi
    NODES=$(cat $NODE_FILE)
else
    echo "Enter Node IP (or press Ctrl+C to exit): "
    read Hostname
    if [[ -z "$Hostname" ]]; then
        echo "Error: No IP entered."
        show_help
    fi
    NODES=$Hostname
fi

# =================== Get Remote Username ===================
echo "Enter Remote Username (e.g. ec2-user or ubuntu): "
read RemoteUser
if [[ -z "$RemoteUser" ]]; then
    echo "Error: Username cannot be empty."
    show_help
fi

# =================== Get PEM Key ===================
echo "Enter Path to PEM Key (e.g. /path/to/my-key.pem): "
read PemKey
if [[ -z "$PemKey" || ! -f "$PemKey" ]]; then
    echo "Error: PEM key not found!"
    show_help
fi

# =================== Main Loop ===================
for Hostname in $NODES; do
    echo "========================================="
    echo -e "Checking Node: ${YELLOW}$Hostname${NC}"
    echo "Date: $(date)"
    echo "========================================="

    # Step 1: Ping node to check reachability
    ping -c 2 $Hostname > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "${RED}Node $Hostname is DOWN${NC}"
        echo
        continue
    else
        echo -e "${GREEN}Node $Hostname is UP${NC}"
    fi

    # Step 2: Generate timestamped report paths
    Timestamp=$(date +"%Y%m%d_%H%M%S")
    RemoteReport="/tmp/health_report_$Timestamp.txt"
    LocalReport="./reports/health_report_${Hostname}_$Timestamp.txt"

    echo "Running remote health check on $Hostname..."
    echo

    # Step 3: SSH into node and run health commands with color headings
    ssh -i $PemKey -o StrictHostKeyChecking=no $RemoteUser@$Hostname bash -s <<EOF > /dev/null
{
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "\${BLUE}====================\${NC}"
echo -e "\${YELLOW} Node Health Report \${NC}"
echo -e "\${BLUE}====================\${NC}"
echo -e "\${YELLOW}Hostname:\${NC} \$(hostname)"
echo -e "\${YELLOW}Date:\${NC} \$(date)"
echo

echo -e "\${BLUE}---- Uptime ----\${NC}"
uptime | awk -F"," '{print \$1}'
echo

echo -e "\${BLUE}---- CPU Load ----\${NC}"
top -bn1 | grep "load average:" | awk -F"," '{print \$3, \$4, \$5}'
echo

echo -e "\${BLUE}---- Memory Usage ----\${NC}"
free -h
echo

echo -e "\${BLUE}---- Disk Usage ----\${NC}"
df -h | grep -v tmpfs
echo

echo -e "\${BLUE}---- Top 5 Processes by CPU ----\${NC}"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
echo

echo -e "\${BLUE}---- Top 5 Processes by Memory ----\${NC}"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
echo
} > $RemoteReport
EOF

    # Step 4: Copy report from remote node to local
    scp -i $PemKey $RemoteUser@$Hostname:$RemoteReport $LocalReport

    # Step 5: Display report on screen
    echo "===== Health Report for $Hostname ====="
    cat $LocalReport
    echo

    # Step 6: Cleanup remote report
    ssh -i $PemKey $RemoteUser@$Hostname "rm -f $RemoteReport"

    echo "Report saved in: $LocalReport"
    echo "========================================="
    echo
done

echo "All health checks completed."
