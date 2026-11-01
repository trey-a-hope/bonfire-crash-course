#!/bin/bash
#
# Expose the local Rive MCP server (127.0.0.1:9791/mcp) through ngrok so it
# can be added as a custom connector in Claude.
#
# Usage:
#   ./start_rive_tunnel.sh                          # random ngrok URL (changes every run)
#   ./start_rive_tunnel.sh your-name.ngrok-free.app # your free static domain (recommended)
#   NGROK_DOMAIN=your-name.ngrok-free.app ./start_rive_tunnel.sh
#
# WARNING: while this tunnel runs, anyone with the URL can control Rive.
# Press Ctrl+C to stop it when you're done.

set -e # Exit immediately if a command fails during setup

RIVE_HOST="127.0.0.1"
RIVE_PORT=9791
MCP_PATH="/mcp"
DOMAIN="${1:-$NGROK_DOMAIN}"

# 1. Check if ngrok is already installed
if ! command -v ngrok &> /dev/null; then
    echo "ngrok could not be found. Starting automated installation..."

    OS="$(uname -s)"
    ARCH="$(uname -m)"

    # Determine binary architecture string
    case "$ARCH" in
        x86_64)  NARCH="amd64" ;;
        aarch64|arm64) NARCH="arm64" ;;
        *)
            echo "Error: Unsupported architecture ($ARCH)."
            exit 1
            ;;
    esac

    # Determine OS download URL
    case "$OS" in
        Linux)
            URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-${NARCH}.tgz"
            echo "Downloading ngrok for Linux (${NARCH})..."
            curl -sSL "$URL" | tar -xz -C /tmp
            ;;
        Darwin)
            URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-${NARCH}.zip"
            echo "Downloading ngrok for macOS (${NARCH})..."
            curl -sSL -o /tmp/ngrok.zip "$URL"
            unzip -q /tmp/ngrok.zip -d /tmp
            rm /tmp/ngrok.zip
            ;;
        *)
            echo "Error: Unsupported operating system ($OS)."
            exit 1
            ;;
    esac

    # Install to /usr/local/bin (requires sudo if not run as root)
    echo "Installing ngrok to /usr/local/bin..."
    if [ -w /usr/local/bin ]; then
        mv /tmp/ngrok /usr/local/bin/ngrok
    else
        sudo mv /tmp/ngrok /usr/local/bin/ngrok
    fi

    echo "ngrok installed successfully!"
fi

# 2. Check if an auth token is configured
# Checking the config file directly prevents launching ngrok just to check auth status
OS="$(uname -s)"
if [ "$OS" = "Darwin" ]; then
    CONFIG_FILE="$HOME/Library/Application Support/ngrok/ngrok.yml"
else
    CONFIG_FILE="$HOME/.config/ngrok/ngrok.yml"
fi

if [ ! -f "$CONFIG_FILE" ] || ! grep -q "authtoken:" "$CONFIG_FILE" 2>/dev/null; then
    echo ""
    echo "=========================================================================="
    echo "ngrok authtoken is required to run tunnels."
    echo "1. Get your free token at: https://dashboard.ngrok.com/get-started/your-authtoken"
    echo "=========================================================================="
    read -p "Paste your ngrok Authtoken here: " AUTH_TOKEN

    if [ -n "$AUTH_TOKEN" ]; then
        ngrok config add-authtoken "$AUTH_TOKEN"
        echo "Authtoken saved!"
    else
        echo "Error: No authtoken provided. Exiting."
        exit 1
    fi
fi

# 3. Make sure the Rive MCP server is actually running before opening a tunnel
echo "Checking for the Rive MCP server at http://${RIVE_HOST}:${RIVE_PORT}${MCP_PATH}..."
if ! curl -s -o /dev/null --max-time 3 "http://${RIVE_HOST}:${RIVE_PORT}${MCP_PATH}"; then
    echo "Error: Nothing is answering on ${RIVE_HOST}:${RIVE_PORT}."
    echo "Open Rive and make sure its MCP server is enabled, then run this again."
    exit 1
fi
echo "Rive MCP server is up."

# 4. Start the tunnel
# --host-header=rewrite makes requests look like they came from localhost,
# since local servers often reject requests addressed to another hostname.
NGROK_ARGS=(http "${RIVE_HOST}:${RIVE_PORT}" --host-header=rewrite)

echo ""
echo "=========================================================================="
if [ -n "$DOMAIN" ]; then
    NGROK_ARGS+=(--url="$DOMAIN")
    echo "Custom connector URL for Claude:"
    echo "  https://${DOMAIN}${MCP_PATH}"
else
    echo "No static domain set, so the URL will change every run."
    echo "Custom connector URL for Claude: the https 'Forwarding' URL below + ${MCP_PATH}"
    echo "Tip: claim a free static domain at https://dashboard.ngrok.com/domains"
    echo "     and run: $0 your-name.ngrok-free.app"
fi
echo ""
echo "Request log: http://127.0.0.1:4040   |   Stop the tunnel: Ctrl+C"
echo "=========================================================================="
echo ""

ngrok "${NGROK_ARGS[@]}"