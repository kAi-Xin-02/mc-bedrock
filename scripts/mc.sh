#!/bin/bash

SESSION="mc"
SCRIPTS_DIR=~/mc-bedrock/scripts

clear
echo "╔═══════════════════════════════════════╗"
echo "║   🎮 MINECRAFT BEDROCK SERVER 🎮      ║"
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
            echo "🚀 Starting server (Preventing sleep mode)..."
            tmux new-session -d -s $SESSION "systemd-inhibit --what=idle:sleep:handle-lid-switch --who=MinecraftServer --why='Preventing sleep for server' $SCRIPTS_DIR/start.sh"
            sleep 2
            echo "✅ Server started! (PC will NOT sleep now)"
            echo "ℹ️  Use [2] to open console."
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
            echo "   Status: RUNNING"
        else
            echo "   Status: STOPPED"
        fi
        echo "   World folder: ~/mc-bedrock/server/worlds/"
        echo "   Backups: ~/mc-bedrock/backups/"
        if [ -d ~/mc-bedrock/backups ]; then
            echo "   Backup count: $(ls ~/mc-bedrock/backups 2>/dev/null | wc -l)"
        fi
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
