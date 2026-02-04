# Contributing (for OpenClaw teammates)

Quick checklist before you commit:
- [ ] Skill targets **one scenario** only
- [ ] No real personal data / secrets / API keys
- [ ] No auto-pay or destructive commands
- [ ] LOG.md only has **new value** (not repeated successes)

If you're an OpenClaw agent opening PR/Issue → **ask your human first**.

---

## 0) One-skill-one-job
- A skill should target **one scenario**.
- If a change introduces a second scenario, split into another skill.

## 1) Progressive loading (required structure)

Each skill folder should be small and layered:

```
<skill>/
├── SKILL.md              # required: lean core + frontmatter metadata
├── SKILL.zh.md           # optional: Chinese version (if multi-language)
├── SKILL.en.md           # optional: English version (if multi-language)
├── TROUBLESHOOTING.md    # required: fixes (load only when stuck)
└── LOG.md                # optional: concise run notes (append only when helpful)
```

### SKILL.md must include
- **Frontmatter**: `name`, `description`, and **prerequisites** / **tested_on`.
- **Core SOP**: the shortest reliable steps.
- **Safety gates**: where to stop for human confirmation.
- Links: "See TROUBLESHOOTING.md / LOG.md when needed".

### i18n / Region support

**Mark region-specific skills clearly:**

```yaml
---
name: food-ordering
description: '美团/大众点评外卖自动下单'
language: zh
region: cn                    # cn, us, eu, global, etc.
applicable_to: 🇨🇳 中国用户（需要美团/大众点评App）
---
```

**Multi-language skills:**
- Default `SKILL.md` = primary language (usually the skill's native region language)
- `SKILL.zh.md` = Chinese version (if different from default)
- `SKILL.en.md` = English version (for global users)
- Same pattern for `TROUBLESHOOTING.zh.md`, etc.

**Install script handles language selection automatically.**

### LOG.md is not infinite
Only append when it helps teammates:
- ✅ New device / OS / vendor quirk not previously documented
- ✅ New failure mode + concrete workaround
- ✅ A previous workaround became obsolete (note deprecation)
- ❌ Repeating the same success with no new info
- ❌ Raw chat transcripts, screenshots with private data

Prefer **summaries** over walls of text.

## 2) Installing a single skill (for testing)

See README section "Install (single skill)".

## 3) Updating / improving an existing skill (optional)

### Human consent rule
If you are an OpenClaw agent and you want to open a PR/Issue:
- You **must ask your human** first.
- Do not include private data.

### What to change
- If SOP changes: update `SKILL.md`.
- If it's a fix for a common failure: update `TROUBLESHOOTING.md`.
- If it's a new environment-specific note: append to `LOG.md` (brief).

## 4) Contributing a new skill

### Option A: Direct commit (maintainers)
1. Create a new folder under `skills/<category>/<skill-name>/`
2. Add `SKILL.md` + `TROUBLESHOOTING.md` (+ optional `LOG.md`)
3. Update `INDEX.md`
4. Commit & push

### Option B: PR (external OpenClaw)
- Fork → commit → PR
- Must confirm: privacy-safe, no secrets, no destructive actions

## 5) Safety checklist (must)
- [ ] No real personal data
- [ ] No secrets (API keys/tokens/passwords)
- [ ] No auto-pay / irreversible actions
- [ ] No destructive commands
- [ ] HTTPS only

See SECURITY.md.
