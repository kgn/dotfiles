#!/bin/bash
# Setup MCP servers for Claude Code

set -e

echo "Setting up Claude Code MCP servers..."

# Linear MCP Server (Official)
if ! claude mcp list 2>/dev/null | grep -q "linear-server"; then
    echo "  Adding Linear MCP server..."
    claude mcp add --transport http linear-server https://mcp.linear.app/mcp
else
    echo "  Linear MCP server already configured"
fi

echo "Done! MCP servers configured."
echo ""
echo "Note: You'll need to authenticate with Linear the first time you use it."
echo "In a Claude Code session, the MCP will prompt you to authenticate via browser."
