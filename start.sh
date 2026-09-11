#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

PORT="${PORT:-8000}"

if [ "$1" = "--daemon" ] || [ "$1" = "-d" ]; then
  if pgrep -f "grok2api-backend" > /dev/null; then
    PID=$(pgrep -f "grok2api-backend" | tr '\n' ' ')
    echo "[-] grok2API sudah berjalan (PID: $PID)"
    exit 1
  fi
  
  mkdir -p logs
  echo "[*] Memulai grok2API dalam mode daemon (port $PORT)..."
  nohup ./bin/grok2api-backend > logs/output.log 2>&1 &
  PID=$!
  echo $PID > logs/grok2api.pid
  sleep 1
  
  if kill -0 $PID 2>/dev/null; then
    echo "[✓] grok2API berjalan (PID: $PID)"
    echo "[✓] Dashboard: http://127.0.0.1:$PORT"
    echo "[✓] Log: tail -f logs/output.log"
  else
    echo "[✗] Gagal memulai grok2API"
    exit 1
  fi
else
  echo "[*] Memulai grok2API (port $PORT)..."
  echo "[*] Dashboard: http://127.0.0.1:$PORT"
  exec ./bin/grok2api-backend
fi
