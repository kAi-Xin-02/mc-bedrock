# Minecraft Bedrock Server

One-click server management for Minecraft Bedrock Edition on Linux.

## Features

- Start/stop server with menu
- Auto-backup worlds (keeps last 10)
- Admin & whitelist management
- Playit.gg integration (friends join without port forwarding)
- Runs in background via tmux

## Quick Start

1. Clone this repo:
```bash
git clone https://github.com/kAi-Xin-02/mc-bedrock.git
cd mc-bedrock
```

2. Run setup (installs deps & server):
```bash
./scripts/setup.sh
```

3. Start playing:
```bash
./scripts/mc.sh
```

## Manual Requirements

If you don't use the setup script:
- Install `tmux` and `jq`
- Download Bedrock server from [minecraft.net](https://www.minecraft.net/en-us/download/server/bedrock) and extract to `server/` folder.


## Usage

```bash
./scripts/mc.sh
```

| Option | Action |
|--------|--------|
| 1 | Start server |
| 2 | Open console |
| 3 | Stop server |
| 4 | Backup now |
| 5 | Status |
| 6 | Admin menu |
| 7 | Playit.gg |

## Folder Structure

```
mc-bedrock/
├── server/          # Bedrock server files
│   └── worlds/      # World data (safe!)
├── backups/         # Auto-backups
└── scripts/         # Control scripts
```

## Friends Joining

Use Playit.gg (option 7) - no port forwarding needed. Friends connect via your `xxxxx.at.playit.gg` address.

## License

MIT
