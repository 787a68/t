FROM golang:latest as builder

COPY ./ /root/src/
WORKDIR /root/src/
RUN go build -ldflags "-s -w -X main.version=$(git describe --tags --long --always)" -trimpath -o mosdns

FROM alpine:latest

# 安装必要的依赖
RUN apk add --no-cache ca-certificates tzdata

# 从构建阶段复制二进制文件
COPY --from=builder /root/src/mosdns /usr/local/bin/mosdns

# 设置权限
RUN chmod +x /usr/local/bin/mosdns

# 创建配置目录
RUN mkdir -p /etc/mosdns

# 设置工作目录
WORKDIR /etc/mosdns

# 默认命令
CMD ["mosdns", "--help"]
