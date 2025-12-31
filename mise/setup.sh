#!/bin/bash
# mise setup - runtime installation and language tools

set -e

echo "Installing mise-managed runtimes..."
mise install
mise reshim

# Add mise shims to PATH for this session
export PATH="$HOME/.local/share/mise/shims:$PATH"

echo "Installing Go tools..."
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest

echo "Installing security tools..."
go install github.com/anchore/syft/cmd/syft@latest
go install github.com/anchore/grype/cmd/grype@latest
