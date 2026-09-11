# Backend Grok2API

Backend Go Grok2API menangani penjadwalan akun upstream, konversi protokol, manajemen kuota, audit request, dan API administrasi. Backend juga dapat menyajikan hasil build frontend secara langsung.

## Teknologi

- Go 1.26, Gin, dan GORM
- SQLite atau PostgreSQL
- Memory atau Redis
- Provider Grok Build OAuth dan Grok Web SSO

## Menjalankan Secara Lokal

File konfigurasi berada di root repository. Sebelum menjalankan pertama kali, buat konfigurasi lokal dan secret yang aman:

```bash
cp config.example.yaml config.yaml
openssl rand -hex 32
openssl rand -base64 32
```

Masukkan hasilnya ke bagian `secrets` di `config.yaml`, ganti password awal `bootstrapAdmin`, lalu jalankan:

```bash
cd backend
go run ./cmd/grok2api
```

Layanan secara default berjalan di `http://127.0.0.1:8000`. Konfigurasi atau alamat listen juga dapat ditentukan secara eksplisit:

```bash
go run ./cmd/grok2api --config /path/to/config.yaml --listen 0.0.0.0:8000
```

## Konfigurasi dan Penyimpanan

Konfigurasi startup dikelola melalui `config.yaml` di root. Field yang tersedia dirangkum dalam [`config.example.yaml`](../config.example.yaml). Provider, kapasitas layanan, task batch, routing, media, audit, dan batas default client key disimpan melalui halaman Pengaturan dashboard. Field yang tidak ditandai “perlu restart” dapat dimuat ulang tanpa restart.

| Skenario | Database | Penyimpanan runtime |
| --- | --- | --- |
| Pengembangan lokal atau satu instance | SQLite | Memory |
| Deployment multi-instance | PostgreSQL | Redis |

Database relasional menyimpan akun, kredensial, model, kuota, client key, audit, dan task media. Redis hanya menyimpan rate limit, lease concurrency, sticky routing, distributed lock, dan notifikasi event. Kredensial sensitif dienkripsi menggunakan `credentialEncryptionKey`; kunci ini harus disimpan permanen dan tidak boleh di-commit ke repository.

## Endpoint Layanan

- `/v1/*`: API kompatibel
- `/api/admin/v1/*`: API administrasi
- `/healthz` dan `/readyz`: probe kesehatan dan kesiapan
- `/swagger/index.html`: Swagger API, hanya aktif jika `server.swaggerEnabled: true`
- `frontend.staticPath`: direktori static frontend, default `./frontend/dist`

Detail protokol tersedia di [`docs`](./docs). Setelah mengubah komentar endpoint publik, jalankan `make swagger` dari root repository untuk memperbarui dokumentasi Swagger. Untuk production, pertahankan `server.swaggerEnabled: false`.

## Struktur Kode

```text
cmd/grok2api/          entrypoint proses
internal/domain/       model dan aturan domain
internal/application/  layanan aplikasi dan use case
internal/infra/        database, provider, runtime, dan keamanan
internal/transport/    route HTTP, autentikasi, dan adapter protokol
internal/repository/   interface persistence
```

Arah dependency dipertahankan sebagai Transport → Application → Domain. Infrastruktur dihubungkan melalui interface dan domain tidak bergantung langsung pada HTTP, database, atau provider tertentu.

## Validasi

```bash
go test ./...
go test -race ./...
go vet ./...
go build ./cmd/grok2api
```
