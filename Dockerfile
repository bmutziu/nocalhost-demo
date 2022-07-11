FROM golang:1.18.3-alpine3.16 as builder

WORKDIR /app

COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download

COPY static/index.html ./static/index.html
COPY app.go .
RUN go build -o kubevela-nocalhost-demo-app app.go
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# FROM alpine:3.16
FROM golang:1.18.3-alpine3.16
LABEL org.opencontainers.image.source=https://github.com/bmutziu/nocalhost-demo
WORKDIR /app
COPY app.go .
COPY static/index.html ./static/index.html
COPY --from=builder /app/kubevela-nocalhost-demo-app /app/kubevela-nocalhost-demo-app
COPY --from=builder /go/bin/dlv /usr/bin/dlv
ENV DB_HOST="host"
ENV DB_USER="user"
# ENTRYPOINT ./kubevela-nocalhost-demo-app
ENTRYPOINT CGO_ENABLED=0 dlv --headless --log --listen :9009 --api-version 2 --accept-multiclient debug app.go

# EXPOSE 9080
EXPOSE 9009 9080
