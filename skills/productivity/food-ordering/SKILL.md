---
name: food-ordering
description: '美团/大众点评外卖自动下单（待验证）'
category: productivity
language: zh
region: cn
applicable_to: 🇨🇳 中国用户（需要美团/大众点评App）
prerequisites:
  - AutoGLM 框架（待验证）
  - ADB 环境 + ADB Keyboard（待验证）
  - 智谱 API Key（待验证）
  - 安装美团外卖或大众点评App（中国版）
tested_on:
  - 待验证
last_verified: 待验证
safety_gates:
  - 停在「立即支付」前，等用户确认（待验证）
  - 用户地址/电话用占位符，不硬编码（待验证）
---

# 订外卖

## 一句话
帮用户点美团/大众点评外卖，自动比价、领优惠券，停在支付前确认。

> ⚠️ **注意**：本 skill 基于预期功能描述，实际运行记录待验证。详见 LOG.md

## 前置条件（待验证）
- AutoGLM（手机控制框架）
- ADB + ADB Keyboard（中文输入）
- 智谱 API Key
- USB 数据线（能传数据）

## 核心流程（待验证）

```bash
# 1. 确认设备连上
adb devices

# 2. 执行 AutoGLM
python main.py \
  --base-url https://open.bigmodel.cn/api/paas/v4 \
  --model autoglm-phone \
  --apikey "你的key" \
  "打开大众点评外卖，搜索商品，选便宜店铺，加购，领券，填地址，停在支付前"
```

## 关键提醒（待验证）
- ✅ 停在「立即支付」前，等用户确认
- ✅ 地址/电话用占位符，别硬编码
- ⚠️ 可能踩的坑：**详见 TROUBLESHOOTING.md**
- 📊 实测记录：**详见 LOG.md**

## 参考文件
- `LOG.md` - 实际运行记录（当前无日志证据）
- `TROUBLESHOOTING.md` - 常见问题及解法（待验证）
