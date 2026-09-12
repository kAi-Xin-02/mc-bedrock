#!/bin/bash

WORLD_DIR=~/mc-java/world
BACKUP_DIR=~/mc-java/autosaves
MAX_BACKUPS=12
INTERVAL=300
TMUX_SESSION="mc"

while true; do
    sleep $INTERVAL

    if ! tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
        break
    fi

    DATE=$(date +"%Y-%m-%d_%H-%M-%S")
    SAVE_PATH="$BACKUP_DIR/$DATE"

    tmux send-keys -t "$TMUX_SESSION" "save-off" Enter
    sleep 2
    tmux send-keys -t "$TMUX_SESSION" "save-all flush" Enter
    sleep 5

    if [ -d "$WORLD_DIR" ]; then
        mkdir -p "$SAVE_PATH"
        cp -r "$WORLD_DIR" "$SAVE_PATH/"
        sync
    fi

    tmux send-keys -t "$TMUX_SESSION" "save-on" Enter

    cd "$BACKUP_DIR"
    ls -dt */ 2>/dev/null | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm -rf
done
