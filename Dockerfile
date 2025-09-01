FROM --platform=$BUILDPLATFORM golang:latest AS builder

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG MOSDNS_VERSION=main

WORKDIR /src
RUN git clone --depth 1 --branch ${MOSDNS_VERSION} https://github.com/pmkol/mosdns-x.git .
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o mosdns-x ./cmd/mosdns

FROM debian:stable-slim

WORKDIR /etc/mosdns
COPY --from=builder /src/mosdns-x /usr/bin/mosdns-x

EXPOSE 53/udp
EXPOSE 53/tcp

# 保持命令兼容原始参数
ENTRYPOINT ["/usr/bin/mosdns-x"]
