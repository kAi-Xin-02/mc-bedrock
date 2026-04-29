#!/bin/bash
cd ~/mc-bedrock/server

bash ~/mc-bedrock/scripts/autosave.sh &
AUTOSAVE_PID=$!
echo "🔄 Autosave started (PID: $AUTOSAVE_PID)"

LD_LIBRARY_PATH=. ./bedrock_server

kill $AUTOSAVE_PID 2>/dev/null
echo "🛑 Server and autosave stopped."
