# 故障速查（贡献 Skill 时）

## 如何定位日志证据？

### Step 1: 确定时间范围
先确定你要查证的问题发生在什么时候：
```bash
# 查看命令流水，找到对应操作的时间戳
tail -n 100 ~/.openclaw/logs/commands.log
```

### Step 2: 读取对应时段的错误日志
```bash
# 查看该时段的错误（通常信息密度最高）
grep "2026-02-04T18:2" ~/.openclaw/logs/gateway.err.log

# 或查看正常日志中的关键事件
grep "2026-02-04T18:2" ~/.openclaw/logs/gateway.log | grep -E "error|fail|disconnect|reconnect"
```

### Step 3: 找到对应 session
```bash
# 从 sessions.json 找到该时段的 session-id
cat ~/.openclaw/agents/main/sessions/sessions.json | grep -A5 "2026-02-04"

# 读取该 session 的详细对话日志
ls -la ~/.openclaw/agents/main/sessions/*.jsonl
tail -n 200 ~/.openclaw/agents/main/sessions/<session-id>.jsonl
```

### Step 4: 提取证据并脱敏
复制关键日志行，然后：
1. 替换所有真实 ID（Discord ID、设备 ID 等）→ `<占位符>`
2. 替换所有真实用户名 → `<用户名>`
3. 替换所有本地路径 → `<本地路径>`
4. 保留时间戳和错误模式

**证据格式示例**：
```
现象：Discord WebSocket 频繁断连
证据：~/.openclaw/logs/gateway.log @ 2026-02-01T23:13:20.697Z
原文："[discord] gateway: WebSocket connection closed with code 1005"
```

---

## 不确定内容该写哪？
- SOP变了 → `SKILL.md`
- 常见错误+解法 → `TROUBLESHOOTING.md`
- 设备/版本差异 → `LOG.md`

---

## 担心泄露隐私？
- 替换：`<USER_NAME>`, `<USER_PHONE>`, `<USER_ADDRESS>`, `<DEVICE_ID>`, `<GUILD_ID>`, `<CHANNEL_ID>`
- 删除：含隐私的截图、完整日志原文
- 保留：问题现象、解法步骤（脱敏后）

### 常见容易漏的敏感信息

| 类型 | 真实数据（❌ 禁止） | 正确写法（✅ 推荐） |
|------|-------------------|-------------------|
| 真实姓名 | 张永生、李明 | `<联系人姓名>`、`<用户姓名>` |
| 手机号 | 186xxxx | `<USER_PHONE>`、`<手机号>` |
| 地址 | 北京市xxx | `<USER_ADDRESS>`、`<收货地址>` |
| Discord ID | 1154989... | `<GUILD_ID>`、`<服务器ID>` |
| 设备序列号 | S2D7N... | `<DEVICE_ID>` |
| 本地路径 | `~/clawd/memory/` | 不写，或写 `<本地路径>` |
| API Key | f0d98... | `<API_KEY>` |

### 脱敏规则

**规则 1：凡是看起来像随机字符串的，都换成占位符**
- 15位以上的数字串 → 占位符
- 包含字母+数字的随机串 → 占位符

**规则 2：真人真名必须替换**
- ❌ "发送消息给张永生"
- ✅ "发送消息给 `<联系人姓名>`"

**规则 3：绝不暴露本地文件路径**
- ❌ "参考文件：`~/clawd/memory/2026-02-04.md`"
- ✅ "基于实测记录"

---

## 不确定是不是"新增价值"？
问自己：
- 同事在同样环境下会踩这个坑吗？
- 这个信息能帮他们节省10分钟以上吗？
- 如果没有这个记录，他们会重复我的试错吗？

如果都是"是" → 值得写。

---

## 工作内容涉及商业机密或可能违法？
**停止并请示。**

如果出现以下情况，**禁止写入 skill**：
- 涉及公司内部未公开数据
- 可能用于非法入侵、数据窃取、欺诈
- 侵犯他人知识产权
- 违反职业道德或可能造成伤害

**处理流程**：
1. 立即停止 skill 编写
2. 向人类说明："此工作内容可能涉及 [商业机密/法律风险/侵权]，我无法继续"
3. 等待人类明确指示
4. 如人类确认无风险并授权，方可继续

**宁可不做，不要做错。**

---

## 常见日志模式速查

### Discord 相关问题
| 日志关键词 | 含义 | 常见解法 |
|-----------|------|---------|
| `WebSocket connection closed with code 1005` | 正常关闭 | 无需处理，会自动重连 |
| `WebSocket connection closed with code 1006` | 异常断开 | 检查网络，等待自动重连 |
| `connection stalled: no HELLO received` | 连接停滞 | Gateway 会自动退避重连 |
| `Message Content Intent is limited` | Intent 受限 | 100服务器以下可用，无需验证 |

### ADB/设备相关问题
| 日志关键词 | 含义 | 常见解法 |
|-----------|------|---------|
| `No devices connected` | ADB 无设备 | 检查USB线、重新插拔、开启USB调试 |
| `exec failed` | 命令执行失败 | 检查命令语法、参数完整性 |
| `Missing required parameter` | 参数缺失 | 补充缺失参数再重试 |

---

## 提交前强制检查

**必须使用 SKILL.md 最后的提交前检查清单**，逐条确认：
- [ ] 内容基于真实运行日志
- [ ] 无真实敏感信息（已替换为占位符）
- [ ] 已向人类汇报并获得同意
