#!/usr/bin/env bash
# ==========================================================================
# reinstall.sh - Reinstall / Rebuild VPS Operating System
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/reinstall.sh | sudo bash
#   curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/reinstall.sh | sudo bash -s -- debian 12
#   curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/reinstall.sh | sudo bash -s -- ubuntu 24.04 passwordku
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

clear
echo -e "${RED}${BOLD}"
cat << "EOF"
  ██████╗ ███████╗██╗███╗   ██╗███████╗████████╗████╗     ██╗
  ██╔══██╗██╔════╝██║████╗  ██║██╔════╝╚══██╔══╝██║██║     ██║
  ██████╔╝█████╗  ██║██╔██╗ ██║███████╗   ██║   ██║██║     ██║
  ██╔══██╗██╔══╝  ██║██║╚██╗██║╚════██║   ██║   ██║██║     ██║
  ██║  ██║███████╗██║██║ ╚████║███████║   ██║   ██║███████╗███████╗
  ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝╚══════╝╚══════╝
EOF
echo -e "${YELLOW}${BOLD}     ⚠️ PERINGATAN: INSTAL ULANG / REBUILD SISTEM OPERASI VPS ⚠️${RESET}"
echo -e "${RED}====================================================================${RESET}\n"

DISTRO=${1:-debian}
VERSION=${2:-12}
PASS=${3:-123Dnstore}

echo -e "${WHITE}► Target OS Distro : ${GREEN}${BOLD}${DISTRO} ${VERSION}${RESET}"
echo -e "${WHITE}► Password Root    : ${GREEN}${BOLD}${PASS}${RESET}"
echo -e "${RED}${BOLD}⚠️ PERINGATAN: Seluruh data & sistem OS VPS akan DIHAPUS TOTAL!${RESET}\n"

# Interactive safety confirmation if running interactively in terminal
if [ -t 0 ] && [ $# -lt 1 ]; then
  read -p "$(echo -e "${YELLOW}❓ Apakah Anda YAKIN ingin menghapus OS & menginstal ulang? (ketik YES): ${RESET}")" CONFIRM
  if [ "$CONFIRM" != "YES" ] && [ "$CONFIRM" != "yes" ]; then
    echo -e "${RED}✖ Proses instal ulang dibatalkan.${RESET}"
    exit 0
  fi
fi

echo -e "${BLUE}${BOLD}[1/2] 📥 MENGUNDUH UPSTREAM REINSTALL ENGINE...${RESET}"
cd /root
if ! curl -fsSL -o reinstall_upstream.sh https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh; then
  wget -O reinstall_upstream.sh https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh
fi
echo -e "${GREEN}✔ Engine reinstall berhasil diunduh.${RESET}\n"

echo -e "${BLUE}${BOLD}[2/2] 🚀 MEMULAI PROSES INSTAL ULANG & REBOOT...${RESET}"
echo -e "${DIM}► Menjalankan instalasi $DISTRO $VERSION dengan password $PASS...${RESET}"
bash reinstall_upstream.sh "$DISTRO" "$VERSION" --password "$PASS"

echo -e "\n${CYAN}====================================================================${RESET}"
echo -e "${GREEN}${BOLD}✨ REINSTALL TERJADWAL! REBOOT MEMULAI INSTALASI... ✨${RESET}"
echo -e "${WHITE}► Silakan tunggu 3-5 menit lalu hubungi VPS via SSH:${RESET}"
echo -e "${GREEN}👉 ssh root@<IP-VPS> (Password: $PASS)${RESET}"
echo -e "${CYAN}====================================================================${RESET}\n"

reboot
