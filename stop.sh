#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PIDS=$(pgrep -f "grok2api-backend")

if [ -z "$PIDS" ]; then
  echo "[-] grok2API tidak sedang berjalan."
else
  echo "[*] Menghentikan grok2API (PID: $(echo $PIDS | tr '\n' ' '))..."
  kill $PIDS
  sleep 1
  if pgrep -f "grok2api-backend" > /dev/null; then
    kill -9 $PIDS
    echo "[✓] grok2API dihentikan (paksa)."
  else
    echo "[✓] grok2API dihentikan."
  fi
  rm -f "$DIR/logs/grok2api.pid"
fi
