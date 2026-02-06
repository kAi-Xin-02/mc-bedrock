#!/bin/bash

PERMS_FILE=~/mc-bedrock/server/permissions.json
WHITELIST_FILE=~/mc-bedrock/server/allowlist.json
CONFIG_FILE=~/mc-bedrock/server/server.properties

clear
echo "╔═══════════════════════════════════════╗"
echo "║   👑 ADMIN & PERMISSIONS MANAGER 👑   ║"
echo "╠═══════════════════════════════════════╣"
echo "║  [1] 👑 Add OP (Admin)                ║"
echo "║  [2] ➖ Remove OP                     ║"
echo "║  [3] ✅ Add to Whitelist              ║"
echo "║  [4] ❌ Remove from Whitelist         ║"
echo "║  [5] 🚫 Enable Whitelist Mode         ║"
echo "║  [6] 🔓 Disable Whitelist Mode        ║"
echo "║  [7] 📋 View All Permissions          ║"
echo "║  [8] 🔙 Back to Main Menu             ║"
echo "╚═══════════════════════════════════════╝"
echo ""

read -p "Choose [1-8]: " choice

case $choice in
    1)
        read -p "Enter player XUID (from server console when they join): " xuid
        read -p "Enter player name: " name
        if [ -f "$PERMS_FILE" ]; then
            tmp=$(mktemp)
            jq --arg xuid "$xuid" --arg name "$name" '. += [{"permission": "operator", "xuid": $xuid}]' "$PERMS_FILE" > "$tmp" && mv "$tmp" "$PERMS_FILE"
            echo "✅ Added $name as OP!"
        else
            echo '[{"permission": "operator", "xuid": "'$xuid'"}]' > "$PERMS_FILE"
            echo "✅ Created permissions.json and added $name as OP!"
        fi
        echo "⚠️ Restart server for changes to take effect."
        ;;
    2)
        read -p "Enter player XUID to remove: " xuid
        if [ -f "$PERMS_FILE" ]; then
            tmp=$(mktemp)
            jq --arg xuid "$xuid" 'del(.[] | select(.xuid == $xuid))' "$PERMS_FILE" > "$tmp" && mv "$tmp" "$PERMS_FILE"
            echo "✅ Removed OP!"
        else
            echo "❌ No permissions file found."
        fi
        ;;
    3)
        read -p "Enter player XUID: " xuid
        read -p "Enter player name: " name
        if [ -f "$WHITELIST_FILE" ]; then
            tmp=$(mktemp)
            jq --arg xuid "$xuid" --arg name "$name" '. += [{"ignoresPlayerLimit": false, "name": $name, "xuid": $xuid}]' "$WHITELIST_FILE" > "$tmp" && mv "$tmp" "$WHITELIST_FILE"
        else
            echo '[{"ignoresPlayerLimit": false, "name": "'$name'", "xuid": "'$xuid'"}]' > "$WHITELIST_FILE"
        fi
        echo "✅ Added $name to whitelist!"
        ;;
    4)
        read -p "Enter player name to remove: " name
        if [ -f "$WHITELIST_FILE" ]; then
            tmp=$(mktemp)
            jq --arg name "$name" 'del(.[] | select(.name == $name))' "$WHITELIST_FILE" > "$tmp" && mv "$tmp" "$WHITELIST_FILE"
            echo "✅ Removed $name from whitelist!"
        else
            echo "❌ No whitelist file found."
        fi
        ;;
    5)
        if [ -f "$CONFIG_FILE" ]; then
            sed -i 's/allow-list=false/allow-list=true/' "$CONFIG_FILE"
            echo "✅ Whitelist ENABLED! Only whitelisted players can join."
            echo "⚠️ Restart server for changes to take effect."
        else
            echo "❌ server.properties not found. Run server once first."
        fi
        ;;
    6)
        if [ -f "$CONFIG_FILE" ]; then
            sed -i 's/allow-list=true/allow-list=false/' "$CONFIG_FILE"
            echo "✅ Whitelist DISABLED! Anyone can join."
            echo "⚠️ Restart server for changes to take effect."
        else
            echo "❌ server.properties not found."
        fi
        ;;
    7)
        echo ""
        echo "=== OPs (Admins) ==="
        if [ -f "$PERMS_FILE" ]; then
            cat "$PERMS_FILE" | jq -r '.[] | select(.permission == "operator") | .xuid'
        else
            echo "None"
        fi
        echo ""
        echo "=== Whitelist ==="
        if [ -f "$WHITELIST_FILE" ]; then
            cat "$WHITELIST_FILE" | jq -r '.[].name'
        else
            echo "None"
        fi
        echo ""
        echo "=== Whitelist Status ==="
        if [ -f "$CONFIG_FILE" ]; then
            grep "allow-list=" "$CONFIG_FILE"
        fi
        ;;
    8)
        exec ~/mc-bedrock/scripts/mc.sh
        ;;
    *)
        echo "❌ Invalid option"
        ;;
esac

echo ""
read -p "Press Enter to return..."
exec $0
