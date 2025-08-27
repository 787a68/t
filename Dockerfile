FROM alpine:latest

# 安装必要的依赖，包括tzdata用于时区支持
RUN apk add --no-cache ca-certificates tzdata

# 创建配置目录
RUN mkdir -p /etc/mosdns

# 复制二进制文件
COPY mosdns /usr/local/bin/mosdns
RUN chmod +x /usr/local/bin/mosdns

# 设置工作目录
WORKDIR /etc/mosdns
