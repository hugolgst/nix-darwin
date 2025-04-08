#!/usr/bin/env bash
# Colors for better output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Nix and Nix-Darwin Configuration Setup ===${NC}"
echo "This script will install Nix, set up nix-darwin, and configure your personal variables."
echo

# Check if Nix is already installed
if command -v nix >/dev/null 2>&1; then
  echo -e "${GREEN}✓ Nix is already installed${NC}"
else
  echo -e "${YELLOW}Installing Nix...${NC}"
  # Install Nix
  sh <(curl -L https://nixos.org/nix/install) --daemon
  # Source nix profile to make nix commands available in current shell
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  fi
  echo -e "${GREEN}✓ Nix installed successfully${NC}"
fi

# Enable flakes
echo -e "${YELLOW}Enabling Nix flakes...${NC}"
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >~/.config/nix/nix.conf
echo -e "${GREEN}✓ Nix flakes enabled${NC}"

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

# Get full name
read -p "Full name: " full_name

# Get email address
read -p "Email address: " email

# Generate the variables.nix file
cat >"${VARIABLES_FILE}" <<EOF
{
  hostname = "${hostname}";
  username = "${username}";
  home = "${home_dir}";
  fullName = "${full_name}";
  email = "${email}";
}
EOF

echo -e "${GREEN}✓ Configuration saved to ${VARIABLES_FILE}${NC}"
echo
echo "Your configuration:"
echo -e "  ${BLUE}Hostname:${NC} ${hostname}"
echo -e "  ${BLUE}Username:${NC} ${username}"
echo -e "  ${BLUE}Home directory:${NC} ${home_dir}"
echo -e "  ${BLUE}Full name:${NC} ${full_name}"
echo -e "  ${BLUE}Email:${NC} ${email}"
echo

# Check if nix-darwin is installed
if [ -e "/run/current-system/sw/bin/darwin-rebuild" ]; then
  echo -e "${GREEN}✓ nix-darwin is already installed${NC}"
else
  echo -e "${YELLOW}Installing nix-darwin...${NC}"
  # Create the ~/.config/nix-darwin directory if it doesn't exist
  mkdir -p ~/.config/nix-darwin
  # Install nix-darwin
  nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  ./result/bin/darwin-installer
  echo -e "${GREEN}✓ nix-darwin installed successfully${NC}"
fi

# Run nix-darwin switch with the flake
echo -e "${YELLOW}Applying nix-darwin configuration...${NC}"
if nix run nix-darwin -- switch --flake ~/.config/nix-darwin; then
  echo -e "${GREEN}✓ nix-darwin configuration applied successfully${NC}"
else
  echo -e "${RED}Failed to apply nix-darwin configuration. Please check for errors.${NC}"
  exit 1
fi

echo
echo -e "${GREEN}Setup complete!${NC}"
echo "You can edit your variables directly in ${VARIABLES_FILE} or run this script again."
  exit 1
fi

echo
echo -e "${GREEN}Setup complete!${NC}"
echo "You can edit your variables directly in ${VARIABLES_FILE} or run this script again."
