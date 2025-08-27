FROM alpine:latest

# 安装必要的依赖
RUN apk add --no-cache ca-certificates

# 创建非root用户
RUN addgroup -S -g 1000 mosdns && \
    adduser -S -u 1000 -G mosdns mosdns

WORKDIR /app

# 复制二进制文件 (会在构建时从build目录复制过来)
COPY mosdns /app/mosdns
RUN chmod +x /app/mosdns

# 使用非root用户
USER mosdns

# 默认命令
ENTRYPOINT ["/app/mosdns"]
CMD ["--help"]
