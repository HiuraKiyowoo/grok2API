# 🚀 grok2API - Self-Hosted Grok API Gateway

<p align="center">
  <img src="https://img.shields.io/badge/Go-1.26+-00ADD8.svg?style=for-the-badge&logo=go&logoColor=white" alt="Go 1.26+" />
  <img src="https://img.shields.io/badge/React-19-61DAFB.svg?style=for-the-badge&logo=react&logoColor=black" alt="React 19" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="MIT License" />
</p>

<p align="center">
  <strong>Gateway API multi-akun untuk xAI Grok (Grok Build, Grok Web, Grok Console)</strong>
</p>

---

## ✨ Fitur Utama

- **🔥 OpenAI API Compatible**: Endpoint `/v1/chat/completions` dan `/v1/messages` (Anthropic format)
- **🤖 Multi-Model Support**: 
  - **Text**: `grok-3`, `grok-3-reasoner`, `grok-3-deepsearch`, `grok-2`
  - **Image Generation**: `FLUX.1.1-pro`, `FLUX.1-pro`, `FLUX.1-dev`
  - **Video Generation**: `Aurora`
- **🔐 Multi-Account Pool**: Rotasi otomatis antar akun xAI, cooldown handling
- **⚡ Go Native**: Binary ringan (<60MB), konsumsi RAM rendah
- **🎨 React 19 Dashboard**: WebUI modern untuk manajemen akun, API keys, dan logs
- **🛡️ Tool Calling / Function Calling**: Dukungan penuh untuk AI coding agents (Cline, Roo, Cursor)
- **📊 Real-time Logs**: Monitor activity permintaan secara live
- **🔄 Streaming SSE**: Server-Sent Events untuk response streaming

---

## 📦 Instalasi

### Termux / Linux VPS

```bash
# 1. Clone repository
git clone https://github.com/HiuraKiyowoo/grok2API.git
cd grok2API

# 2. Compile backend (Go 1.26+ wajib terinstall)
cd backend
go build -trimpath -ldflags="-s -w" -o ../bin/grok2api-backend ./cmd/grok2api
cd ..

# 3. Salin & edit konfigurasi
cp config.example.yaml config.yaml
nano config.yaml  # Ganti jwtSecret, credentialEncryptionKey, dan password admin

# 4. (Opsional) Edit .env jika perlu override PORT
cp .env.example .env
nano .env

# 5. Jalankan daemon
chmod +x *.sh
./start.sh -d

# 6. Akses dashboard
# http://127.0.0.1:8000
# Login: admin / (password dari config.yaml)
```

**Catatan Penting:**
- Binary `bin/grok2api-backend` **tidak** di-commit ke repo (ada di `.gitignore`), wajib compile manual.
- Secret di `config.yaml` wajib diganti sebelum start pertama kali:
  ```bash
  # Generate JWT secret (min 32 char)
  openssl rand -hex 32
  
  # Generate credential encryption key (base64)
  openssl rand -base64 32
  ```

### Docker

```bash
docker-compose up -d
```

---

## 🎯 Quick Start

### 1. Tambah Akun xAI

Buka dashboard → **Manajemen Akun** → Masukkan **Email & Password** akun xAI Anda atau tempel **Cookie** dari browser (format `__Secure-grok-id=...; grok_session=...`).

### 2. Buat API Key

Dashboard → **API Keys** → Klik **Buat Key Baru** → Salin key yang dihasilkan (format `g2a_xxxxxxxx`).

### 3. Mulai Request

```bash
curl http://127.0.0.1:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer g2a_xxxxxxxx" \
  -d '{
    "model": "grok-3",
    "messages": [
      {"role": "user", "content": "Halo, apa kabar?"}
    ],
    "stream": true
  }'
```

---

## 🔧 Model yang Tersedia

| Model ID                | Tipe      | Deskripsi                                |
|-------------------------|-----------|------------------------------------------|
| `grok-3`                | Text      | Grok 3 terbaru (default)                 |
| `grok-3-reasoner`       | Text      | Grok 3 dengan reasoning deep-think       |
| `grok-3-deepsearch`     | Text      | Grok 3 + Web search realtime             |
| `grok-2`                | Text      | Grok 2 (legacy, lebih cepat)             |
| `FLUX.1.1-pro`          | Image Gen | FLUX 1.1 Pro (kualitas tinggi)           |
| `FLUX.1-pro`            | Image Gen | FLUX 1 Pro                               |
| `FLUX.1-dev`            | Image Gen | FLUX 1 Dev (open model)                  |
| `Aurora`                | Video Gen | Aurora video generation                  |

---

## 🛠️ Perintah Utilitas

```bash
# Jalankan foreground (lihat log langsung)
./start.sh

# Jalankan daemon (background)
./start.sh -d

# Hentikan daemon
./stop.sh

# Update ke versi terbaru
./update.sh

# Lihat log realtime
tail -f logs/output.log
```

---

## 📡 Endpoint API

| Endpoint                          | Method | Deskripsi                          |
|-----------------------------------|--------|------------------------------------|
| `/v1/chat/completions`            | POST   | OpenAI chat completion (streaming) |
| `/v1/messages`                    | POST   | Anthropic messages format          |
| `/v1/models`                      | GET    | Daftar model yang tersedia         |
| `/api/admin/accounts`             | GET    | Manajemen akun (requires ADMIN_KEY)|
| `/api/admin/keys`                 | GET    | Manajemen API keys                 |
| `/api/system/health`              | GET    | Health check                       |

---

## 🔐 Keamanan

- **ADMIN_KEY** di `.env` wajib diganti sebelum deploy production.
- Cookie akun xAI disimpan terenkripsi di database SQLite (`data/grok2api.db`).
- Rate limiting otomatis per akun (cooldown setelah mencapai limit xAI).

---

## 🐛 Troubleshooting

**Q: Frontend tidak muncul / 404**  
A: Pastikan `frontend/dist/` sudah di-build dengan `npm run build`.

**Q: Binary tidak jalan di Termux**  
A: Compile ulang dengan `cd backend && go build -o ../bin/grok2api-backend ./cmd/grok2api`.

**Q: Akun selalu "Rate Limited"**  
A: xAI punya limit gratis tier ketat. Tambah lebih banyak akun atau upgrade ke xAI Premium.

---

## 📄 Lisensi

MIT License - bebas digunakan untuk personal maupun komersial.

---

## 🙏 Credits

- Arsitektur terinspirasi dari [Cxslin/qwen2API](https://github.com/Cxslin/qwen2API) dan [Cxslin/deepseek2API](https://github.com/Cxslin/deepseek2API)
- Upstream original: [YuJunZhiXue/grok2api](https://github.com/YuJunZhiXue/grok2api)
- Gateway framework: HiuraKiyowoo/grok2API

---

**⚡ Built with Go & React | Self-hosted | Privacy-first**
