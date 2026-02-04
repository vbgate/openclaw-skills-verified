---
name: phone-control-autoglm
description: '使用 AutoGLM 框架控制手机（Android/HarmonyOS），通过自然语言完成自动化任务'
category: automation
language: zh
region: global
applicable_to: 🌍 需要控制安卓/HarmonyOS手机的用户
prerequisites:
  - 安装 Open-AutoGLM 框架
  - ADB 工具 + ADB Keyboard
  - 安卓手机（Android 7.0+）或华为鸿蒙
  - USB 数据线（支持数据传输）
  - 智谱 API Key 或本地 GPU（24GB+）
tested_on:
  - device: 华为 Mate20
    os: Android 10
    date: 2026-02-04
    result: success
    notes: 微信消息发送成功，点外卖流程完成80%（ADB断开中断）
last_verified: 2026-02-04
safety_gates:
  - 支付/密码/验证码场景触发人工接管
  - 敏感操作需用户二次确认
---

# OpenClaw 控制手机（AutoGLM）

## 一句话
让 OpenClaw 通过自然语言控制你的安卓手机，自动完成打开App、点击、输入、滑动等操作。

## 核心原理
```
你说"打开微信发消息给张三"
    ↓
OpenClaw 调用 AutoGLM
    ↓
截图 → 视觉模型理解界面 → 生成操作指令（Tap/Type/Swipe）
    ↓
ADB 执行操作
    ↓
手机完成任务
```

## 快速开始（给 OpenClaw）

```bash
# 1. 克隆代码（OpenClaw 自动执行）
git clone https://github.com/thunlp/Open-AutoGLM.git ~/openclaw-work/Open-AutoGLM
cd ~/openclaw-work/Open-AutoGLM && pip install -e .

# 2. 引导人类完成手机端配置（见下方"需人类手动操作"部分）

# 3. 连接并运行
adb devices  # 让人类在手机上点「允许」
python main.py --base-url https://open.bigmodel.cn/api/paas/v4 \
  --model autoglm-phone --apikey "<API_KEY>" \
  "<任务描述>"
```

## 前置条件清单

### 1. 安装 AutoGLM 框架（OpenClaw 自动执行）
```bash
# 克隆项目到本地
git clone https://github.com/thunlp/Open-AutoGLM.git ~/openclaw-work/Open-AutoGLM
cd ~/openclaw-work/Open-AutoGLM

# 创建虚拟环境并安装
python -m venv venv
source venv/bin/activate
pip install -e .
```

### 2. 安装 ADB 工具
```bash
# macOS
brew install android-platform-tools

# 验证
adb version
```

### 3. 手机端配置（关键！需人类手动操作）

**⚠️ 以下步骤必须由人类在手机上手动完成，OpenClaw 无法自动完成：**

1. **开启开发者模式**：
   - 人类操作：设置 → 关于手机 → 连续点击「版本号」7次
   - 直到提示「您已处于开发者模式」

2. **开启 USB 调试**：
   - 人类操作：设置 → 开发者选项 → USB调试（打开）
   - **安全设置**：开发者选项 → 「仅充电模式下允许ADB调试」（打开）

3. **安装 ADB Keyboard**（中文输入必需）：
   - OpenClaw 下载：https://github.com/senzhk/ADBKeyBoard/releases
   - 人类确认安装 APK（可能需要允许「未知来源」安装）
   - 人类启用：设置 → 语言和输入法 → 勾选「ADB Keyboard」

4. **首次连接授权**（每次重新插拔都可能需要）：
   - 插 USB 线后，手机上会弹出「允许USB调试吗？」
   - 人类必须勾选「始终允许」→ 点击「允许」
   - ⚠️ 如果不小心点了「拒绝」，需要重新插拔 USB 线

### 4. 数据线要求
⚠️ **必须使用支持数据传输的 USB 线**，不是仅充电线！

### 5. 模型选择（二选一）

**方案A：智谱 BigModel API（推荐，最简单）**
- 优点：无需GPU，即开即用
- 缺点：需要 API Key（可能有费用）
- 获取：https://open.bigmodel.cn/

**方案B：本地部署（需高性能GPU）**
- 硬件：NVIDIA GPU 24GB+ 显存（如 RTX 4090）
- 磁盘：20GB 模型文件
- 框架：vLLM 或 SGLang

## 核心流程

### Step 1: 连接手机
```bash
# 手机连接电脑，弹出「允许USB调试」→ 勾选「始终允许」→ 允许
adb devices

# 应显示设备：
# List of devices attached
# S2D7N19216007553    device
```

### Step 2: 启用 ADB Keyboard
```bash
adb shell ime enable com.android.adbkeyboard/.AdbIME
adb shell ime set com.android.adbkeyboard/.AdbIME
```

### Step 3: 设置屏幕常亮（防中断）
```bash
# 30分钟息屏
adb shell settings put system screen_off_timeout 1800000

# 插电常亮（可选）
adb shell svc power stayon true
```

### Step 4: 运行任务（智谱API方案）
```bash
cd ~/openclaw-work/Open-AutoGLM
source venv/bin/activate

python main.py \
  --base-url https://open.bigmodel.cn/api/paas/v4 \
  --model autoglm-phone \
  --apikey "你的智谱API-Key" \
  "打开微信，给文件传输助手发送：测试成功"
```

### Step 5: 观察执行
- AutoGLM 会截图 → 分析界面 → 生成操作 → ADB执行
- 终端会显示每步操作和延迟
- 成功会显示 ✅，失败会显示 ❌ 并重试

## 我踩过的坑（实测记录）

### 1. ADB 设备频繁断开
**现象**：执行一半，`adb devices` 突然显示空列表  
**原因**：手机锁屏或USB线松动  
**解法**：
- 设置 30 分钟息屏（上面 Step 3）
- 使用质量好、确定能传数据的 USB 线
- 重新插拔后，手机上重新点「允许USB调试」

### 2. 中文输入框不吃字
**现象**：`Type "<联系人姓名>"` 后输入框空白  
**原因**：ADB Keyboard 未启用或被系统切换  
**解法**：
- 强制切换：`adb shell ime set com.android.adbkeyboard/.AdbIME`
- 或者改为用「地图点选」代替手输（如外卖地址）

### 3. 地址输入失败（外卖场景）
**现象**：门牌号输入框不接受 ADB 输入  
**原因**：某些 App 输入框对 ADB Keyboard 兼容性差  
**解法**：
- 不用手输，改用「地图列表点选」楼栋
- 门牌号简化为简短格式（如「5-603」而非「5单元603」）

### 4. 中途锁屏导致中断
**现象**：手机黑屏后，ADB 连接断开，任务失败  
**原因**：默认息屏时间太短  
**解法**：`adb shell settings put system screen_off_timeout 1800000`（30分钟）

## 支持的应用（50+）

已验证可用：
- ✅ 微信（发消息、群聊回复）
- ✅ 美团/大众点评（搜索、加购、填地址）
- 🧪 淘宝（理论上支持，未实测）

常见支持：抖音、小红书、知乎、高德地图、京东等。

## WiFi 无线控制（无需USB线）

同一 WiFi 下：
```bash
# 先用USB连接时启用WiFi调试
adb tcpip 5555

# 断开USB，连接WiFi
adb connect 192.168.1.xxx:5555  # 手机IP地址

# 无线控制
python main.py --connect 192.168.1.xxx:5555 "打开抖音"
```

## 安全红线

- ✅ **支付/密码/验证码** → 自动触发人工接管，停在输入前等你确认
- ✅ **敏感操作** → OpenClaw 会汇报"即将执行XX，是否继续？"
- ❌ **绝不自动完成支付** → 永远停在「立即支付」按钮前

## 故障速查

| 问题 | 现象 | 解法 |
|------|------|------|
| ADB 连不上 | `adb devices` 空列表 | 重插USB、手机解锁、点「允许」 |
| 中文输不进 | 输入框空白 | 切 ADB Keyboard：`adb shell ime set com.android.adbkeyboard/.AdbIME` |
| 执行一半断开 | 手机锁屏 | 设置30分钟息屏+插电常亮 |
| 模型返回错误 | API报错 | 检查API Key、网络、余额 |
| 找不到App | 模型点错位置 | 明确说App全称，如「美团外卖」而非「美团」 |

---

## 参考文件
- 故障排查：**TROUBLESHOOTING.md**
- 实测记录：**LOG.md**
