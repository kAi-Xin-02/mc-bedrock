#!/bin/bash

WORLD_DIR=~/mc-bedrock/server/worlds
BACKUP_DIR=~/mc-bedrock/autosaves
MAX_BACKUPS=6
INTERVAL=600
TMUX_SESSION="mc"

echo "🔄 Autosave started - saving every 10 minutes"

while true; do
    sleep $INTERVAL

    if ! tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
        echo "⚠️ Server session not found. Autosave stopping."
        break
    fi

    DATE=$(date +"%Y-%m-%d_%H-%M-%S")
    SAVE_PATH="$BACKUP_DIR/$DATE"

    tmux send-keys -t "$TMUX_SESSION" "save hold" Enter
    sleep 5
    tmux send-keys -t "$TMUX_SESSION" "save query" Enter
    sleep 3

    if [ -d "$WORLD_DIR" ]; then
        mkdir -p "$SAVE_PATH"
        cp -r "$WORLD_DIR"/* "$SAVE_PATH/"
        echo "✅ Autosave: $DATE"
    else
        echo "⚠️ World directory not found!"
    fi

    tmux send-keys -t "$TMUX_SESSION" "save resume" Enter

    cd "$BACKUP_DIR"
    ls -dt */ 2>/dev/null | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm -rf
done
