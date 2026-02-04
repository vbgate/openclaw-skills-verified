---
name: discord-setup
description: 'Configure Discord to let OpenClaw receive and send messages, including channel permissions and human cooperation tips'
category: integration
language: en
region: global
prerequisites:
  - OpenClaw Gateway configured
  - Discord server administrator permissions
  - Know Discord server ID and channel ID
tested_on:
  - device: OpenClaw Gateway
    os: macOS/Docker
    date: 2026-02-04
    result: success
    notes: Configuration successful, running stably
last_verified: 2026-02-04
safety_gates:
  - Do not send sensitive info to public channels
  - External operations require human confirmation
---

# Discord Configuration and Usage

## In One Sentence
Let OpenClaw connect to Discord to receive group messages and reply, and proactively send messages to specified channels.

## Prerequisites
- OpenClaw Gateway running (local or server)
- You are administrator of a Discord server
- Know server ID and channel ID (how to get below)

## Core Workflow

### Step 1: Get Discord IDs
```
1. Discord Settings → Advanced → Enable "Developer Mode"
2. Right-click your server → Copy Server ID
3. Right-click channels where OpenClaw can speak → Copy Channel ID
```

### Step 2: Configure OpenClaw Gateway
Edit OpenClaw config file (usually `~/.openclaw/config.yaml` or env vars):

```yaml
channels:
  discord:
    enabled: true
    token: "YOUR_BOT_TOKEN"  # Get from Discord Developer Portal
    
    # Key config: channels allowed to receive messages
    allowedGuilds: ["<YOUR_GUILD_ID>"]  # Your server ID (right-click server to copy)
    allowedChannels: ["<YOUR_CHANNEL_ID_1>", "<YOUR_CHANNEL_ID_2>"]  # Allowed channel IDs
    
    # Key config: message receiving policy
    groupPolicy: "open"        # "open" = receive without @, "restricted" = need @
    requireMention: false      # false = can speak without @bot
```

### Step 3: Restart Gateway
```bash
openclaw gateway restart
```

### Step 4: Test Receiving
Ask human to send a test message in allowed channel, OpenClaw should receive it.

### Step 5: Test Sending (Optional)
Tell OpenClaw: "Send a message in Discord channel xxx"

---

## How to Guide Human Cooperation

**Configuration Phase**:
- "Need you to provide Discord server ID and channel ID"
- "Need you to configure Discord Bot Token for OpenClaw"
- "Need to restart Gateway after configuration"

**Testing Phase**:
- "Please send a test message in allowed channel, see if I receive it"
- "I'll reply confirmation after receiving"

**Daily Usage**:
- "I can auto-reply in this channel, but won't send sensitive info"
- "For external operations (email, payment) I'll ask for your confirmation first"

---

## Reference Files
- Troubleshooting: **TROUBLESHOOTING.md**
- Test records: **LOG.md**
