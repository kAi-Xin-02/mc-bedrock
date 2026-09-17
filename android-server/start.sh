#!/data/data/com.termux/files/usr/bin/bash

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

MC_DIR="$HOME/mc-server"
AUTOSAVE_DIR="$MC_DIR/autosaves"
AUTOSAVE_INTERVAL=360
MAX_BACKUPS=10

if [ ! -f "$MC_DIR/server.jar" ]; then
  echo -e "${RED}Server not set up yet! Run setup.sh first.${NC}"
  exit 1
fi

mkdir -p "$AUTOSAVE_DIR"
cd "$MC_DIR"

cleanup() {
  echo ""
  echo -e "${YELLOW}Stopping server...${NC}"
  echo "save-all" >&${SERVER_FD}
  sleep 3
  echo "stop" >&${SERVER_FD}
  wait $SERVER_PID 2>/dev/null
  kill $AUTOSAVE_PID 2>/dev/null
  echo -e "${GREEN}Server stopped + saved. Goodbye!${NC}"
  exit 0
}
trap cleanup SIGINT SIGTERM

PHONE_IP=$(ip route 2>/dev/null | grep src | awk '{print $NF}' | head -1)

echo -e "${CYAN}${BOLD}"
echo "  ╔═══════════════════════════════════════╗"
echo "  ║    kAi's Minecraft Server (Android)   ║"
echo "  ╠═══════════════════════════════════════╣"
printf "  ║  Local IP: %-30s║\n" "${PHONE_IP:-detecting...}:25565"
echo "  ║  Autosave: every 6 minutes            ║"
echo "  ╚═══════════════════════════════════════╝"
echo -e "${NC}"

autosave_loop() {
  while true; do
    sleep $AUTOSAVE_INTERVAL
    if ! kill -0 $SERVER_PID 2>/dev/null; then break; fi
    DATE=$(date +"%Y-%m-%d_%H-%M-%S")
    SAVE_PATH="$AUTOSAVE_DIR/$DATE"
    mkdir -p "$SAVE_PATH"
    echo "save-off" >&${SERVER_FD}
    sleep 2
    echo "save-all flush" >&${SERVER_FD}
    sleep 5
    cp -r "$MC_DIR/world" "$SAVE_PATH/" 2>/dev/null
    echo "save-on" >&${SERVER_FD}
    echo -e "${GREEN}[Autosave] Saved at $DATE${NC}"
    cd "$AUTOSAVE_DIR"
    ls -dt */ 2>/dev/null | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm -rf
    cd "$MC_DIR"
  done
}

mkfifo /tmp/mc_input 2>/dev/null || true
exec {SERVER_FD}>/tmp/mc_input

java -Xms1G -Xmx2G \
  -XX:+UseG1GC \
  -XX:+ParallelRefProcEnabled \
  -XX:MaxGCPauseMillis=200 \
  -XX:+UnlockExperimentalVMOptions \
  -XX:+DisableExplicitGC \
  -XX:G1NewSizePercent=30 \
  -XX:G1MaxNewSizePercent=40 \
  -XX:G1HeapRegionSize=8M \
  -XX:G1ReservePercent=20 \
  -XX:SurvivorRatio=32 \
  -XX:MaxTenuringThreshold=1 \
  -jar server.jar nogui < /tmp/mc_input &

SERVER_PID=$!

sleep 8
autosave_loop &
AUTOSAVE_PID=$!

echo -e "${GREEN}Server started! (PID: $SERVER_PID)${NC}"
echo -e "${CYAN}Local:  ${BOLD}${PHONE_IP}:25565${NC}"
echo ""
echo -e "For remote friends, open a NEW Termux session (swipe from left → New Session) and run:"
echo -e "${YELLOW}  ssh -o StrictHostKeyChecking=no -p 443 -R0:localhost:25565 tcp@a.pinggy.io${NC}"
echo ""
echo -e "Press ${BOLD}Ctrl+C${NC} to stop the server safely."

wait $SERVER_PID
kill $AUTOSAVE_PID 2>/dev/null
echo -e "${YELLOW}Server process ended.${NC}"
