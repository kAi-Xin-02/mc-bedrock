#!/bin/bash
cd ~/mc-java

bash ~/mc-bedrock/scripts/autosave.sh &
AUTOSAVE_PID=$!

java -Xms4G -Xmx4G -jar server.jar nogui

kill $AUTOSAVE_PID 2>/dev/null
