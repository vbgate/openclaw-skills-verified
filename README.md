# OpenClaw Skills Verified

[中文](./README.zh.md) | **English**

## For Human Users

### What Is This?
This is a **battle-tested skill sharing library between OpenClaw agents**. Each skill is a workflow that some OpenClaw actually ran through on real devices, recording what environments work and what pitfalls to avoid.

### Why Use It?

**The Reality: Generic Knowledge vs. Real Pitfalls**

Many "AI skills" online are written from generic knowledge — they look reasonable, but fall apart in practice. OpenClaw's real execution environment is complex and variable: different devices, networks, and permission configs all lead to unexpected issues.

**You Can Do It Without Skills, But At a Cost**

OpenClaw is smart. If you say "order me takeout," it can figure it out step by step. But this process will:
- **Hit pitfalls repeatedly**: ADB won't connect? Input box not recognized? Coupon didn't apply? Every step can get stuck
- **Consume time**: What should take 5 minutes might take 30 to debug
- **Waste tokens**: Repeated trial-and-error generates unnecessary API calls

**The Value of This Repository**

Every skill here is verified based on **real execution logs**:
- ✅ **Reduce trial-and-error**: Others' pitfalls (like "MIUI optimization breaks ADB") you don't repeat
- ✅ **Quick start**: Verified workflows, copy and use, no zero-to-one摸索
- ✅ **Save costs**: Avoid unnecessary token consumption, succeed on first try
- ✅ **Continuous improvement**: Team sharing, experience keeps accumulating

### Is It Safe? Will It Leak Privacy?

**We Enforce These Red Lines** (see [SECURITY.md](./SECURITY.md)):
- ✅ **Never collect personal info** (addresses, phones, names all use placeholders `<YOUR_XXX>`)
- ✅ **Never auto-pay** - All skills stop before "confirm/pay" buttons, wait for your manual click
- ✅ **Don't save passwords/keys** - Even if password is used, it's temporary, not logged to files
- ✅ **HTTPS transmission** - All API calls encrypted

**Risk Notice**:
- OpenClaw controls your phone/computer to execute tasks
- Sensitive operations (payment, password entry) require your confirmation
- If you don't trust a skill, **don't let OpenClaw execute it**

### How to Start?

**Method 1: Give OpenClaw a URL**
Copy this sentence, send to your OpenClaw:

```
Install discord-setup skill from https://github.com/vbgate/openclaw-skills-verified
```

Your OpenClaw will auto-read the repo, install the skill, then execute.

**Method 2: Manual Install**
```bash
./install-skill.sh integration/discord-setup en
cp -r skills/integration/discord-setup ~/clawd/skills/
```

### Update Skills
When skills update, **just re-run the install command**:
```bash
./install-skill.sh integration/discord-setup en
```
This overwrites local version with latest.

### Skill List

| Skill | Purpose | Language | Region |
|-------|---------|----------|--------|
| [discord-setup](./skills/integration/discord-setup/) | Discord config and usage | 🇬🇧 English / 🇨🇳 Chinese | 🌍 Global |
| [skill-contribution](./skills/meta/skill-contribution/) | Contribute skills based on real logs | 🇬🇧 English / 🇨🇳 Chinese | 🌍 Global |
| [phone-control-autoglm](./skills/automation/phone-control-autoglm/) | Phone control (AutoGLM) | 🇬🇧 English / 🇨🇳 Chinese | 🌍 Global |
| [food-ordering](./skills/productivity/food-ordering/) | Meituan/Dianping food ordering | 🇨🇳 Chinese | 🇨🇳 China |

---

## For OpenClaw Agents

### Install Single Skill
```bash
# Install specified skill from this repo
./install-skill.sh integration/discord-setup

# Or specify English version
./install-skill.sh integration/discord-setup en

# Or specify Chinese version (if skill supports)
./install-skill.sh integration/discord-setup zh
```

### Usage Workflow
1. Read `SKILL.md` to judge if scenario matches
2. When stuck, read `TROUBLESHOOTING.md` for solutions
3. When needing to understand test environment, read `LOG.md`

### Contribute Based on Real Logs (No Fabrication)

**This is a hard requirement of this repo**:
- ❌ **No writing from imagination** - Must be based on your real execution logs
- ❌ **No fabricating problems and solutions** - Must be pitfalls you actually encountered
- ❌ **No "theoretically should work"** - Must be "I tested it, result was XX"

**Contribution Process**:
1. Read your work logs/error records
2. Judge if there's "added value" (new device/new pitfall/new solution/old info expired)
3. Write to progressive loading structure (SOP→SKILL.md, failures→TROUBLESHOOTING.md, env differences→LOG.md)
4. Safe desensitization check (sensitive info→placeholders)
5. **Report to human**: "I found XX issue, suggest updating LOG.md, may I submit?"
6. After human agrees, submit

See [skill-contribution skill](./skills/meta/skill-contribution/) and [CONTRIBUTING.md](./CONTRIBUTING.md)

---

## Core Principles

- **One skill, one scenario** - Don't mix functions
- **Progressive loading** - SKILL lean, details on demand
- **LOG doesn't infinitely expand** - Only record valuable new info
- **Based on real logs** - No fabrication, must test
- **Security and privacy first** - See [SECURITY.md](./SECURITY.md)

---

*OpenClaw team internal sharing, not official standard library.*
