#!/data/data/com.termux/files/usr/bin/bash

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${CYAN}"
echo "  ╔═══════════════════════════════════════╗"
echo "  ║    kAi's Minecraft Server  (Android)  ║"
echo "  ║           One-Click Setup             ║"
echo "  ╚═══════════════════════════════════════╝"
echo -e "${NC}"

MC_DIR="$HOME/mc-server"
mkdir -p "$MC_DIR/plugins"
cd "$MC_DIR"

echo -e "${YELLOW}[1/5] Installing Java & tools...${NC}"
pkg update -y -q 2>/dev/null
pkg install -y openjdk-21 wget unzip -q 2>/dev/null
echo -e "${GREEN}  Java installed!${NC}"

echo -e "${YELLOW}[2/5] Downloading PaperMC 26.2...${NC}"
wget -q --show-progress \
  "https://fill.papermc.io/v3/projects/paper/versions/26.2/builds/83/downloads/paper-26.2-83.jar" \
  -O server.jar
echo -e "${GREEN}  PaperMC downloaded!${NC}"

echo -e "${YELLOW}[3/5] Downloading plugins...${NC}"
cd "$MC_DIR/plugins"
wget -q --show-progress "https://cdn.modrinth.com/data/xquVwxlu/versions/iL4FlGFK/AxVaults-2.15.3.jar" -O AxVaults-2.15.3.jar
wget -q --show-progress "https://cdn.modrinth.com/data/PFb7ZqK6/versions/ejPk2ZiR/squaremap-paper-mc26.2-1.3.15.jar" -O squaremap.jar
echo -e "${GREEN}  Plugins downloaded!${NC}"
cd "$MC_DIR"

echo -e "${YELLOW}[4/5] Checking for world file...${NC}"
if [ -f "$HOME/storage/shared/Download/mc-android-world.zip" ]; then
  echo -e "  Found mc-android-world.zip in Downloads! Extracting..."
  unzip -q "$HOME/storage/shared/Download/mc-android-world.zip" -d "$MC_DIR/"
  echo -e "${GREEN}  World loaded from zip!${NC}"
elif [ -f "$HOME/mc-android-world.zip" ]; then
  echo -e "  Found mc-android-world.zip in home! Extracting..."
  unzip -q "$HOME/mc-android-world.zip" -d "$MC_DIR/"
  echo -e "${GREEN}  World loaded!${NC}"
else
  echo -e "${YELLOW}  No world.zip found - a fresh world will be generated.${NC}"
  echo -e "  Put mc-android-world.zip in your Downloads folder and run setup again to load the real world."
fi

echo -e "${YELLOW}[5/5] Writing config files...${NC}"

echo "eula=true" > eula.txt

cat > server.properties << 'PROPS'
online-mode=false
max-players=10
gamemode=survival
difficulty=normal
simulation-distance=4
view-distance=6
spawn-protection=0
spawn-animals=true
spawn-monsters=true
motd=kAi Android Server
level-name=world
PROPS

cat > ops.json << 'OPS'
[
  {"uuid":"ec3529a1-80ee-32c4-903c-357c4bcf1ceb","name":"kAi_Xinar","level":4,"bypassesPlayerLimit":false},
  {"uuid":"973ff9bf-33c1-31d3-bfba-fa48fe5165e7","name":"Lovence","level":4,"bypassesPlayerLimit":false},
  {"uuid":"70d2c01f-df41-351c-8955-ca1a9288106c","name":"MoulikPandya","level":4,"bypassesPlayerLimit":false}
]
OPS

chmod +x "$MC_DIR/start.sh" 2>/dev/null || true

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Setup complete!  Run:                   ║${NC}"
echo -e "${GREEN}║                                          ║${NC}"
echo -e "${GREEN}║     bash ~/mc-server/start.sh            ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
PHONE_IP=$(ip route 2>/dev/null | grep src | awk '{print $NF}' | head -1)
echo -e "${CYAN}Friends on same WiFi: ${PHONE_IP:-YOUR_PHONE_IP}:25565${NC}"
