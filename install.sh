#!/usr/bin/env bash

# Colors for better output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Nix Configuration Setup ===${NC}"
echo "This script will help you setup your personal Nix configuration variables."
echo

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
VARIABLES_FILE="${SCRIPT_DIR}/variables.nix"

# Get hostname with default
current_hostname=$(hostname)
read -p "Hostname [default: ${current_hostname}]: " hostname
hostname=${hostname:-$current_hostname}

# Get username with default
current_user=$(whoami)
read -p "Username [default: ${current_user}]: " username
username=${username:-$current_user}

# Get home directory with smart default
default_home="/Users/${username}"
read -p "Home directory [default: ${default_home}]: " home_dir
home_dir=${home_dir:-$default_home}

# Generate the variables.nix file
cat >"${VARIABLES_FILE}" <<EOF
{
  hostname = "${hostname}";
  username = "${username}";
  home = "${home_dir}";
}
EOF

echo -e "${GREEN}✓ Configuration saved to ${VARIABLES_FILE}${NC}"
echo
echo "Your configuration:"
echo -e "  ${BLUE}Hostname:${NC} ${hostname}"
echo -e "  ${BLUE}Username:${NC} ${username}"
echo -e "  ${BLUE}Home directory:${NC} ${home_dir}"
echo
echo "You can edit these values directly in ${VARIABLES_FILE} or run this script again."
