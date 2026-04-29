#!/bin/bash

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
fi

echo "🚀 Minecraft Bedrock One-Click Installer"
echo "======================================"

echo "📦 Installing requirements (tmux, jq, unzip, curl)..."
if [[ "$ID" == "arch" ]] || [[ "$ID_LIKE" == *"arch"* ]]; then
    sudo pacman -S --noconfirm tmux jq unzip curl
elif [[ "$ID" == "ubuntu" ]] || [[ "$ID" == "debian" ]] || [[ "$ID_LIKE" == *"ubuntu"* ]] || [[ "$ID_LIKE" == *"debian"* ]]; then
    sudo apt update && sudo apt install -y tmux jq unzip curl
else
    echo "⚠️  Could not detect package manager. Please manually install: tmux, jq, unzip, curl"
fi

if [ ! -f "server/bedrock_server" ]; then
    echo "⬇️  Downloading Minecraft Bedrock Server..."
    mkdir -p server

    DOWNLOAD_URL=$(curl -s -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64)" https://www.minecraft.net/en-us/download/server/bedrock | grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*')

    if [ -z "$DOWNLOAD_URL" ]; then
        echo "❌ Automated download failed (Minecraft.net often blocks bots)."
        echo "👉 Please download the server manually:"
        echo "   1. Go to: https://www.minecraft.net/en-us/download/server/bedrock"
        echo "   2. Download the Ubuntu/Linux version"
        echo "   3. Unzip it into the 'server' folder inside this directory"
    else
        echo "🔗 Found version: $DOWNLOAD_URL"
        curl -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64)" -L -o bedrock.zip "$DOWNLOAD_URL"
        if [ $? -eq 0 ]; then
            unzip -o bedrock.zip -d server/
            rm bedrock.zip
            echo "✅ Server downloaded and extracted!"
        else
            echo "❌ Download failed. Please try downloading manually."
        fi
    fi
else
    echo "✅ Server already exists."
fi

chmod +x scripts/*.sh

echo ""
echo "🎉 Setup Complete!"
echo "Run ./scripts/mc.sh to start your server."
