# 故障速查

## 配置后收不到 Discord 消息
**现象**: Gateway 正常运行，但 OpenClaw 完全收不到 Discord 消息

**原因 1: groupPolicy 设置错误**
```yaml
# ❌ 错误
groupPolicy: "restricted"  # 只接收 @机器人的消息

# ✅ 正确
groupPolicy: "open"  # 接收所有消息
```

**原因 2: requireMention 设置错误**
```yaml
# ❌ 错误
requireMention: true  # 必须 @机器人才能触发

# ✅ 正确
requireMention: false  # 无需 @也能触发
```

**原因 3: allowedGuilds/allowedChannels 未配置或错误**
```yaml
# ❌ 错误：空数组或错误 ID
allowedGuilds: []
allowedChannels: []

# ✅ 正确：填入真实的服务器和频道 ID
allowedGuilds: ["<YOUR_GUILD_ID>"]
allowedChannels: ["<YOUR_CHANNEL_ID_1>"]
```

**排查步骤**:
1. 检查 `groupPolicy: "open"`
2. 检查 `requireMention: false`
3. 检查 allowedGuilds 包含服务器 ID
4. 检查 allowedChannels 包含频道 ID
5. 重启 Gateway
6. 在允许频道发测试消息

---

## 能收消息但不能发消息
**现象**: OpenClaw 收到消息，但发送失败

**原因**: Bot 缺少发送消息权限

**解法**:
1. Discord 服务器设置 → 角色 → 你的 Bot 角色
2. 确保有 "Send Messages" 权限
3. 频道权限设置中也要允许

---

## Gateway 启动报错 "Invalid token"
**现象**: Gateway 启动失败，提示 token 错误

**原因**: Bot Token 错误或过期

**解法**:
1. 去 Discord Developer Portal (https://discord.com/developers/applications)
2. 你的应用 → Bot → Reset Token
3. 复制新 Token 到配置文件
4. 重启 Gateway

---

## 人类不知道怎么获取 Discord ID
**解法**:
1. Discord 用户设置 → 高级 → 开启「开发者模式」
2. 右键服务器名称 → 复制 ID（服务器 ID）
3. 右键频道名称 → 复制 ID（频道 ID）

---

## 配置改了很多次还是不生效
**解法**: 每次改配置后**必须重启 Gateway**
```bash
openclaw gateway restart
```
只改配置不重启，新配置不会生效。

---

## Discord WebSocket 频繁断连（代码 1005/1006）

**现象**: 日志中出现频繁的 WebSocket 断连和重连

```
[discord] gateway: WebSocket connection closed with code 1005
[discord] gateway: Attempting resume with backoff: 1000ms
[discord] gateway: WebSocket connection closed with code 1006
[discord] gateway: Attempting resume with backoff: 2000ms after code 1006
```
证据：gateway.log @ 2026-02-01T23:13:19.476Z 及后续

**WebSocket 关闭代码含义**:
- **Code 1005**: 正常关闭（no status code），通常是网络波动或 Discord 服务器主动断开
- **Code 1006**: 异常断开（abnormal closure），通常是网络问题或连接超时
- **Code 1000**: 正常关闭，通常是有序断开

**解法**:
1. 检查网络连接稳定性
2. 检查是否有防火墙或代理干扰 WebSocket 连接
3. 通常系统会自动重连，无需人工干预
4. 如持续断开，尝试重启 Gateway:
   ```bash
   openclaw gateway restart
   ```

---

## Discord 连接停滞（no HELLO received）

**现象**: 日志中出现 "connection stalled: no HELLO received within 30000ms"

```
[discord] connection stalled: no HELLO received within 30000ms, forcing reconnect
[discord] gateway: WebSocket connection closed with code 1006
[discord] gateway: Attempting resume with backoff: 2000ms after code 1006
```
证据：gateway.log @ 2026-02-01T23:18:33.040Z、2026-02-01T23:19:32.293Z 等

**原因**: Discord 网关未在 30 秒内发送 HELLO 消息，连接被认为已停滞

**解法**:
1. 通常是网络延迟或 Discord 服务器响应慢导致
2. 系统会自动强制重连并尝试恢复会话
3. 如频繁出现，检查网络连接到 Discord 的延迟
4. 检查是否有 DNS 解析问题

---

## Discord Message Content Intent 警告

**现象**: 日志中出现 Intent 限制警告

```
[discord] [default] Discord Message Content Intent is limited; bots under 100 servers can use it without verification.
```
证据：gateway.log @ 2026-02-01T20:11:59.403Z、2026-02-01T20:28:05.705Z 等

**说明**: 
- 少于 100 个服务器的 Bot 可以无需验证使用 Message Content Intent
- 超过 100 个服务器需要向 Discord 申请验证

**解法**:
1. 对于小规模使用（<100 服务器），此警告可忽略
2. 如需大规模部署，前往 Discord Developer Portal 申请验证

---

## Gateway 重启导致 Discord 连接断开

**现象**: Gateway 收到 SIGUSR1 信号后重启，Discord 连接断开

```
[gateway] signal SIGUSR1 received
[gateway] received SIGUSR1; restarting
[discord] [default] starting provider (@<USERNAME>)
[discord] logged in to discord as <BOT_ID>
```
证据：gateway.log @ 2026-02-01T17:19:44.017Z、2026-02-01T20:28:04.257Z 等

**说明**: 
- 配置变更后 Gateway 会自动重启（通过 SIGUSR1 信号）
- 重启后 Discord 连接会自动重新建立
- 这是正常行为，不是故障

**预期日志流程**:
1. `signal SIGUSR1 received` - 收到重启信号
2. `received SIGUSR1; restarting` - 开始重启
3. `[discord] [default] starting provider` - Discord 服务启动
4. `[discord] logged in to discord as <BOT_ID>` - 登录成功

---

## Discord 网关关闭（code 4014）

**现象**: 日志中出现 WebSocket closed with code 4014

```
[discord] gateway: WebSocket connection closed with code 4014
```
证据：gateway.log @ 2026-02-01T20:09:17.306Z

**原因**: 
- Code 4014 表示 Discord 网关要求断开（通常是由于 intents 配置问题或 Discord 服务端问题）

**解法**:
1. 检查 Bot 的 Intents 设置是否正确
2. 前往 Discord Developer Portal → Bot → Privileged Gateway Intents
3. 确保需要的 Intents（如 MESSAGE_CONTENT）已启用
4. 重启 Gateway

---

## 排查步骤总结

当 Discord 功能异常时，按以下顺序排查：

1. **查看日志**: `tail -f ~/.openclaw/logs/gateway.log | grep discord`
2. **检查配置**: 确认 `groupPolicy`, `requireMention`, `allowedGuilds`, `allowedChannels` 设置正确
3. **检查重启**: 确认配置修改后已重启 Gateway
4. **检查网络**: 查看是否有 WebSocket 断连（code 1005/1006）或连接停滞
5. **检查登录**: 确认日志中有 `logged in to discord as <BOT_ID>`
6. **检查权限**: 确认 Bot 在 Discord 服务器中有正确的权限

---

*注：所有故障现象均基于实际日志证据记录。如有新增问题，请补充日志证据后更新本文档。*
