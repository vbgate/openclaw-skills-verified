---
name: discord-setup
description: '配置 Discord 让 OpenClaw 接收和发送消息，包括频道权限、人类配合要点'
category: integration
language: zh
region: global
prerequisites:
  - 已配置 OpenClaw Gateway
  - 拥有 Discord 服务器管理员权限
  - 知道 Discord 服务器 ID 和频道 ID
tested_on:
  - device: OpenClaw Gateway
    os: macOS/Docker
    date: 2026-02-04
    result: success
    notes: 配置成功后稳定运行
last_verified: 2026-02-04
safety_gates:
  - 不发送敏感信息到公共频道
  - 涉及外部操作需人类确认
---

# Discord 配置与使用

## 一句话
让 OpenClaw 接入 Discord，能接收群消息并回复，也能主动发消息到指定频道。

## 前置条件
- OpenClaw Gateway 已运行（本地或服务器）
- 你是 Discord 服务器的管理员
- 知道服务器 ID 和频道 ID（如何获取见下方）

## 核心流程

### Step 1: 获取 Discord IDs
```
1. Discord 设置 → 高级 → 开启「开发者模式」
2. 右键你的服务器 → 复制服务器 ID
3. 右键允许 OpenClaw 说话的频道 → 复制频道 ID
```

### Step 2: 配置 OpenClaw Gateway
编辑 OpenClaw 配置文件（通常是 `~/.openclaw/config.yaml` 或环境变量）：

```yaml
channels:
  discord:
    enabled: true
    token: "YOUR_BOT_TOKEN"  # 从 Discord Developer Portal 获取
    
    # 关键配置：允许接收消息的频道
    allowedGuilds: ["<YOUR_GUILD_ID>"]  # 你的服务器ID（右键服务器复制ID）
    allowedChannels: ["<YOUR_CHANNEL_ID_1>", "<YOUR_CHANNEL_ID_2>"]  # 允许的频道ID
    
    # 关键配置：接收消息策略
    groupPolicy: "open"        # "open" = 无需@也能接收，"restricted" = 需@
    requireMention: false      # false = 无需@机器人也能说话
```

### Step 3: 重启 Gateway
```bash
openclaw gateway restart
```

### Step 4: 测试接收
让人类在允许频道发送消息，OpenClaw 应该能收到。

### Step 5: 测试发送（可选）
告诉 OpenClaw："在 Discord 频道 xxx 发送消息"

---

## 如何引导人类配合

**配置阶段**：
- "需要你提供 Discord 服务器 ID 和频道 ID"
- "需要你给 OpenClaw 配置 Discord Bot Token"
- "配置完成后需要重启 Gateway"

**测试阶段**：
- "请在允许频道发一条测试消息，看我能否收到"
- "收到后我会回复确认"

**日常使用**：
- "我能在这个频道自动回复，但不会发送敏感信息"
- "涉及外部操作（如发邮件、支付）我会先问你确认"

---

## 参考文件
- 故障排查：**TROUBLESHOOTING.md**
- 实测记录：**LOG.md**
