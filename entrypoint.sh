#!/bin/bash
set -e

echo "=== [entrypoint] Starting container for project: $PROJECT_ID ==="

# 1. 配置 ossutil 凭证（ossutil2 使用环境变量）
export OSS_ACCESS_KEY_ID="$OSS_ACCESS_KEY_ID"
export OSS_ACCESS_KEY_SECRET="$OSS_ACCESS_KEY_SECRET"

# 2. 从 OSS 拉取用户项目代码
echo "=== [entrypoint] Pulling code from OSS ==="
ossutil cp "oss://$OSS_BUCKET/projects/$PROJECT_ID/" /workspace/ -r -f --endpoint "$OSS_ENDPOINT" --region cn-shenzhen

# 3. 安装依赖
if [ -f /workspace/scripts/prepare.sh ]; then
  echo "=== [entrypoint] Running prepare.sh ==="
  bash /workspace/scripts/prepare.sh
elif [ -f /workspace/package.json ]; then
  echo "=== [entrypoint] Running npm install ==="
  cd /workspace && npm install
fi

# 4. 启动开发服务器（必须监听 9000 端口）
if [ -f /workspace/scripts/dev.sh ]; then
  echo "=== [entrypoint] Running dev.sh ==="
  bash /workspace/scripts/dev.sh
else
  echo "=== [entrypoint] Serving static files on port 9000 ==="
  cd /workspace && npx serve -s . -l 9000
fi
