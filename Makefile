#!/usr/bin/bash env

.PHONY: app

linux:
	GOOS=linux GOARCH=amd64 make app

darwin:
	GOOS=darwin GOARCH=arm64 make app

app:
	go build -o bin/app ./app.go
