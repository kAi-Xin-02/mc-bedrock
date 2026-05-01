#!/bin/bash
cd ~/mc-bedrock/server

GOLDEN=~/mc-bedrock/server.properties.golden
if [ -f "$GOLDEN" ]; then
    cp "$GOLDEN" ~/mc-bedrock/server/server.properties
    sync
    echo "🔒 server.properties restored from golden copy"
fi

CORES=$(nproc)
echo "💻 Detected $CORES CPU threads. Optimizing server for local hardware..."
sed -i "s/max-threads=.*/max-threads=$CORES/" ~/mc-bedrock/server/server.properties

if [ -f "$GOLDEN" ]; then
    sed -i "s/max-threads=.*/max-threads=$CORES/" "$GOLDEN"
fi

bash ~/mc-bedrock/scripts/autosave.sh &
AUTOSAVE_PID=$!
echo "🔄 Autosave started (PID: $AUTOSAVE_PID)"

LD_LIBRARY_PATH=. ./bedrock_server

kill $AUTOSAVE_PID 2>/dev/null
echo "🛑 Server and autosave stopped."
