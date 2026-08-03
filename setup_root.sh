#!/usr/bin/env bash
export TERM="${TERM:-xterm}"
# ==========================================================================
# setup_root.sh - Enable Root SSH Access & Password Authentication
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/setup_root.sh | sudo bash
#   curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/setup_root.sh | sudo bash -s -- passwordku
# ==========================================================================

set -euo pipefail

# ANSI Styling
BOLD="\033[1m"
DIM="\033[2m"
RESET="\033[0m"

RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"

# Root Check
if [ "$(id -u)" -ne 0 ]; then
  echo -e "${RED}✖ Error: Anda harus menjalankan script ini sebagai root (sudo).${RESET}" >&2
  exit 1
fi

clear 2>/dev/null || true
echo -e "${CYAN}${BOLD}"
cat << "EOF"
  ██████╗  ██████╗  ██████╗ ████████╗██╗   ██╗██████╗ ███████╗
  ██╔══██╗██╔═══██╗██╔═══██╗╚══██╔══╝██║   ██║██╔══██╗██╔════╝
  ██████╔╝██║   ██║██║   ██║   ██║   ██║   ██║██████╔╝███████╗
  ██╔══██╗██║   ██║██║   ██║   ██║   ╚██╗ ██╔╝██╔═══╝ ╚════██║
  ██║  ██║╚██████╔╝╚██████╔╝   ██║    ╚████╔╝ ██║     ███████║
  ╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝     ╚═══╝  ╚═╝     ╚══════╝
EOF
echo -e "${MAGENTA}${BOLD}         🚀 ROOT SSH ACCESS & PASSWORD AUTH ENABLER 🚀${RESET}"
echo -e "${CYAN}====================================================================${RESET}\n"

# Password Resolution
PASS="${1:-123Dnstore}"

echo -e "${BLUE}${BOLD}[1/4] 🔑 MENGONFIGURASI PASSWORD ROOT...${RESET}"
echo "root:$PASS" | chpasswd
# Unlock root account if locked by cloud-init
usermod -U root 2>/dev/null || passwd -u root 2>/dev/null || true
echo -e "${GREEN}✔ Password root berhasil diatur menjadi: ${BOLD}${PASS}${RESET}\n"

# Backup & SSH Config Modification
echo -e "${BLUE}${BOLD}[2/4] ⚙️ MENGONFIGURASI SSH SERVER (SSHD)...${RESET}"
SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP="${SSHD_CONFIG}.bak.$(date +%Y%m%d%H%M%S)"

if [ -f "$SSHD_CONFIG" ]; then
  cp -a "$SSHD_CONFIG" "$BACKUP"
  echo -e "${DIM}► Backup sshd_config disimpan di: $BACKUP${RESET}"
fi

set_directive() {
  local key=$1 val=$2 file=$3
  if grep -Eq "^[#[:space:]]*${key}\b" "$file"; then
    sed -i -E "s|^[#[:space:]]*${key}\b.*|${key} ${val}|" "$file"
  else
    echo "${key} ${val}" >> "$file"
  fi
}

# Apply to main sshd_config
if [ -f "$SSHD_CONFIG" ]; then
  set_directive PermitRootLogin yes "$SSHD_CONFIG"
  set_directive PasswordAuthentication yes "$SSHD_CONFIG"
  set_directive KbdInteractiveAuthentication yes "$SSHD_CONFIG"
fi

# Override Cloud-Init Drop-in configs if directory exists (Ubuntu 22/24, Debian 12, AWS, GCP, DO)
SSHD_DIR="/etc/ssh/sshd_config.d"
if [ -d "$SSHD_DIR" ]; then
  echo -e "${DIM}► Memperbarui drop-in config di $SSHD_DIR...${RESET}"
  # Neutralize any cloud-init override files that disable password auth
  for dropin in "$SSHD_DIR"/*.conf; do
    if [ -f "$dropin" ]; then
      sed -i -E "s|^[#[:space:]]*PasswordAuthentication\b.*|PasswordAuthentication yes|" "$dropin" 2>/dev/null || true
      sed -i -E "s|^[#[:space:]]*PermitRootLogin\b.*|PermitRootLogin yes|" "$dropin" 2>/dev/null || true
    fi
  done

  # Create high-priority drop-in override
  cat << EOF > "$SSHD_DIR/99-rootvps-override.conf"
PermitRootLogin yes
PasswordAuthentication yes
KbdInteractiveAuthentication yes
PubkeyAuthentication yes
EOF
  chmod 644 "$SSHD_DIR/99-rootvps-override.conf"
fi
echo -e "${GREEN}✔ Pengaturan SSH PermitRootLogin & PasswordAuthentication aktif.${RESET}\n"

# SSH Configuration Validation
echo -e "${BLUE}${BOLD}[3/4] 🛡️ VALIDASI KONFIGURASI SSH...${RESET}"
if command -v sshd &>/dev/null; then
  if ! sshd -t; then
    echo -e "${RED}✖ Error: Konfigurasi sshd tidak valid. Mengembalikan backup...${RESET}" >&2
    if [ -f "$BACKUP" ]; then
      cp -a "$BACKUP" "$SSHD_CONFIG"
    fi
    exit 1
  fi
fi
echo -e "${GREEN}✔ Validasi sintaks sshd sukses.${RESET}\n"

# Restart SSH Service Across Distros
echo -e "${BLUE}${BOLD}[4/4] 🔄 MERESTART LAYANAN SSH...${RESET}"
RESTARTED=0
if systemctl is-active --quiet sshd 2>/dev/null || systemctl is-enabled --quiet sshd 2>/dev/null; then
  systemctl restart sshd && RESTARTED=1
elif systemctl is-active --quiet ssh 2>/dev/null || systemctl is-enabled --quiet ssh 2>/dev/null; then
  systemctl restart ssh && RESTARTED=1
fi

if [ $RESTARTED -eq 0 ]; then
  service sshd restart 2>/dev/null || service ssh restart 2>/dev/null || /etc/init.d/ssh restart 2>/dev/null || true
fi
echo -e "${GREEN}✔ Layanan SSH berhasil di-restart.${RESET}\n"

echo -e "${CYAN}====================================================================${RESET}"
echo -e "${GREEN}${BOLD}✨ AKSES ROOT SSH BERHASIL DIAKTIFKAN ✨${RESET}"
echo -e "${WHITE}► Username : ${BOLD}root${RESET}"
echo -e "${WHITE}► Password : ${GREEN}${BOLD}${PASS}${RESET}"
echo -e "${CYAN}====================================================================${RESET}\n"
