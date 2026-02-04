---
name: phone-control-autoglm
description: 'Control Android/HarmonyOS phones using AutoGLM framework, complete automation tasks via natural language'
category: automation
language: en
region: global
applicable_to: 🌍 Users needing to control Android/HarmonyOS phones
prerequisites:
  - Open-AutoGLM framework installed
  - ADB tools + ADB Keyboard
  - Android phone (Android 7.0+) or Huawei HarmonyOS
  - USB data cable (supports data transfer)
  - Zhipu API Key or local GPU (24GB+)
tested_on:
  - device: Huawei Mate20
    os: Android 10
    date: 2026-02-04
    result: success
    notes: WeChat messaging successful, food ordering 80% complete (interrupted by ADB disconnect)
last_verified: 2026-02-04
safety_gates:
  - Payment/password/verification triggers human handover
  - Sensitive operations require user confirmation
---

# OpenClaw Phone Control (AutoGLM)

## In One Sentence
Let OpenClaw control your Android phone via natural language, automatically open apps, tap, input, swipe, and complete tasks.

## Core Principle
```
You say "Open WeChat and send message to John"
    ↓
OpenClaw invokes AutoGLM
    ↓
Screenshot → Visual model understands UI → Generates action (Tap/Type/Swipe)
    ↓
ADB executes action
    ↓
Phone completes task
```

## Quick Start (For OpenClaw)

```bash
# 1. Clone code (OpenClaw auto-executes)
git clone https://github.com/thunlp/Open-AutoGLM.git ~/openclaw-work/Open-AutoGLM
cd ~/openclaw-work/Open-AutoGLM && pip install -e .

# 2. Guide human to complete phone-side config (see "Requires Human Manual Operation" below)

# 3. Connect and run
adb devices  # Ask human to tap "Allow" on phone
python main.py --base-url https://open.bigmodel.cn/api/paas/v4 \
  --model autoglm-phone --apikey "<API_KEY>" \
  "<task description>"
```

## Prerequisites Checklist

### 1. Install AutoGLM Framework (OpenClaw auto-executes)
```bash
# Clone project locally
git clone https://github.com/thunlp/Open-AutoGLM.git ~/openclaw-work/Open-AutoGLM
cd ~/openclaw-work/Open-AutoGLM

# Create virtual env and install
python -m venv venv
source venv/bin/activate
pip install -e .
```

### 2. Install ADB Tools
```bash
# macOS
brew install android-platform-tools

# Verify
adb version
```

### 3. Phone-side Configuration (Critical! Requires Human Manual Operation)

**⚠️ Following steps must be manually completed by human on phone, OpenClaw cannot auto-complete:**

1. **Enable Developer Mode**:
   - Human action: Settings → About Phone → Tap "Build Number" 7 times
   - Until prompt says "You are now a developer"

2. **Enable USB Debugging**:
   - Human action: Settings → Developer Options → USB Debugging (enable)
   - **Security setting**: Developer Options → "Allow ADB debugging in charging only mode" (enable)

3. **Install ADB Keyboard** (Required for Chinese input):
   - OpenClaw downloads: https://github.com/senzhk/ADBKeyBoard/releases
   - Human confirms APK install (may need allow "Unknown Sources")
   - Human enables: Settings → Language & Input → Check "ADB Keyboard"

4. **First Connection Authorization** (May be required after each re-plug):
   - After plugging USB, phone shows "Allow USB debugging?"
   - Human must check "Always allow" → Tap "Allow"
   - ⚠️ If accidentally tapped "Deny", need to re-plug USB

### 4. Cable Requirements
⚠️ **Must use USB cable supporting data transfer**, not charge-only!

### 5. Model Selection (Choose One)

**Option A: Zhipu BigModel API (Recommended, Simplest)**
- Pros: No GPU needed, ready to use
- Cons: Requires API Key (may incur costs)
- Get: https://open.bigmodel.cn/

**Option B: Local Deployment (Requires High-Performance GPU)**
- Hardware: NVIDIA GPU 24GB+ VRAM (e.g., RTX 4090)
- Disk: 20GB model files
- Framework: vLLM or SGLang

## Core Workflow

### Step 1: Connect Phone
```bash
# Phone connects to computer, shows "Allow USB debugging?" → Check "Always allow" → Allow
adb devices

# Should show device:
# List of devices attached
# <DEVICE_ID>    device
```

### Step 2: Enable ADB Keyboard
```bash
adb shell ime enable com.android.adbkeyboard/.AdbIME
adb shell ime set com.android.adbkeyboard/.AdbIME
```

### Step 3: Set Screen Always On (Prevent Interruption)
```bash
# 30 min screen timeout
adb shell settings put system screen_off_timeout 1800000

# Keep on while charging (optional)
adb shell svc power stayon true
```

### Step 4: Run Task (Zhipu API Option)
```bash
cd ~/openclaw-work/Open-AutoGLM
source venv/bin/activate

python main.py \
  --base-url https://open.bigmodel.cn/api/paas/v4 \
  --model autoglm-phone \
  --apikey "Your Zhipu API-Key" \
  "Open WeChat, send to file transfer assistant: Test successful"
```

### Step 5: Observe Execution
- AutoGLM screenshots → Analyzes UI → Generates action → ADB executes
- Terminal shows each step and latency
- Success shows ✅, failure shows ❌ and retries

## Pitfalls I Encountered (Real Test Records)

### 1. ADB Device Frequently Disconnects
**Phenomenon**: Running half-way, `adb devices` suddenly shows empty list
**Cause**: Phone locked or USB cable loose
**Solution**:
- Set 30 min screen timeout (Step 3 above)
- Use quality USB cable confirmed to support data
- After re-plug, tap "Allow USB debugging" on phone again

### 2. Chinese Input Box Not Receiving Text
**Phenomenon**: After `Type "<Contact Name>"`, input box blank
**Cause**: ADB Keyboard not enabled or switched by system
**Solution**:
- Force switch: `adb shell ime set com.android.adbkeyboard/.AdbIME`
- Or use "map point selection" instead of typing (e.g., for delivery address)

### 3. Address Input Failure (Food Ordering Scenario)
**Phenomenon**: Room number input box doesn't accept ADB input
**Cause**: Some app input boxes have poor compatibility with ADB Keyboard
**Solution**:
- Don't type manually, use "map list selection" for buildings
- Simplify room number (e.g., "5-603" instead of "Unit 5, Room 603")

### 4. Mid-Task Interruption by Screen Lock
**Phenomenon**: Phone screen off, ADB disconnects, task fails
**Cause**: Default screen timeout too short
**Solution**: `adb shell settings put system screen_off_timeout 1800000` (30 min)

## Supported Apps (50+)

Verified working:
- ✅ WeChat (send messages, group replies)
- ✅ Meituan/Dianping (search, add to cart, fill address)
- 🧪 Taobao (theoretically supported, not tested)

Commonly supported: Douyin, Xiaohongshu, Zhihu, Amap, JD, etc.

## WiFi Wireless Control (No USB Cable)

Same WiFi network:
```bash
# First enable WiFi debugging while connected via USB
adb tcpip 5555

# Disconnect USB, connect WiFi
adb connect 192.168.1.xxx:5555  # Phone IP address

# Wireless control
python main.py --connect 192.168.1.xxx:5555 "Open Douyin"
```

## Safety Red Lines

- ✅ **Payment/Password/Verification** → Auto-triggers human handover, stops before input waiting for your confirmation
- ✅ **Sensitive Operations** → OpenClaw reports "About to execute XX, continue?"
- ❌ **Never auto-complete payment** → Always stops at "Pay Now" button

## Troubleshooting

| Problem | Phenomenon | Solution |
|---------|------------|----------|
| ADB won't connect | `adb devices` empty list | Re-plug USB, unlock phone, tap "Allow" |
| Chinese won't input | Input box blank | Switch ADB Keyboard: `adb shell ime set com.android.adbkeyboard/.AdbIME` |
| Disconnects mid-task | Phone locked | Set 30 min screen timeout + keep on while charging |
| Model returns error | API error | Check API Key, network, balance |
| Can't find app | Model taps wrong place | Say full app name, e.g., "Meituan Food Delivery" not "Meituan" |

---

## Reference Files
- Troubleshooting: **TROUBLESHOOTING.md**
- Test records: **LOG.md**
