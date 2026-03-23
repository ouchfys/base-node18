#!/bin/bash
set -e

echo "=== [entrypoint] Starting container for project: $PROJECT_ID ==="

export OSS_ACCESS_KEY_ID="$OSS_ACCESS_KEY_ID"
export OSS_ACCESS_KEY_SECRET="$OSS_ACCESS_KEY_SECRET"

echo "=== [entrypoint] Pulling code from OSS ==="
ossutil cp "oss://$OSS_BUCKET/projects/$PROJECT_ID/" /workspace/ -r -f --endpoint "$OSS_ENDPOINT" --region cn-shenzhen

if [ -f /workspace/scripts/prepare.sh ]; then
  echo "=== [entrypoint] Running prepare.sh ==="
  bash /workspace/scripts/prepare.sh
elif [ -f /workspace/requirements.txt ]; then
  echo "=== [entrypoint] Running pip install ==="
  pip3 install -r /workspace/requirements.txt --break-system-packages
elif [ -f /workspace/package.json ]; then
  echo "=== [entrypoint] Running npm install ==="
  cd /workspace && npm install
fi

if [ -f /workspace/scripts/dev.sh ]; then
  echo "=== [entrypoint] Running dev.sh ==="
  bash /workspace/scripts/dev.sh
elif [ -f /workspace/app.py ]; then
  echo "=== [entrypoint] Starting Python server on port 9000 ==="
  cd /workspace && python3 app.py
else
  echo "=== [entrypoint] Serving static files on port 9000 ==="
  cd /workspace && npx serve -s . -l 9000
fi
