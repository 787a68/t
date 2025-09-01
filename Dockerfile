FROM debian:stable-slim

# 创建工作目录
WORKDIR /tmp

# 根据构建参数下载对应的二进制文件
ARG TARGETARCH=amd64
RUN apt-get update && apt-get install -y curl unzip && \
    if [ "$TARGETARCH" = "amd64" ]; then \
        ARCH_URL="mosdns-linux-amd64.zip"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        ARCH_URL="mosdns-linux-arm64.zip"; \
    fi && \
    echo "Downloading for $TARGETARCH..." && \
    # 这里需要从GitHub Action中传递下载URL作为构建参数
    curl -L -o mosdns.zip "$BINARY_URL" && \
    unzip mosdns.zip && \
    mv mosdns* /usr/bin/mosdns-x && \
    chmod +x /usr/bin/mosdns-x && \
    apt-get remove -y curl unzip && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /etc/mosdns

EXPOSE 53/udp
EXPOSE 53/tcp

# 保持命令兼容原始参数
ENTRYPOINT ["/usr/bin/mosdns-x"]
