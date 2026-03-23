FROM docker.m.daocloud.io/library/node:18-alpine

# 安装 Python 和系统依赖
RUN apk add --no-cache python3 py3-pip bash curl unzip

# 配置 npm 镜像源并安装 Node 全局包
RUN npm config set registry https://registry.npmmirror.com && \
    npm install -g pnpm serve

# 安装 ossutil2
RUN curl -o /tmp/ossutil.zip https://gosspublic.alicdn.com/ossutil/v2/2.2.1/ossutil-2.2.1-linux-amd64.zip && \
    unzip /tmp/ossutil.zip -d /tmp/ossutil && \
    mv /tmp/ossutil/ossutil-2.2.1-linux-amd64/ossutil /usr/local/bin/ossutil && \
    chmod +x /usr/local/bin/ossutil && \
    rm -rf /tmp/ossutil /tmp/ossutil.zip

# 预装常用 Python 包
RUN pip3 install --no-cache-dir flask fastapi uvicorn requests python-dotenv --break-system-packages

WORKDIR /workspace

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
