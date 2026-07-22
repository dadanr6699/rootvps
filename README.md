# rootvps

Script bash untuk mengaktifkan akses root SSH dan login password pada VPS.

## Fitur

- Cek harus dijalankan sebagai root
- Backup otomatis `/etc/ssh/sshd_config` sebelum diubah
- Menambah direktif SSH jika belum ada (bukan hanya mengganti)
- Validasi `sshd -t` sebelum restart, restore backup jika config rusak (mencegah lockout)
- Restart SSH lintas distro (`sshd` / `ssh` / `service`)

## Cara Penggunaan

Cukup satu perintah (tidak perlu unduh atau `chmod`):

```bash
curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/setup_root.sh | sudo bash
```

Dengan password pilihan sendiri:

```bash
curl -fsSL https://raw.githubusercontent.com/dadanr6699/rootvps/main/setup_root.sh | sudo bash -s -- passwordku
```

*Catatan: Jika password dikosongkan, password bawaan adalah `123Dnstore`*


