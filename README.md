# rootvps

Script bash untuk mengaktifkan akses root SSH dan login password pada VPS.

## Fitur

- Cek harus dijalankan sebagai root
- Backup otomatis `/etc/ssh/sshd_config` sebelum diubah
- Menambah direktif SSH jika belum ada (bukan hanya mengganti)
- Validasi `sshd -t` sebelum restart, restore backup jika config rusak (mencegah lockout)
- Restart SSH lintas distro (`sshd` / `ssh` / `service`)

## Cara Penggunaan

```bash
curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/setup_root.sh | sudo bash
```

Dengan password pilihan sendiri:

```bash
curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/setup_root.sh | sudo bash -s -- passwordku
```

*Catatan: Jika password dikosongkan, password bawaan adalah `123Dnstore`*

---
---

# ⚠️ REBUILD / INSTAL ULANG VPS ⚠️

> **PERINGATAN:** Perintah di bawah ini akan **MENGHAPUS OS saat ini beserta SELURUH data** di VPS. Proses ini **tidak bisa dibatalkan**. Pastikan sudah backup data penting.

Instal ulang OS VPS menggunakan [bin456789/reinstall](https://github.com/bin456789/reinstall).

Default `debian 12`, password `123Dnstore`:

```bash
curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/reinstall.sh | sudo bash
```

Pilih distro / versi / password sendiri:

```bash
curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/reinstall.sh | sudo bash -s -- ubuntu 24.04 passwordku
```

VPS akan reboot otomatis untuk memulai instalasi.

---
---

