#!/bin/bash

SRC=~/mc-bedrock/server/worlds
DEST=~/mc-bedrock/backups
DATE=$(date +"%Y-%m-%d_%H-%M")

if [ -d "$SRC" ]; then
    mkdir -p "$DEST/$DATE"
    cp -r "$SRC"/* "$DEST/$DATE/"
    echo "✅ Backup done at $DATE"
    cd "$DEST"
    ls -t | tail -n +11 | xargs -r rm -rf
else
    echo "⚠️ No worlds folder found yet. Start the server first!"
fi
