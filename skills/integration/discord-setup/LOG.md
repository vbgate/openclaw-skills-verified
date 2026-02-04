# 实测记录

## 测试环境
- **日期**: 2026-02-01 至 2026-02-02
- **测试者**: @<USERNAME>（已脱敏）
- **系统**: macOS + OpenClaw Gateway
- **目标**: 配置 Discord 让 OpenClaw 接收和发送消息

---

## 测试结果概览
- **结果**: ✅ 配置成功，运行稳定
- **现象**: 成功连接 Discord，可正常收发消息
- **问题**: 配置过程中踩了一些配置坑，但日志验证正常运行

---

## 关键日志证据

### 1. Discord 服务启动
```
[discord] [default] starting provider
```
证据：gateway.log @ 2026-02-01T20:02:55.075Z、2026-02-01T20:06:30.522Z 等

### 2. Discord 登录成功
```
[discord] logged in to discord as <BOT_ID>
```
证据：gateway.log @ 2026-02-01T20:09:15.352Z、2026-02-01T20:28:07.054Z 等

### 3. Intent 限制提示
```
[discord] [default] Discord Message Content Intent is limited; bots under 100 servers can use it without verification.
```
证据：gateway.log @ 2026-02-01T20:11:59.403Z、2026-02-01T20:28:05.705Z、2026-02-01T20:35:14.600Z 等

说明：此提示为正常信息，不影响少于 100 服务器的 Bot 使用。

---

## 连接/断开/重连过程实录

### 正常重连过程
当网络波动或 Discord 服务端断开时，系统会自动重连：

```
# 收到断开信号
[discord] gateway: WebSocket connection closed with code 1005
证据：gateway.log @ 2026-02-01T23:13:20.697Z

# 尝试恢复连接
[discord] gateway: Attempting resume with backoff: 1000ms
证据：gateway.log @ 2026-02-01T23:13:19.476Z

# 异常断开后的重连
[discord] gateway: WebSocket connection closed with code 1006
[discord] gateway: Attempting resume with backoff: 2000ms after code 1006
证据：gateway.log @ 2026-02-01T23:17:54.070Z
```

### 连接停滞处理
当 Discord 网关未在 30 秒内响应时，系统会强制重连：

```
[discord] connection stalled: no HELLO received within 30000ms, forcing reconnect
[discord] gateway: WebSocket connection closed with code 1006
[discord] gateway: Attempting resume with backoff: 2000ms after code 1006
```
证据：gateway.log @ 2026-02-01T23:18:33.040Z、2026-02-01T23:19:32.293Z、2026-02-01T23:21:17.033Z 等

### Gateway 重启导致的重连
配置变更后 Gateway 自动重启：

```
[gateway] signal SIGUSR1 received
[gateway] received SIGUSR1; restarting
...
[discord] [default] starting provider (@<USERNAME>)
[discord] logged in to discord as <BOT_ID>
```
证据：gateway.log @ 2026-02-01T17:19:44.017Z - 2026-02-01T20:09:15.352Z 等多次

---

## 配置踩坑记录

### 坑 1: groupPolicy 设置错误
- **现象**: 配置了 token，但收不到消息
- **原因**: groupPolicy 是 restricted，只接收 @机器人的消息
- **解决**: 改为 `groupPolicy: "open"`

### 坑 2: requireMention 设置错误
- **现象**: 改了 groupPolicy，但还是收不到
- **原因**: requireMention 是 true，必须 @机器人才能触发
- **解决**: 改为 `requireMention: false`

### 坑 3: allowedGuilds 为空数组
- **现象**: 都改了，还是收不到
- **原因**: allowedGuilds 是空数组，没有允许任何服务器
- **解决**: 填入真实的服务器 ID

### 坑 4: 配置改后不重启
- **现象**: 填了 ID，但还是不生效
- **原因**: 没有重启 Gateway
- **解决**: 执行 `openclaw gateway restart`

---

## 关键配置示例

成功运行的配置：

```yaml
channels:
  discord:
    enabled: true
    token: "<YOUR_BOT_TOKEN>"
    
    # 允许接收消息的频道
    allowedGuilds: ["<GUILD_ID>"]
    allowedChannels: ["<CHANNEL_ID_1>", "<CHANNEL_ID_2>"]
    
    # 接收消息策略
    groupPolicy: "open"
    requireMention: false
```

---

## 日志观察建议

实时监控 Discord 连接状态：

```bash
# 查看 Discord 相关日志
tail -f ~/.openclaw/logs/gateway.log | grep discord

# 查看 WebSocket 连接状态
tail -f ~/.openclaw/logs/gateway.log | grep -E "(WebSocket|connection|resume)"

# 查看 Gateway 重启信号
tail -f ~/.openclaw/logs/gateway.log | grep "SIGUSR1"
```

---

## 结论

1. **配置成功**: Discord 集成在正确配置后可稳定运行
2. **自动恢复**: WebSocket 断连后系统会自动重连，无需人工干预
3. **配置关键**: groupPolicy="open" + requireMention=false + 正确的 ID + 重启 Gateway
4. **正常日志**: 出现 Intent 限制提示和偶尔的 WebSocket 断连是正常现象

---

*本文档基于 OpenClaw 原生日据编写，所有时间戳均来自实际日志文件。*
