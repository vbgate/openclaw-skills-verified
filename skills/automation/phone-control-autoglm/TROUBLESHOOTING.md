# 故障排查指南

本文件基于 OpenClaw 原生日志记录的问题与解决方案。

---

## 1. ADB 设备未连接

### 现象
执行检查脚本时报告设备未连接。

**证据**：gateway.err.log @ 2026-02-04T04:32:11.274Z
```
[tools] exec failed: 🔍 Checking system requirements...
2. Checking connected devices... ❌ FAILED
   Error: No devices connected.
```

### 排查步骤
1. **检查 USB 线**：确认使用支持数据传输的 USB 线，而非仅充电线
2. **重新插拔**：断开并重新连接 USB 线
3. **手机端授权**：
   - 解锁手机屏幕
   - 弹出「允许USB调试」对话框时，勾选「始终允许」→ 点击「允许」
   - 如不小心点了「拒绝」，需重新插拔 USB 线

### 解决方案
```bash
# 验证设备连接
adb devices

# 应显示类似：
# List of devices attached
# <DEVICE_ID>    device
```

---

## 2. 工具参数错误

### 现象
调用 edit 工具时返回参数缺失错误。

**证据**：gateway.err.log @ 2026-02-04T10:41:30.973Z
```
[tools] edit failed: Missing required parameter: newText (newText or new_string)
```

**证据**：gateway.err.log @ 2026-02-04T10:41:36.017Z
```
[tools] edit failed: Missing required parameter: newText (newText or new_string)
```

**证据**：gateway.err.log @ 2026-02-04T10:41:55.068Z
```
[tools] edit failed: Missing required parameter: newText (newText or new_string)
```

### 原因
调用 edit 工具时未提供 `newText` 或 `new_string` 参数。

### 解决方案
确保调用 edit 时包含完整参数：
```javascript
// 正确用法
edit({
  path: "文件路径",
  oldText: "旧文本内容",
  newText: "新文本内容"  // 或 new_string
})
```

---

## 3. Shell 命令语法错误

### 现象
执行 shell 命令时返回引号匹配错误。

**证据**：gateway.err.log @ 2026-02-04T10:12:37.992Z
```
[tools] exec failed: zsh:13: unmatched "
Command exited with code 1
```

**证据**：gateway.err.log @ 2026-02-04T10:56:16.350Z
```
[tools] exec failed: zsh:3: unmatched '
Command exited with code 1
```

### 原因
Shell 命令中引号未正确配对或转义。

### 解决方案
1. **检查引号配对**：确保每个开引号都有对应的闭引号
2. **使用转义**：在命令中使用引号时需转义
   ```bash
   # 错误
   echo "He said "Hello""
   
   # 正确
   echo "He said \"Hello\""
   # 或
   echo 'He said "Hello"'
   ```
3. **使用单引号包裹**：当命令中包含双引号时，用单引号包裹整个命令

---

## 4. 文本匹配失败

### 现象
edit 工具报告无法找到匹配的文本。

**证据**：gateway.err.log @ 2026-02-04T10:40:34.770Z
```
[tools] edit failed: Could not find the exact text in /Users/<USERNAME>/clawd/skills/phone-control-autoglm/SKILL.md. 
The old text must match exactly including all whitespace and newlines.
```

### 原因
`oldText` 参数中的文本与实际文件内容不完全匹配（包括空格、换行等）。

### 解决方案
1. **精确匹配**：确保 `oldText` 与文件中的文本完全一致
2. **检查空白字符**：包括空格、制表符、换行符
3. **先读取再编辑**：
   ```javascript
   // 先读取文件确认内容
   read({ path: "文件路径" })
   // 然后基于实际内容构造 oldText
   ```

---

## 5. Node 环境错误

### 现象
执行 node 相关命令时报告找不到 node。

**证据**：gateway.err.log @ 2026-02-01T17:34:43.210Z
```
[tools] exec failed: env: node: No such file or directory
Command exited with code 127
```

**证据**：gateway.err.log @ 2026-02-02T07:19:10.707Z
```
[tools] exec failed: env: node: No such file or directory
Command exited with code 127
```

**证据**：gateway.err.log @ 2026-02-02T07:19:13.236Z
```
[tools] exec failed: zsh:1: no such file or directory: /opt/homebrew/bin/node
Command exited with code 127
```

### 原因
Node.js 未安装或不在系统 PATH 中。

### 解决方案
```bash
# macOS 安装 Node.js
brew install node

# 验证安装
node --version
npm --version

# 如果已安装但找不到，检查 PATH
echo $PATH
# 确保包含 /opt/homebrew/bin (Apple Silicon) 或 /usr/local/bin (Intel)
```

---

## 6. 中文输入失败

### 现象
`Type` 指令后输入框空白或显示英文。

### 解决方案
**强制切换 ADB Keyboard**：
```bash
adb shell ime enable com.android.adbkeyboard/.AdbIME
adb shell ime set com.android.adbkeyboard/.AdbIME
```

**替代方案**：如果某个 App 输入框不兼容，改用其他交互方式（如地图点选代替手输）

---

## 7. 执行中途断开

### 现象
任务跑到一半，终端显示连接断开。

### 原因
手机锁屏或 USB 松动。

### 预防方案
```bash
# 设置30分钟息屏
adb shell settings put system screen_off_timeout 1800000

# 插电常亮
adb shell svc power stayon true
```

---

## 8. 模型 API 报错

### 现象
终端显示 HTTP error 或 token 相关错误。

### 排查清单
- API Key 是否正确？
- 智谱账户余额是否充足？
- 网络是否通畅？

---

## 故障速查表

| 问题 | 现象 | 解法 |
|------|------|------|
| ADB 连不上 | `adb devices` 空列表 | 重插USB、手机解锁、点「允许」 |
| 参数缺失 | `Missing required parameter` | 检查工具调用参数完整性 |
| Shell 语法错误 | `unmatched "` | 检查引号配对和转义 |
| 文本不匹配 | `Could not find the exact text` | 精确匹配包括空白字符 |
| Node 未找到 | `node: No such file` | 安装 Node.js 或检查 PATH |
| 中文输不进 | 输入框空白 | 切 ADB Keyboard |
| 执行一半断开 | 手机锁屏 | 设置30分钟息屏+插电常亮 |
| 找不到 App | 模型点错位置 | 明确说 App 全称 |
