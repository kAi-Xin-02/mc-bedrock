#!/bin/bash

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
fi

echo "🚀 Minecraft Bedrock One-Click Installer"
echo "======================================"

# 1. Install Dependencies
echo "📦 Installing requirements (tmux, jq, unzip, curl)..."
if [[ "$OS" == *"Arch"* ]] || [[ "$OS" == *"Manjaro"* ]]; then
    sudo pacman -S --noconfirm tmux jq unzip curl
elif [[ "$OS" == *"Ubuntu"* ]] || [[ "$OS" == *"Debian"* ]]; then
    sudo apt update && sudo apt install -y tmux jq unzip curl
else
    echo "⚠️  Unknown OS. Please install 'tmux', 'jq', 'unzip', and 'curl' manually."
fi

# 2. Download Bedrock Server
if [ ! -f "server/bedrock_server" ]; then
    echo "⬇️  Downloading Minecraft Bedrock Server..."
    mkdir -p server
    
    # Fake user agent to avoid 403
    DOWNLOAD_URL=$(curl -s -H "User-Agent: Mozilla/5.0" https://www.minecraft.net/en-us/download/server/bedrock | grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*')
    
    if [ -z "$DOWNLOAD_URL" ]; then
        echo "❌ Failed to find download link. Please download manually from minecraft.net."
    else
        curl -H "User-Agent: Mozilla/5.0" -L -o bedrock.zip "$DOWNLOAD_URL"
        unzip -o bedrock.zip -d server/
        rm bedrock.zip
        echo "✅ Server downloaded!"
    fi
else
    echo "✅ Server already exists."
fi

# 3. Make scripts executable
chmod +x scripts/*.sh

echo ""
echo "🎉 Setup Complete!"
echo "Run ./scripts/mc.sh to start your server."
