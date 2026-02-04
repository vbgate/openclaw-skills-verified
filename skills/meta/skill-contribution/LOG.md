# 实测记录（如何写 LOG.md）

> 本文件是示范：如何基于 OpenClaw 原生日志撰写 LOG.md 条目。
> 每一条记录都必须能从日志追溯到具体证据。

---

## 示范条目 1：Discord WebSocket 断连行为

**日期**: 2026-02-01
**测试者**: @javazys
**环境**: macOS, OpenClaw Gateway

### 测试场景
观察 Discord 通道在长时间运行时的连接稳定性。

### 日志证据
```
证据 1：~/.openclaw/logs/gateway.log @ 2026-02-01T23:13:20.697Z
原文：[discord] gateway: WebSocket connection closed with code 1005

证据 2：~/.openclaw/logs/gateway.log @ 2026-02-01T23:13:20.697Z
原文：[discord] gateway: Attempting resume with backoff: 1000ms

证据 3：~/.openclaw/logs/gateway.log @ 2026-02-01T23:18:36.990Z
原文：[discord] connection stalled: no HELLO received within 30000ms, forcing reconnect
```

### 结论
- Discord WebSocket 会在运行期间正常关闭（code 1005）和异常断开（code 1006）
- OpenClaw 会自动退避重连（backoff 策略）
- "no HELLO received" 时会在 30 秒后强制重连
- 这些断连通常**无需人工干预**，系统会自动恢复

### 新增价值
- 消除"WebSocket 断开 = 故障"的误解
- 提供重连时间预期（30秒超时 + 退避间隔）

---

## 示范条目 2：模型切换与 Gateway 重启

**日期**: 2026-02-01
**测试者**: @javazys
**环境**: macOS, OpenClaw Gateway

### 测试场景
验证切换主模型时 Gateway 的行为。

### 日志证据
```
证据 1：~/.openclaw/logs/gateway.log @ 2026-02-01T17:34:31.096Z
原文：[gateway] signal SIGUSR1 received
       [gateway] received SIGUSR1; restarting
       [ws] webchat disconnected code=1012 reason=service restart

证据 2：~/.openclaw/logs/gateway.log @ 2026-02-01T17:34:31.125Z
原文：[gateway] agent model: zhipu/glm-4.7
```

### 结论
- 配置变更会触发 `SIGUSR1` 信号
- Gateway 会优雅重启（发送 disconnect 1012）
- 重启后会加载新配置的模型
- Webchat 会自动重连

### 新增价值
- 明确"配置修改 → 自动重启"的机制
- 解释 disconnect code 1012 的含义（service restart）

---

## 示范条目 3：ADB 设备连接失败

**日期**: 2026-02-01
**测试者**: @javazys
**环境**: macOS, 华为 Mate20

### 测试场景
测试 AutoGLM 在无设备连接时的错误表现。

### 日志证据
```
证据：~/.openclaw/logs/gateway.err.log @ 2026-02-01T17:56:29.764Z
原文：[tools] exec failed: 🔍 Checking system requirements...
       Error: No devices connected.
       Command exited with code 128
```

### 结论
- ADB 无设备时，AutoGLM 系统检查会失败
- 错误码 128 表示"无设备"
- 必须在执行前确认 `adb devices` 有输出

### 新增价值
- 提供明确的错误码说明
- 建立"先检查设备再执行"的规范

---

## 如何写一条合格的 LOG.md 条目

**必须包含**：
1. **日期/测试者/环境**：何时、谁、在什么环境测的
2. **测试场景**：测的是什么功能
3. **日志证据**：具体的日志原文（脱敏后），含文件名+时间戳
4. **结论**：从日志推导出的确定性结论
5. **新增价值**：这条记录能帮同事省什么时间/避免什么坑

**禁止**：
- ❌ 没有日志证据的"我觉得"
- ❌ 无法追溯的"成功率约80%"
- ❌ 含敏感信息的原始日志

**格式模板**：
```markdown
## [功能/场景名]

**日期**: YYYY-MM-DD
**测试者**: @标识
**环境**: [OS/设备/版本]

### 测试场景
[描述测试了什么]

### 日志证据
```
证据：[文件名] @ [ISO时间戳]
原文：[脱敏后的日志原文]
```

### 结论
- [基于日志的确定性结论 1]
- [基于日志的确定性结论 2]

### 新增价值
- [这条记录的价值]
```
