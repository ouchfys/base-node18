FROM node:18-alpine

# 预装高频全局包
RUN npm install -g pnpm serve

# 安装 ossutil 用于从 OSS 拉取用户代码
RUN apk add --no-cache bash curl && \
    curl -o /usr/local/bin/ossutil64 https://gosspublic.alicdn.com/ossutil/1.7.18/ossutil-v1.7.18-linux-amd64/ossutil64 && \
    chmod +x /usr/local/bin/ossutil64

# 工作目录
WORKDIR /workspace

# 拷贝入口脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
