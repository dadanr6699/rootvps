#!/usr/bin/env bash
export TERM="${TERM:-xterm}"
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

if [ -t 1 ] && [ -n "${TERM:-}" ] && [ "$TERM" != "dumb" ]; then
  clear 2>/dev/null || true
fi

echo -e "${RED}${BOLD}"
cat << "EOF"
    ____  _____ ___ _   _ ____ _____  _    _     _     
   |  _ \| ____|_ _| \ | / ___|_   _|/ \  | |   | |    
   | |_) |  _|  | ||  \| \___ \ | | / _ \ | |   | |    
   |  _ <| |___ | || |\  |___) || |/ ___ \| |___| |___ 
   |_| \_\_____|___|_| \_|____/ |_/_/   \_\_____|_____|
EOF
echo -e "${YELLOW}${BOLD}⚠️ PERINGATAN: INSTAL ULANG / REBUILD SISTEM OPERASI VPS ⚠️${RESET}"
echo -e "${RED}====================================================================${RESET}\n"

DISTRO=${1:-debian}
VERSION=${2:-12}
PASS=${3:-123Dnstore}

echo -e "${WHITE}► Target OS Distro : ${GREEN}${BOLD}${DISTRO} ${VERSION}${RESET}"
echo -e "${WHITE}► Password Root    : ${GREEN}${BOLD}${PASS}${RESET}"
echo -e "${RED}${BOLD}⚠️ PERINGATAN: Seluruh data & sistem OS VPS akan DIHAPUS TOTAL!${RESET}\n"

# Step 1: Download upstream engine silently
echo -e "${BLUE}${BOLD}[1/2] 📥 MENGUNDUH UPSTREAM REINSTALL ENGINE...${RESET}"
cd /root
if ! curl -fsSL -o reinstall_upstream.sh https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh > /dev/null 2>&1; then
  wget -q -O reinstall_upstream.sh https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh > /dev/null 2>&1
fi
echo -e "${GREEN}✔ Engine reinstall berhasil diunduh.${RESET}\n"

# Step 2: Prepare OS Packages & Kernel image silently
echo -e "${BLUE}${BOLD}[2/2] ⚙️ MENYIAPKAN PAKET INSTALASI ($DISTRO $VERSION)...${RESET}"
echo -e "${DIM}► Memproses image kernel & mengonfigurasi booting (Mohon tunggu)...${RESET}"

USER_ARG="root"
if [ "$(echo "$DISTRO" | tr '[:upper:]' '[:lower:]')" = "windows" ]; then
  USER_ARG="administrator"
fi

if ! bash reinstall_upstream.sh "$DISTRO" "$VERSION" --user "$USER_ARG" --password "$PASS" > /tmp/reinstall_prep.log 2>&1; then
  echo -e "${RED}✖ Gagal menyiapkan paket instalasi $DISTRO $VERSION.${RESET}"
  echo -e "${RED}Detail Error Log:${RESET}"
  tail -n 15 /tmp/reinstall_prep.log
  rm -f /root/reinstall_upstream.sh 2>/dev/null || true
  exit 1
fi
echo -e "${GREEN}✔ Paket & konfigurasi image OS $DISTRO $VERSION siap.${RESET}\n"

# Interactive Reboot Confirmation Prompt
echo -e "${CYAN}====================================================================${RESET}"
echo -e "${YELLOW}${BOLD}❓ KONFIRMASI REBOOT & EKSEKUSI FINAL:${RESET}"
echo -e "${WHITE}Apakah Anda ingin melakukan reboot SEKARANG untuk memulai proses instal ulang OS?${RESET}"
echo -e "${GREEN}  [y] Ya, Reboot sekarang & mulai instal ulang OS (${DISTRO} ${VERSION})${RESET}"
echo -e "${RED}  [n] Tidak, Batalkan reboot & batalkan instal ulang${RESET}"
echo -e "${CYAN}====================================================================${RESET}"

DO_REBOOT=""
if [ -t 0 ]; then
  read -p "$(echo -e "${CYAN}👉 Pilih opsi (y/N): ${RESET}")" DO_REBOOT || true
elif [ -t 1 ]; then
  read -p "$(echo -e "${CYAN}👉 Pilih opsi (y/N): ${RESET}")" DO_REBOOT < /dev/tty 2>/dev/null || true
fi

if [[ "$DO_REBOOT" =~ ^[Yy]$ ]]; then
  echo -e "\n${CYAN}====================================================================${RESET}"
  echo -e "${GREEN}${BOLD}✨ REBOOT DIKONFIRMASI! MEMULAI INSTAL ULANG OS VPS... ✨${RESET}"
  echo -e "${WHITE}► Silakan tunggu 3-5 menit lalu hubungi VPS via SSH:${RESET}"
  echo -e "${GREEN}👉 ssh root@<IP-VPS> (Password: $PASS)${RESET}"
  echo -e "${CYAN}====================================================================${RESET}\n"
  reboot
else
  echo -e "\n${YELLOW}====================================================================${RESET}"
  echo -e "${RED}${BOLD}✖ REBOOT & INSTAL ULANG DIBATALKAN OLEH PENGGUNA.${RESET}"
  echo -e "${WHITE}► VPS Anda TIDAK di-reboot & tidak ada perubahan OS yang diterapkan.${RESET}"
  echo -e "${YELLOW}====================================================================${RESET}\n"
  rm -f /root/reinstall_upstream.sh /tmp/reinstall_prep.log 2>/dev/null || true
  exit 0
fi
