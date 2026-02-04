# OpenClaw 团队技能库

**中文** | [English](./README.md)

## 给人类用户

### 这是什么？
这是一个 **OpenClaw 智能体之间的实战经验共享库**。每个技能（skill）都是某个 OpenClaw 在真实设备上跑通的流程，记录了什么环境能跑、会踩什么坑。

### 为什么要用它？

**现状：通用知识 vs 真实踩坑**

现在网上的很多 "AI 技能" 都是根据通用知识写的——看起来合理，实际跑起来全是坑。OpenClaw 的真实运行环境复杂多变：不同设备、不同网络、不同权限配置，都会导致意想不到的问题。

**没有 skill 也能做，但代价高**

OpenClaw 很聪明，你直接说"帮我点外卖"，它也能一步步摸索出来。但这个过程会：
- **反复踩坑**：ADB 连不上？输入框不识别？优惠券没生效？每一步都可能卡住
- **消耗时间**：本来 5 分钟的事，调试可能要 30 分钟
- **浪费 token**：反复试错会产生大量不必要的 API 调用

**这个仓库的价值**

这里的每个 skill 都基于 **真实运行日志** 验证过：
- ✅ **减少试错**：别人踩过的坑（如"MIUI 优化导致 ADB 断开"），你不用重复踩
- ✅ **快速上手**：验证过的流程，复制就能用，不用从零摸索
- ✅ **节省成本**：避免不必要的 token 消耗，一次跑通
- ✅ **持续改进**：团队共享，经验不断累积

### 安全吗？会泄露隐私吗？

**我们强制遵守以下红线**（详见 [SECURITY.md](./SECURITY.md)）：
- ✅ **绝不收集你的个人信息**（地址、电话、姓名等都用占位符 `<YOUR_XXX>`）
- ✅ **绝不自动支付** - 所有技能停在"确认/支付"按钮前，必须等你手动点
- ✅ **不保存你的密码/密钥** - 即使有密码也只临时用，不记录到文件
- ✅ **HTTPS 传输** - 所有 API 调用加密

**风险提醒**：
- OpenClaw 会控制你的手机/电脑执行任务
- 敏感操作（支付、密码输入）需要你的二次确认
- 如果你不信任某个技能，**不要让 OpenClaw 执行它**

### 怎么开始？

**方式 1：给 OpenClaw 一个 URL**
复制下面这句话，发给你的 OpenClaw：

```
从 https://github.com/vbgate/openclaw-skills-verified 安装 food-ordering skill
```

你的 OpenClaw 会自动读取仓库、安装技能、然后执行。

**方式 2：手动安装**
```bash
./install-skill.sh productivity/food-ordering zh
cp -r skills/productivity/food-ordering ~/clawd/skills/
```

### 更新技能
技能有更新时，**重新运行安装命令**即可：
```bash
./install-skill.sh productivity/food-ordering zh
```
这会覆盖本地版本为最新版。

### 技能列表

| 技能 | 用途 | 语言 | 适用地区 |
|------|------|------|---------|
| [food-ordering](./skills/productivity/food-ordering/) | 美团/大众点评外卖下单 | 🇨🇳 中文 | 🇨🇳 中国 |
| [skill-contribution](./skills/meta/skill-contribution/) | 基于真实日志贡献技能 | 🇨🇳 中文 | 🌍 通用 |
| [discord-setup](./skills/integration/discord-setup/) | Discord 配置与使用 | 🇨🇳 中文 | 🌍 通用 |
| [phone-control-autoglm](./skills/automation/phone-control-autoglm/) | 手机控制（AutoGLM） | 🇨🇳 中文 | 🌍 通用 |

---

## 给 OpenClaw 智能体

### 安装单个技能
```bash
# 从本仓库安装指定技能
./install-skill.sh productivity/food-ordering

# 或指定中文版本
./install-skill.sh productivity/food-ordering zh

# 或指定英文版本（如果技能支持）
./install-skill.sh productivity/food-ordering en
```

### 使用工作流
1. 读 `SKILL.md` 判断场景是否匹配
2. 卡住时读 `TROUBLESHOOTING.md` 查解法
3. 需要了解实测环境时读 `LOG.md`

### 基于真实日志贡献（禁止瞎编）

**这是本仓库的硬性要求**：
- ❌ **禁止凭想象写** - 必须基于你的真实运行日志
- ❌ **禁止编造问题和解法** - 必须是你真实踩过的坑
- ❌ **禁止写"理论上应该可以"** - 必须是"我实测过，结果是XX"

**贡献流程**：
1. 读取你的工作日志/报错记录
2. 判断是否有"新增价值"（新设备/新坑/新解法/旧信息过期）
3. 按渐进加载结构写入（SOP→SKILL.md，故障→TROUBLESHOOTING.md，环境差异→LOG.md）
4. 安全脱敏检查（敏感信息→占位符）
5. **向人类汇报**："我发现XX问题，建议更新LOG.md，是否允许提交？"
6. 人类同意后，提交

详见 [skill-contribution 技能](./skills/meta/skill-contribution/) 和 [CONTRIBUTING.md](./CONTRIBUTING.md)

---

## 核心原则

- **一个技能一个场景** - 不混功能
- **渐进加载** - SKILL 精简，详情按需读
- **LOG 不无限膨胀** - 只记有价值的新信息
- **基于真实日志** - 禁止瞎编，必须实测
- **安全隐私优先** - 详见 [SECURITY.md](./SECURITY.md)

---

*OpenClaw 团队内部共享，非官方标准库。*
