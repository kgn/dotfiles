#!/bin/bash
# mise setup - runtime installation and language tools

set -e

echo "Installing mise-managed runtimes..."
mise install

echo "Installing Go tools..."
mise exec -- go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
mise exec -- go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
mise exec -- go install honnef.co/go/tools/cmd/staticcheck@latest
mise exec -- go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
mise exec -- go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest

echo "Installing security tools..."
mise exec -- go install github.com/anchore/syft/cmd/syft@latest
mise exec -- go install github.com/anchore/grype/cmd/grype@latest
