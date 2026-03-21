FROM node:18-alpine

# 预装高频全局包
RUN npm config set registry https://registry.npmmirror.com && \
    npm install -g pnpm serve

# 安装 ossutil2 用于从 OSS 拉取用户代码
RUN apk add --no-cache bash curl unzip && \
    curl -o /tmp/ossutil.zip https://gosspublic.alicdn.com/ossutil/v2/2.2.1/ossutil-2.2.1-linux-amd64.zip && \
    unzip /tmp/ossutil.zip -d /tmp/ossutil && \
    mv /tmp/ossutil/ossutil-2.2.1-linux-amd64/ossutil /usr/local/bin/ossutil && \
    chmod +x /usr/local/bin/ossutil && \
    rm -rf /tmp/ossutil /tmp/ossutil.zip

# 工作目录
WORKDIR /workspace

# 拷贝入口脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
