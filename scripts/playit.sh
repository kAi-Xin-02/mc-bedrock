#!/bin/bash

PLAYIT_DIR=~/mc-bedrock/playit

clear
echo "╔═══════════════════════════════════════╗"
echo "║   🌐 PLAYIT.GG SETUP 🌐               ║"
echo "╠═══════════════════════════════════════╣"
echo "║  Playit.gg lets friends join your     ║"
echo "║  server WITHOUT port forwarding!      ║"
echo "╠═══════════════════════════════════════╣"
echo "║  [1] 📥 Install Playit.gg             ║"
echo "║  [2] 🚀 Start Playit Tunnel           ║"
echo "║  [3] 🔗 Show Connection Info          ║"
echo "║  [4] ❓ Setup Help                    ║"
echo "║  [5] 🔙 Back                          ║"
echo "╚═══════════════════════════════════════╝"
echo ""

read -p "Choose [1-5]: " choice

case $choice in
    1)
        echo "📥 Installing Playit.gg..."
        mkdir -p "$PLAYIT_DIR"
        cd "$PLAYIT_DIR"
        curl -L -o playit https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64
        chmod +x playit
        echo ""
        echo "✅ Playit.gg installed!"
        echo ""
        echo "📝 NEXT STEPS:"
        echo "1. Run option [2] to start playit"
        echo "2. It will show a CLAIM URL - open it in browser"
        echo "3. Create account and claim your agent"
        echo "4. Create a TUNNEL for Minecraft Bedrock (UDP port 19132)"
        echo "5. Share your playit.gg address with friends!"
        ;;
    2)
        if [ -f "$PLAYIT_DIR/playit" ]; then
            echo "🚀 Starting Playit.gg tunnel..."
            echo "⚠️ KEEP THIS WINDOW OPEN while friends are playing!"
            echo ""
            echo "If this is first run, look for CLAIM URL and open in browser."
            echo "Press Ctrl+C to stop."
            echo ""
            "$PLAYIT_DIR/playit"
        else
            echo "❌ Playit not installed! Run option [1] first."
        fi
        ;;
    3)
        echo ""
        echo "🔗 CONNECTION INFO"
        echo "=================="
        echo ""
        echo "After setting up playit.gg:"
        echo "1. Log into https://playit.gg/account/tunnels"
        echo "2. Your address looks like: xxxxxx.at.playit.gg"
        echo "3. Tell friends to ADD SERVER in Minecraft with that address"
        echo ""
        echo "Your server must be RUNNING for friends to connect!"
        ;;
    4)
        echo ""
        echo "❓ PLAYIT.GG HELP"
        echo "================"
        echo ""
        echo "What is Playit.gg?"
        echo "- Free tunnel service"
        echo "- No port forwarding needed"
        echo "- Works behind ANY router/firewall"
        echo ""
        echo "How it works:"
        echo "1. You run playit agent on your PC"
        echo "2. It creates a tunnel to playit.gg cloud"
        echo "3. Friends connect via playit.gg address"
        echo "4. Traffic is routed to your PC"
        echo ""
        echo "Your server must be running FIRST!"
        echo "Then run playit tunnel."
        echo "Friends use your playit.gg address to connect."
        ;;
    5)
        exec ~/mc-bedrock/scripts/mc.sh
        ;;
    *)
        echo "❌ Invalid option"
        ;;
esac

echo ""
read -p "Press Enter to return..."
exec $0
