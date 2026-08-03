<div align="center">

# 🚀 RootVPS - Root Access & OS Reinstall Tool

[![Bash](https://img.shields.io/badge/Bash-Script-4EAA25.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Linux](https://img.shields.io/badge/Linux-Server-FCC624.svg?style=for-the-badge&logo=linux&logoColor=black)](https://www.kernel.org)
[![SSH](https://img.shields.io/badge/SSH-OpenSSH-4D1AA8.svg?style=for-the-badge&logo=openssh&logoColor=white)](https://www.openssh.com)
[![Status](https://img.shields.io/badge/Status-Active-success.svg?style=for-the-badge)]()
[![License](https://img.shields.io/badge/License-MIT-orange.svg?style=for-the-badge)]()

**Kumpulan skrip Bash modern untuk mengaktifkan akses SSH root, password authentication, serta melakukan instal ulang / rebuild OS VPS secara otomatis.**

[🔑 Aktifkan Root SSH](#-1-aktifkan-akses-root-ssh) • [⚠️ Instal Ulang OS](#%EF%B8%8F-2-instal-ulang--rebuild-os-vps) • [✨ Fitur Utama](#-fitur-utama) • [🐧 Dukungan Distro](#-dukungan-distro)

---

</div>

## ✨ Fitur Utama

| Fitur | Deskripsi | Status |
| :--- | :--- | :---: |
| 🔑 **Root SSH Enabler** | Mengaktifkan `PermitRootLogin` & `PasswordAuthentication` instan | ✅ |
| ☁️ **Cloud-Init Override** | Mengatasi pembatasan SSH bawaan AWS, GCP, DigitalOcean, Hetzner, Vultr | ✅ |
| 🛡️ **Auto Backup & Rollback** | Backup otomatis `/etc/ssh/sshd_config` sebelum diubah (anti-lockout) | ✅ |
| 🔄 **Cross-Distro Service Restart** | Mengidentifikasi & merestart `sshd` / `ssh` di semua Linux distro | ✅ |
| 🚀 **1-Click OS Reinstall** | Rebuild / reinstall OS VPS (Debian, Ubuntu, Alpine, Alma, Rocky) | ✅ |

---

## 🔑 1. Aktifkan Akses Root SSH

Perintah cepat 1-baris untuk mengaktifkan akses login SSH sebagai `root` dengan password bawaan (`123Dnstore`):

```bash
curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/setup_root.sh | sudo bash
```

### 💡 Menggunakan Password Kustom
Jika Anda ingin menentukan password root sendiri:

```bash
curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/setup_root.sh | sudo bash -s -- passwordku
```

> [!NOTE]
> Skrip ini secara otomatis membuka akun root yang terkunci (`usermod -U root`), mengonfigurasi `sshd_config`, dan membuat override drop-in di `/etc/ssh/sshd_config.d/` untuk menjamin akses root berhasil 100%.

---

## ⚠️ 2. Instal Ulang / Rebuild OS VPS

> [!CAUTION]
> **PERINGATAN HARD RESET:** Perintah di bawah ini akan **MENGHAPUS SELURUH OS & DATA** di VPS secara permanen! Pastikan Anda sudah membuat cadangan data penting sebelum melanjutkannya.

### A. Instal Ulang Default (Debian 12, Password: `123Dnstore`)
```bash
curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/reinstall.sh | sudo bash
```

### B. Pilih Distro, Versi & Password Sendiri
```bash
# Contoh 1: Ubuntu 24.04 dengan Password 'passwordku'
curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/reinstall.sh | sudo bash -s -- ubuntu 24.04 passwordku

# Contoh 2: Debian 11 dengan Password 'mysecret'
curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/reinstall.sh | sudo bash -s -- debian 11 mysecret
```

---

## 🐧 Dukungan Distro

| Distro Linux | Versi Didukung | Status |
| :--- | :--- | :---: |
| 🌀 **Debian** | 12 (Bookworm), 11 (Bullseye), 10 | ✅ |
| 🟠 **Ubuntu** | 24.04 LTS, 22.04 LTS, 20.04 LTS | ✅ |
| 🏔️ **Alpine** | 3.20, 3.19 | ✅ |
| 🟢 **Rocky Linux** | 9, 8 | ✅ |
| 🔵 **AlmaLinux** | 9, 8 | ✅ |

---

<div align="center">

Made with ❤️ for **VPS Administrators**

</div>
