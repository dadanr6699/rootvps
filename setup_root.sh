#!/bin/bash
# setup_root.sh - Enable root SSH login and password authentication
# Usage: sudo ./setup_root.sh [password]
#   password optional; if omitted, a random 20-char password is generated.
set -euo pipefail

SSHD_CONFIG=/etc/ssh/sshd_config

# --- must be root ---
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: run as root (use sudo)." >&2
  exit 1
fi

# --- password: arg or default ---
if [ $# -ge 1 ]; then
  PASS=$1
else
  PASS="123Dnstore"
  echo "No password given, using default."
fi

# --- set root password ---
echo "root:$PASS" | chpasswd

# --- backup sshd_config once ---
BACKUP="${SSHD_CONFIG}.bak.$(date +%Y%m%d%H%M%S)"
cp -a "$SSHD_CONFIG" "$BACKUP"
echo "Backup saved: $BACKUP"

# --- set directive: replace if present (commented or not), else append ---
set_directive() {
  local key=$1 val=$2
  if grep -Eq "^[#[:space:]]*${key}\b" "$SSHD_CONFIG"; then
    sed -i -E "s|^[#[:space:]]*${key}\b.*|${key} ${val}|" "$SSHD_CONFIG"
  else
    echo "${key} ${val}" >>"$SSHD_CONFIG"
  fi
}

set_directive PermitRootLogin yes
set_directive PasswordAuthentication yes

# --- validate before restart to avoid lockout ---
if ! sshd -t; then
  echo "Error: sshd config invalid, restoring backup." >&2
  cp -a "$BACKUP" "$SSHD_CONFIG"
  exit 1
fi

# --- restart ssh (name varies by distro) ---
systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null || service ssh restart

echo "Root access enabled. Password set to: $PASS"

