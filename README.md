# rootvps

Script bash untuk mengaktifkan akses root SSH dan login password pada VPS.

## Fitur

- Cek harus dijalankan sebagai root
- Backup otomatis `/etc/ssh/sshd_config` sebelum diubah
- Menambah direktif SSH jika belum ada (bukan hanya mengganti)
- Validasi `sshd -t` sebelum restart, restore backup jika config rusak (mencegah lockout)
- Restart SSH lintas distro (`sshd` / `ssh` / `service`)

## Cara Penggunaan

1. Unduh script:
   ```bash
   wget https://raw.githubusercontent.com/dadanr6699/rootvps/main/setup_root.sh
   ```
2. Berikan izin eksekusi:
   ```bash
   chmod +x setup_root.sh
   ```
3. Jalankan script:
   ```bash
   sudo ./setup_root.sh [password_pilihan]
   ```
   *Catatan: Jika password dikosongkan, password bawaan adalah `123Dnstore`*

