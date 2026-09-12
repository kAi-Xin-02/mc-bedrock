#!/bin/bash

SESSION="mc"
SCRIPTS_DIR=~/mc-bedrock/scripts

clear
echo "╔═══════════════════════════════════════╗"
echo "║   🎮  kAi - Java + Bedrock Server  🎮 ║"
echo "╠═══════════════════════════════════════╣"
echo "║  [1] 🚀 Start Server                  ║"
echo "║  [2] 🖥️  Open Console                  ║"
echo "║  [3] 🛑 Stop Server                   ║"
echo "║  [4] 💾 Backup Now                    ║"
echo "║  [5] 📊 Server Status                 ║"
echo "║  [6] 👑 Admin & Permissions           ║"
echo "║  [7] 🌐 Playit.gg (Friends Join)      ║"
echo "║  [8] ❌ Exit                          ║"
echo "╚═══════════════════════════════════════╝"
echo ""

if tmux has-session -t $SESSION 2>/dev/null; then
    echo "Status: 🟢 SERVER RUNNING"
else
    echo "Status: 🔴 SERVER STOPPED"
fi
echo ""

read -p "Choose [1-8]: " choice

case $choice in
    1)
        if tmux has-session -t $SESSION 2>/dev/null; then
            echo "⚠️ Server already running! Use [2] to open console."
        else
            echo "🚀 Starting kAi server..."
            tmux new-session -d -s $SESSION "systemd-inhibit --what=idle:sleep:handle-lid-switch --who=MinecraftServer --why='Preventing sleep for server' $SCRIPTS_DIR/start.sh"
            sleep 2
            echo "✅ Server started!"
            echo "ℹ️  Java players: port 25565 | Bedrock players: port 19132"
        fi
        ;;
    2)
        if tmux has-session -t $SESSION 2>/dev/null; then
            echo "Opening console... (Press Ctrl+B then D to detach)"
            sleep 1
            tmux attach -t $SESSION
        else
            echo "❌ Server not running! Start it first with [1]."
        fi
        ;;
    3)
        if tmux has-session -t $SESSION 2>/dev/null; then
            echo "🛑 Stopping server safely..."
            tmux send-keys -t $SESSION "stop" Enter
            sleep 5
            echo "✅ Server stopped!"
        else
            echo "❌ Server is not running."
        fi
        ;;
    4)
        echo "💾 Creating backup..."
        $SCRIPTS_DIR/backup.sh
        ;;
    5)
        echo ""
        echo "📊 Server Info:"
        if tmux has-session -t $SESSION 2>/dev/null; then
            echo "   Status: 🟢 RUNNING"
        else
            echo "   Status: 🔴 STOPPED"
        fi
        echo "   Engine:  PaperMC 26.2 (Java + Geyser Crossplay)"
        echo "   World:   ~/mc-java/world/"
        echo "   Backups: ~/mc-java/autosaves/"
        if [ -d ~/mc-java/autosaves ]; then
            echo "   Backup count: $(ls ~/mc-java/autosaves 2>/dev/null | wc -l)"
        fi
        echo "   Java port:   25565"
        echo "   Bedrock port: 19132"
        ;;
    6)
        exec $SCRIPTS_DIR/admin.sh
        ;;
    7)
        exec $SCRIPTS_DIR/playit.sh
        ;;
    8)
        echo "👋 Bye!"
        exit 0
        ;;
    *)
        echo "❌ Invalid option"
        ;;
esac

echo ""
read -p "Press Enter to return to menu..."
exec $0
