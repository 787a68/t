# Dockerfile

# 使用 ARG 接收来自 build 命令的参数
ARG VERSION
ARG TARGETARCH

# --- 构建阶段 ---
# 此阶段负责根据架构下载对应的二进制文件
FROM alpine:latest AS builder
ARG VERSION
ARG TARGETARCH

# 安装下载和解压所需的工具
RUN apk add --no-cache curl unzip

# 下载 mosdns-x 的预编译二进制文件
RUN curl -sSL "https://github.com/pmkol/mosdns-x/releases/download/${VERSION}/mosdns-linux-${TARGETARCH}.zip" -o mosdns.zip && \
    unzip mosdns.zip mosdns && \
    chmod +x mosdns

# --- 最终镜像阶段 ---
# 这是最终发布的镜像，基于轻量的 alpine
FROM alpine:latest

LABEL maintainer="YourGitHubUsername"
LABEL org.opencontainers.image.source="https://github.com/YourGitHubUsername/YourRepoName"
LABEL org.opencontainers.image.description="mosdns-x Docker image with support for all original commands."
LABEL org.opencontainers.image.licenses="MIT"

# 从构建阶段复制 mosdns 可执行文件到最终镜像
COPY --from=builder /mosdns /usr/bin/mosdns

# 安装必要的依赖并创建配置文件目录
RUN apk add --no-cache ca-certificates tzdata && \
    mkdir /etc/mosdns

# 声明配置文件卷，方便用户挂载自己的配置
VOLUME /etc/mosdns

# 暴露 DNS 服务所需的标准端口
EXPOSE 53/tcp
EXPOSE 53/udp

# 设置容器的入口点，使其可以直接接收 mosdns 的所有命令
ENTRYPOINT ["/usr/bin/mosdns"]

# 设置默认执行的命令。这是最常见的启动方式。
# 用户可以在 `docker run` 时轻松覆盖此命令及其参数。
CMD ["start", "--dir", "/etc/mosdns"]
