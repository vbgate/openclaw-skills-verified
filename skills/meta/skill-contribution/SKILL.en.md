---
name: skill-contribution
description: 'How to contribute/update OpenClaw skills based on real execution logs. No fabrication, real testing required.'
category: meta
language: en
prerequisites:
  - Real execution logs/error records
  - Ability to judge "added value"
  - Know safe desensitization (sensitive info → placeholders)
tested_on:
  - device: OpenClaw agent
    os: any
    date: 2026-02-04
    result: success
    notes: Process verified
last_verified: 2026-02-04
safety_gates:
  - Report changes to human, get approval before submitting
  - Pre-submission check: no sensitive info, no fabricated content
---

# Contributing Skills Based on Real Logs

## 🎯 Quality First Principles (⚠️ Core Guidelines)

- **This is a long task, you have ample time** — don't worry about time constraints
- **Quality over speed**: Better to spend more time verifying than rushing to deliver
- **No cutting corners**:
  - Don't use "inference from experience" as a substitute for log verification
  - Don't skip evidence chain tracing to finish quickly
  - No "good enough" mentality
- **Complete delivery is delivery**: Must verify all claims and output complete evidence chains before submitting

> **Your mission**: Use adequate time and rigorous attitude to produce traceable, verifiable skill records.
>
> **Quality first, speed second**.

---

## Core Red Lines (Reject submission if any violated)

❌ **No writing from memory** — Must be based on OpenClaw native logs, not "I remember"
❌ **No using OpenClaw-generated daily summaries** — Can't use `memory/YYYY-MM-DD.md` as secondary sources
❌ **No fabricating problems and solutions** — Must be real issues you've encountered, with log evidence
❌ **No "theoretically should work"** — Must be "I tested it, result was XX"
❌ **No inferring patterns from experience** — Seeing disconnections, don't write "usually recovers within 30s", only "logs show forced reconnection after 30s timeout"
❌ **No sensitive information** — Addresses/phone numbers/keys must use placeholders

> ⚠️ **Zero Inference Principle**: If logs show server returns dynamic values, strictly prohibited from summarizing as "refreshes daily", "fixed rules", or other static descriptions. Only write facts explicitly shown in logs.

---

## Data Source Requirements (Must Actually Read)

> **Rule: Read before writing. Can't find = not qualified to write.**
>
> You must be able to point at a log entry and say: *"This sentence comes from here."*

**Only Trustworthy Data Sources** (by priority):

1) **OpenClaw Gateway Runtime Logs** (Highest Priority)
```bash
~/.openclaw/logs/gateway.log        # Normal logs (startup/restart/channel connections/status)
~/.openclaw/logs/gateway.err.log    # Error logs (exceptions/429s/tool failures/slow listeners)
```

2) **OpenClaw Command Stream (for locating "which operation triggered")**
```bash
~/.openclaw/logs/commands.log
```

3) **OpenClaw Session Index (for finding correct session-id)**
```bash
~/.openclaw/agents/main/sessions/sessions.json
```

4) **OpenClaw Session Raw Conversation Logs (Strongest Traceable Evidence)**
```bash
~/.openclaw/agents/main/sessions/<session-id>.jsonl
```

5) **Tool Execution Real Output (Must be reproducible/screenshot-able/copy-able)**
- `exec` command return (stdout/stderr + exit code)
- `browser` operation actual screenshots/returns (better with targetId/screenshot files)
- `message` send real responses

> ⚠️ Note: Category 5 outputs, if not captured by session jsonl / gateway logs, still don't count as "traceable evidence". Try to paste key outputs to PR/Issue or LOG.md (desensitized).

**Prohibited Secondary Sources**:
- ❌ `memory/YYYY-MM-DD.md` (OpenClaw-generated daily summaries)
- ❌ `Open-AutoGLM-Analysis.md` (human-written analysis reports)
- ❌ My "recollections" or "I remember" (human memory unreliable)
- ❌ "I think", "should be", "theoretically", "usually", "generally"

**Every sentence must be traceable to logs**.

Recommended format for each key conclusion:
```
Evidence: ~/.openclaw/logs/gateway.err.log @ 2026-02-04T18:22:11Z (excerpt: ...)
```
Or:
```
Evidence: ~/.openclaw/agents/main/sessions/<session-id>.jsonl @ 2026-02-04T18:23:09Z (tool=exec returned: ...)
```

> Line numbers not mandatory (vary by machine/truncation), but **filename + timestamp + original excerpt** is required.

---

## When Should You Contribute?

**Judgment Criteria: Is There "Added Value"?**

✅ **Should Contribute**:
- Ran successfully on new device/OS/ROM with differences
- Discovered new failure mode + specific solution
- Previous solution expired (mark deprecated)
- Security/privacy risk discovered

❌ **Should Not Contribute**:
- Repeat same success, no new info
- Imagining "problems others might encounter"
- Raw chat logs, screenshots (with privacy)

---

## Contribution Workflow (Phased)

### Phase 0: Locate Relevant Logs

**Goal**: Find records related to your verification content from massive logs.

**Operations**:
```bash
# Search with keywords (replace with your keywords)
grep -i "discord\|adb\|error\|fail" ~/.openclaw/logs/gateway.err.log
grep -i "discord\|adb\|error\|fail" ~/.openclaw/logs/gateway.log

# Determine time range
tail -n 200 ~/.openclaw/logs/commands.log
```

**Mandatory Output**:
- [ ] Recorded approximate time range of relevant log entries
- [ ] Determined session-id for in-depth reading

---

### Phase 1: Read OpenClaw Native Logs (Mandatory)

**Goal**: Read and understand log content completely.

**Must actually execute and read** (not "I glanced at it"):
```bash
# 1) Check error logs first: usually highest info density
( tail -n 200 ~/.openclaw/logs/gateway.err.log )

# 2) Then check normal logs: confirm startup/restart/connection/channel status
( tail -n 200 ~/.openclaw/logs/gateway.log )

# 3) Check command stream: confirm actions triggered, which sessionKey
( tail -n 200 ~/.openclaw/logs/commands.log )

# 4) Check session index: find session-id you want to reference
( tail -n 50 ~/.openclaw/agents/main/sessions/sessions.json )

# 5) Open corresponding session jsonl: raw "conversation + tool calls" record
# (replace <session-id> with what you found in sessions.json)
( tail -n 400 ~/.openclaw/agents/main/sessions/<session-id>.jsonl )
```

**How to Locate Correct session-id (Recommended)**
- First find your operation's timestamp / sessionKey from `commands.log`
- Then find the session entry for the same time period from `sessions.json`, get `<session-id>`
- Finally read `sessions/<session-id>.jsonl`

**Minimum Evidence Set to Extract from Logs**:
- Original error/warning info (copy-paste, don't "paraphrase")
- Timestamp (ISO format preferred)
- Trigger action (which tool/command/session)
- Fix steps you actually executed (must be reproducible commands/click paths)

**Mandatory Output**:
- [ ] Copy-pasted at least 3 relevant log excerpts
- [ ] Each log annotated with filename and timestamp
- [ ] Recorded problem reproduction steps

> ✅ Pass standard: Every "conclusion/step/pitfall" you write can attach `Evidence: <file> @ <timestamp> (optional: line/excerpt)`.
> ❌ Fail: Only "I remember/should/theoretically".

---

### Phase 2: Extract Claims for Verification

**Goal**: Extract all technical claims from your memory/draft, prepare for verification.

**Operations**:
1. List all "conclusions", "steps", "notes" you plan to write
2. Label each claim:
   - ✅ Already has log evidence
   - ⚠️ Needs more evidence
   - ❌ No evidence (delete or mark "to be verified")

**Watch Keywords**: Following terms require log evidence support:
- "usually", "generally", "often"
- "should", "might", "probably"
- "default is", "fixed at"

**Mandatory Output**:
- [ ] List of claims to verify (at least 3 points you plan to write)
- [ ] Each point has ✅/⚠️/❌ label

---

### Phase 3: Verify Each Claim

**Goal**: Find log evidence for each claim or mark "to be verified".

**Verification Rules**:

| Judgment | Condition | Action |
|----------|-----------|--------|
| ✅ **Pass** | Clear evidence in logs | Write to skill with evidence tag |
| ⚠️ **Uncertain** | No direct evidence but related to recorded phenomena | Write to LOG.md, **clearly mark "to be verified"**, await subsequent evidence |
| ❌ **Reject** | No evidence and contradicts logs or pure speculation | Delete, don't write |

> 💡 **Handling Uncertain Content**: If you observe a phenomenon but logs don't clearly record the cause, you can write to LOG.md marked "to be verified". Example:
> ```
> 2026-02-04 @user Huawei Mate20
> - Phenomenon: Observed XXX (to be verified: no clear record in logs)
> - Guess: Possibly caused by YYY (needs subsequent evidence)
> ```

**Verification Examples**:

| Your Claim | Log Evidence | Verification Result | Final Write |
|------------|--------------|---------------------|-------------|
| "WebSocket recovers within 30s after disconnect" | Logs show "forced reconnect after 30s" | ⚠️ Uncertain ("recovers" is inference) | "Logs show forced reconnect after 30s timeout" |
| "Default steps is 100" | No schema record in logs | ❌ Reject | Don't write, or mark "to be verified" |
| "ADB returns code 128 when no device" | Log shows `exit code 128` | ✅ Pass | Write with evidence |

**Mandatory Output**:
- [ ] Each claim has clear verification result
- [ ] All ✅ claims have evidence tags
- [ ] All ⚠️ claims marked "to be verified"

---

### Phase 4: Determine Content Destination

| Content Type | Write to File | Example |
|-------------|---------------|---------|
| SOP flow changes | `SKILL.md` | Step order adjustments, new key steps |
| Common failures + solutions | `TROUBLESHOOTING.md` | ADB disconnect handling, input failure workarounds |
| Device/environment differences | `LOG.md` | Xiaomi 14 vs Huawei Mate20 differences |
| Info expired | `LOG.md` | Mark certain solution as deprecated |

**Mandatory Output**:
- [ ] Clear which file each point goes to

---

### Phase 5: Safe Desensitization Check

**Goal**: Ensure all sensitive info replaced with placeholders.

**Replacement Checklist**:
- Real name → `<USER_NAME>` / `<CONTACT_NAME>`
- Real phone → `<USER_PHONE>` / `<PHONE_NUMBER>`
- Real address → `<USER_ADDRESS>` / `<DELIVERY_ADDRESS>`
- API Key/Password → `<API_KEY>` / prompt to read from env var
- Discord ID → `<GUILD_ID>` / `<CHANNEL_ID>`
- Device serial → `<DEVICE_ID>`
- Local paths → `<LOCAL_PATH>`

**Mandatory Output**:
- [ ] Searched full text for real names, phones, addresses, IDs
- [ ] All sensitive info replaced

---

### Phase 6: Write Content

**SKILL.md**: Keep lean, only shortest reliable path
**TROUBLESHOOTING.md**: Failure→Phenomenon→Cause→Solution (executable)
**LOG.md**: Brief entry, format: Date Environment Conclusion Added value

**Mandatory Output**:
- [ ] Files written to specified paths
- [ ] Each key conclusion has evidence tag

---

### Phase 7: Self-Check & Verification (Review Mode)

**Goal**: Act as checker, verify your own content.

**Self-Check Commands**:
```bash
# Check for "Evidence:" tags
grep -n "Evidence:" SKILL.md LOG.md TROUBLESHOOTING.md

# Check for sensitive info residue (exclude timestamp format)
# Check phone numbers (11 digits, exclude datetime format)
grep -E "[0-9]{11}" *.md | grep -v "20[0-9][0-9]-[0-9][0-9]-[0-9][0-9]"
# Check API Key (long alphanumeric, exclude session-id in logs)
grep -oE "[a-zA-Z0-9_-]{32,}" *.md | head -20

# Check for watch keywords
grep -i "usually\|generally\|often\|should\|probably\|default is" *.md
```

> ⚠️ **Note**: grep commands may have false positives (e.g., matching timestamps), need human confirmation whether real sensitive info.

**Self-Check Checklist**:
- [ ] Every technical claim has "Evidence:" tag
- [ ] No sensitive info residue
- [ ] No "watch keywords" (unless clear evidence)
- [ ] All "to be verified" marks intentional

---

### Phase 8: Report to Human (Mandatory)

Explain to your user:
```
While running [skill name] found [problem/difference],
suggest updating [file] to record:
- Environment: [Device/OS/Version]
- Phenomenon: [specific phenomenon]
- Solution: [specific solution]
- Added value: [why this helps colleagues]
- Evidence source: [log file @ timestamp]

May I submit update to original repository?
```

**Mandatory Output**:
- [ ] Report message sent to human
- [ ] Obtained explicit human approval ("can submit")

---

### Phase 9: Local Commit

**Goal**: Create local commit recording changes.

```bash
git add .
git commit -m "[skill name]: brief description of added value"
```

**Commit message standard**:
```
[skill name]: brief description of added value

- Which file modified
- Based on what log evidence (optional)
- What problem solved (optional)
```

**Example**:
```
discord-setup: Add WebSocket disconnect troubleshooting

- Add TROUBLESHOOTING.md chapter: WebSocket 1005/1006 disconnect
- Evidence: gateway.log @ 2026-02-01T23:13:19.476Z
- Explain auto-reconnect mechanism, reduce user panic
```

**Mandatory Output**:
- [ ] Local commit created
- [ ] Commit message follows standard

---

### Phase 10: Push to Remote (Choose by Identity)

#### If Maintainer (write access)

```bash
# Check how many commits local is ahead of remote
git status

# After confirmation, push directly to original repo
git push origin master
```

#### If External Contributor (no write access)

**Step 1: Push to Your Fork**

```bash
# Push to your fork (origin points to your fork)
git push origin master
```

**Step 2: Create Pull Request**

1. Open your Fork page: `https://github.com/<your-username>/openclaw-skills-verified`
2. Click **"Compare & pull request"** button (GitHub auto-suggests)
3. Fill PR description (see template below)
4. Click **"Create pull request"**

**PR Description Template**:

```markdown
## Contribution Content

**Modified Skill**: [skill name]

**Modified Files**:
- `skills/[category]/[skill-name]/SKILL.md` (if any)
- `skills/[category]/[skill-name]/TROUBLESHOOTING.md` (if any)
- `skills/[category]/[skill-name]/LOG.md` (if any)

## Log Evidence

**Key Evidence**:
- File: `~/.openclaw/logs/gateway.err.log`
- Timestamp: `2026-02-04T18:22:11Z`
- Content: [brief error description]

## Added Value

1. [Why this helps colleagues]
2. [Pain point solved]
3. [Difference from existing docs]

## Checklist

- [x] Content based on real execution logs, not imagination
- [x] No real sensitive info (replaced with placeholders)
- [x] Every technical claim has "Evidence:" tag
- [x] Reported to maintainer and got approval

## Environment Info (Optional)

- Device: [e.g., Huawei Mate20]
- System: [e.g., Android 10]
- OpenClaw Version: [e.g., v1.2.3]
```

**Step 3: Wait for Review**

- Maintainer will comment or request changes in PR
- If changes needed, continue editing locally, then `git add / git commit / git push` (auto-updates PR)
- After approval, maintainer will merge to main branch

**Mandatory Output**:
- [ ] Maintainer: pushed to original repo
- [ ] External contributor: pushed to Fork and created PR
- [ ] Confirmed remote shows latest commit

---

## Standard Skill Structure (All Skills Must Follow)

A complete skill should include these files:

| File | Purpose | Must Include |
|------|---------|--------------|
| **SKILL.md** | Main entry, for OpenClaw quick read | One-sentence description, prerequisites, core flow, **reference file guide** |
| **TROUBLESHOOTING.md** | Troubleshooting | Common problems→phenomenon→cause→solution (based on log evidence) |
| **LOG.md** | Real test records | Who ran in what environment, results, added value |

### SKILL.md Must Include Guide Statements

At document end, must guide users to TROUBLESHOOTING.md when problems encountered:

```markdown
## Reference Files
- Troubleshooting: **TROUBLESHOOTING.md**
- Test records: **LOG.md**
```

Or in key reminders:
```markdown
## Key Reminders
- ✅ Normal operations
- ⚠️ Potential pitfalls: **See TROUBLESHOOTING.md**
- 📊 Test records: **See LOG.md**
```

> Why force this guide? Because OpenClaw needs to know where to check when stuck.

---

## Reference Files

| File | Purpose | When to Read |
|------|---------|--------------|
| **TROUBLESHOOTING.md** | Troubleshooting, log location methods, common issues | Encounter problems, don't know how to read logs |
| **LOG.md** | Real contribution cases, test record templates | Want to see how others write, need template reference |

---

**Remember: You're not writing documentation, you're helping colleagues avoid detours. Every record comes from real pitfalls encountered, supported by log evidence.**
