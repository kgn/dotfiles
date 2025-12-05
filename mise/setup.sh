#!/bin/bash
# mise setup - runtime installation and language tools

set -e

echo "Installing mise-managed runtimes..."
mise install

echo "Installing Go tools..."
mise exec -- go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
mise exec -- go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
