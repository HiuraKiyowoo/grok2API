#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "=========================================="
echo " Memperbarui grok2API ke Versi Terbaru "
echo "=========================================="

# 1. Hentikan layanan jika sedang berjalan
if [ -f "$DIR/stop.sh" ]; then
  echo "[1/4] Menghentikan layanan grok2API..."
  bash "$DIR/stop.sh"
fi

# 2. Pull perubahan dari GitHub
echo "[2/4] Menarik pembaruan dari GitHub..."
git pull origin main

# 3. Rebuild backend
echo "[3/4] Membangun ulang backend Go..."
cd backend
go build -trimpath -ldflags="-s -w" -o ../bin/grok2api-backend ./cmd/grok2api
cd ..

# 4. Rebuild frontend
echo "[4/4] Membangun ulang frontend React..."
cd frontend
npm install
npm run build
cd ..

echo "=========================================="
echo "[✓] Pembaruan selesai!"
echo "=========================================="
echo ""
echo "Jalankan dengan: ./start.sh -d"
