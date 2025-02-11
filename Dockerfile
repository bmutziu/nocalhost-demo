FROM golang:1.18.3-alpine3.16 as builder

WORKDIR /app

COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download

COPY static/index.html ./static/index.html
COPY app.go .
RUN go build -o kubevela-nocalhost-demo-app app.go

FROM alpine:3.16
LABEL org.opencontainers.image.source=https://github.com/bmutziu/nocalhost-demo
WORKDIR /app
COPY app.go .
COPY static/index.html ./static/index.html
COPY --from=builder /app/kubevela-nocalhost-demo-app /app/kubevela-nocalhost-demo-app
ENV DB_HOST="host"
ENV DB_USER="user"
ENTRYPOINT ./kubevela-nocalhost-demo-app

EXPOSE 9080
