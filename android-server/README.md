# 📱 kAi Minecraft Server — Android (Termux) Guide

## Requirements
- Android phone with **3GB+ free RAM** and **2GB+ storage**
- **Termux** app from F-Droid (NOT the Play Store version)
- The **mc-android-world.zip** file (kAi sends this to you)

---

## Step 1 — Install Termux
1. Go to **[f-droid.org](https://f-droid.org)** → Download & install F-Droid
2. In F-Droid, search **Termux** → Install it
3. Open Termux once to initialize

## Step 2 — Allow Storage Access
In Termux, run:
```bash
termux-setup-storage
```
Tap **Allow** when asked.

## Step 3 — Copy the World File
Put **mc-android-world.zip** (from kAi) into your phone's **Downloads** folder.

## Step 4 — Run Setup (ONE TIME ONLY)
```bash
curl -sL https://raw.githubusercontent.com/kAi-Xin-02/mc-bedrock/main/android-server/setup.sh | bash
```
Wait ~5 minutes. It downloads everything automatically.

## Step 5 — Start the Server ▶️
```bash
bash ~/mc-server/start.sh
```

The screen shows your phone's local IP. Share it with friends on the same WiFi!

---

## For Remote Friends (Over Internet)
Open a **second Termux session** (swipe from left edge → New Session) and run:
```bash
ssh -o StrictHostKeyChecking=no -p 443 -R0:localhost:25565 tcp@a.pinggy.io
```
Copy the `tcp://xyz.run.pinggy-free.link:PORT` address and share it. Free tunnel lasts 60 minutes.

## Stop the Server
Press **Ctrl+C** in Termux → auto-saves before stopping!

---

## Features
- ✅ Autosave every **6 minutes** (10 rolling backups)
- ✅ Your real world with all builds loaded
- ✅ kAi, Lovence, MoulikPandya are all OP
- ✅ keep_inventory ON everywhere
- ✅ AxVaults `/pv` works
- ✅ Works on same WiFi or over internet via Pinggy
