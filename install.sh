#!/bin/bash
set -e

echo "========================================"
echo "  grok2API Quick Installer"
echo "========================================"
echo ""

# 1. Compile backend
echo "[1/5] Compiling backend..."
cd backend
go build -trimpath -ldflags="-s -w" -o ../bin/grok2api-backend ./cmd/grok2api
cd ..
echo "✓ Backend compiled"

# 2. Build frontend
echo "[2/5] Building frontend..."
cd frontend
npm install --silent
npm run build
cd ..
echo "✓ Frontend built"

# 3. Setup config
echo "[3/5] Generating config..."
if [ ! -f config.yaml ]; then
  cp config.example.yaml config.yaml
  
  # Generate secrets
  JWT_SECRET=$(openssl rand -hex 32)
  CRED_KEY=$(openssl rand -base64 32)
  
  # Replace placeholders (works on both Linux and macOS)
  if [ "$(uname)" = "Darwin" ]; then
    sed -i '' "s|jwtSecret:.*|jwtSecret: \"$JWT_SECRET\"|" config.yaml
    sed -i '' "s|credentialEncryptionKey:.*|credentialEncryptionKey: \"$CRED_KEY\"|" config.yaml
    sed -i '' "s|password:.*replace-with-a-strong-password.*|password: \"admin123456\"|" config.yaml
  else
    sed -i "s|jwtSecret:.*|jwtSecret: \"$JWT_SECRET\"|" config.yaml
    sed -i "s|credentialEncryptionKey:.*|credentialEncryptionKey: \"$CRED_KEY\"|" config.yaml
    sed -i "s|password:.*replace-with-a-strong-password.*|password: \"admin123456\"|" config.yaml
  fi
  
  echo "✓ Config generated with random secrets"
else
  echo "✓ Config already exists (skipped)"
fi

# 4. Make scripts executable
echo "[4/5] Setting permissions..."
chmod +x *.sh
echo "✓ Scripts executable"

# 5. Create directories
echo "[5/5] Creating directories..."
mkdir -p data logs bin
echo "✓ Directories created"

echo ""
echo "========================================"
echo "  Installation Complete!"
echo "========================================"
echo ""
echo "Start the server:"
echo "  ./start.sh -d"
echo ""
echo "Dashboard:"
echo "  http://127.0.0.1:8000"
echo ""
echo "Login credentials:"
echo "  Username: admin"
echo "  Password: admin123456"
echo ""
echo "Change password in config.yaml before production use!"
echo ""
