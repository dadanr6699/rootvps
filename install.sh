#!/bin/bash
# install.sh - Rebuild/reinstall VPS OS via bin456789/reinstall
# WARNING: This ERASES the current OS and all data. Irreversible.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/install.sh | sudo bash
#   ... | sudo bash -s -- debian 12
#   ... | sudo bash -s -- ubuntu 24.04 mypassword
set -euo pipefail

DISTRO=${1:-debian}
VERSION=${2:-12}
PASS=${3:-123Dnstore}

# --- must be root ---
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: run as root (use sudo)." >&2
  exit 1
fi

echo "=============================================="
echo " Reinstall VPS -> $DISTRO $VERSION"
echo " Root password will be: $PASS"
echo " WARNING: current OS and ALL data will be erased!"
echo "=============================================="

# --- get reinstall.sh ---
cd /root
curl -fsSL -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh \
  || wget -O reinstall.sh https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh

# --- run reinstall then reboot ---
bash reinstall.sh "$DISTRO" "$VERSION" --password "$PASS"

echo "Reinstall staged. Rebooting to start installation..."
reboot
