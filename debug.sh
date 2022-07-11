#!/bin/sh

export GOPROXY=https://goproxy.cn
export DB_HOST=hst
export DB_USER=sr
dlv --headless --log --listen :9009 --api-version 2 --accept-multiclient debug app.go
