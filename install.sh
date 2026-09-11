#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

say() { printf '\n\033[1;36m%s\033[0m\n' "$1"; }
fail() { printf '\033[1;31m[ERROR]\033[0m %s\n' "$1" >&2; exit 1; }
command -v go >/dev/null 2>&1 || fail "Go tidak ditemukan. Instal Go 1.26 atau lebih baru terlebih dahulu."
command -v node >/dev/null 2>&1 || fail "Node.js tidak ditemukan. Instal Node.js 20 atau lebih baru terlebih dahulu."
command -v openssl >/dev/null 2>&1 || fail "OpenSSL tidak ditemukan. Instal openssl terlebih dahulu."

NODE_MAJOR="$(node -p 'process.versions.node.split(".")[0]')"
GO_VERSION="$(go version | sed -E 's/.*go([0-9]+\.[0-9]+).*/\1/')"
(( NODE_MAJOR >= 20 )) || fail "Node.js minimal versi 20 diperlukan (terdeteksi $NODE_MAJOR)."

say "[1/5] Menyiapkan direktori"
mkdir -p bin data logs
chmod +x start.sh stop.sh update.sh

say "[2/5] Membangun backend Go ($GO_VERSION)"
(cd backend && go build -buildvcs=false -trimpath -ldflags="-s -w" -o ../bin/grok2api-backend ./cmd/grok2api)

say "[3/5] Membangun frontend React"
(cd frontend
  # npm dipakai agar installer tidak gagal karena signature Corepack yang
  # berbeda antar versi Node.js. package.json tetap menjadi sumber dependency.
  npm install --no-audit --no-fund
  npm run build
)

say "[4/5] Membuat konfigurasi awal"
if [ ! -f config.yaml ]; then
  cp config.example.yaml config.yaml
  JWT_SECRET="$(openssl rand -hex 32)"
  CRED_KEY="$(openssl rand -base64 32)"
  sed -i "s|jwtSecret:.*|jwtSecret: \"$JWT_SECRET\"|" config.yaml
  sed -i "s|credentialEncryptionKey:.*|credentialEncryptionKey: \"$CRED_KEY\"|" config.yaml
  sed -i 's|password:.*replace-with-a-strong-password.*|password: "admin123456"|' config.yaml
  chmod 600 config.yaml
  echo "Konfigurasi dibuat. Password awal: admin123456"
else
  echo "config.yaml sudah ada; tidak ditimpa."
fi

say "[5/5] Instalasi selesai"
printf '%s\n' \
  'Jalankan foreground : ./start.sh' \
  'Jalankan background : ./start.sh -d' \
  'Dashboard           : http://127.0.0.1:8000' \
  'Log                 : tail -f logs/output.log' \
  '' \
  'Segera ganti password admin dari menu Pengaturan sebelum dipakai di server publik.'
