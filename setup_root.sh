#!/bin/bash
# setup_root.sh - Enable root login and password authentication
# Usage: sudo ./setup_root.sh [password]

PASS=${1:-"RootPassword123!"}

echo "root:$PASS" | chpasswd

sed -i 's/^[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^[# ]*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

systemctl restart sshd || systemctl restart ssh

echo "Root access enabled. Password set to: $PASS"
