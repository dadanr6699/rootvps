#!/bin/bash
# reinstall.sh - Instal ulang / rebuild OS VPS via bin456789/reinstall
# PERINGATAN: Ini MENGHAPUS OS saat ini beserta semua data. Tidak bisa dibatalkan.
# Cara pakai:
#   curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/reinstall.sh | sudo bash
#   ... | sudo bash -s -- debian 12
#   ... | sudo bash -s -- ubuntu 24.04 passwordku
set -euo pipefail

DISTRO=${1:-debian}
VERSION=${2:-12}
PASS=${3:-123Dnstore}

# --- harus root ---
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: jalankan sebagai root (gunakan sudo)." >&2
  exit 1
fi

echo "=============================================="
echo " Instal ulang VPS -> $DISTRO $VERSION"
echo " Password root akan menjadi: $PASS"
echo " PERINGATAN: OS saat ini dan SEMUA data akan dihapus!"
echo "=============================================="

# --- unduh reinstall.sh dari upstream ---
cd /root
curl -fsSL -o reinstall_upstream.sh https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh \
  || wget -O reinstall_upstream.sh https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh

# --- jalankan instal ulang lalu reboot ---
bash reinstall_upstream.sh "$DISTRO" "$VERSION" --password "$PASS"

echo "Instal ulang sudah disiapkan. Melakukan reboot untuk memulai instalasi..."
reboot
