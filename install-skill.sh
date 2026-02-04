#!/bin/bash
# install-skill.sh - One-command install for OpenClaw skills with i18n support
# Usage: ./install-skill.sh <category/skill-name> [language] [target-dir]
#   language: zh, en, or auto (default: auto-detect from system)

set -e

SKILL_PATH="$1"
LANG_PREF="${2:-auto}"
TARGET_DIR="${3:-$HOME/clawd/skills}"

if [ -z "$SKILL_PATH" ]; then
    echo "Usage: $0 <category/skill-name> [language] [target-dir]"
    echo ""
    echo "Examples:"
    echo "  $0 productivity/food-ordering      # Auto-detect language"
    echo "  $0 productivity/food-ordering zh   # Force Chinese version"
    echo "  $0 productivity/food-ordering en   # Force English version"
    echo ""
    echo "Language options:"
    echo "  zh   - Chinese version (SKILL.zh.md)"
    echo "  en   - English version (SKILL.en.md)"
    echo "  auto - Auto-detect from system locale (default)"
    exit 1
fi

# Detect system language if auto
if [ "$LANG_PREF" = "auto" ]; then
    SYS_LANG=$(echo "${LANG:-en}" | cut -d'_' -f1 | cut -d'.' -f1)
    if [ "$SYS_LANG" = "zh" ] || [ "$SYS_LANG" = "CN" ]; then
        LANG_PREF="zh"
    else
        LANG_PREF="en"
    fi
fi

REPO_URL="https://github.com/vbgate/openclaw-skills-verified"
TMP_DIR=$(mktemp -d)

echo "Installing skill: $SKILL_PATH"
echo "Language preference: $LANG_PREF"

# Use sparse-checkout for minimal download
git clone --filter=blob:none --no-checkout "$REPO_URL" "$TMP_DIR" > /dev/null 2>&1
cd "$TMP_DIR"
git sparse-checkout init --cone > /dev/null 2>&1
git sparse-checkout set "skills/$SKILL_PATH" > /dev/null 2>&1
git checkout > /dev/null 2>&1

# Prepare target path
SKILL_NAME=$(basename "$SKILL_PATH")
DEST_DIR="$TARGET_DIR/$SKILL_NAME"
mkdir -p "$DEST_DIR"

SOURCE_DIR="$TMP_DIR/skills/$SKILL_PATH"

# Function to copy with language preference
copy_with_lang() {
    local base_name="$1"
    
    # Try preferred language version first
    if [ -f "$SOURCE_DIR/${base_name}.${LANG_PREF}.md" ]; then
        cp "$SOURCE_DIR/${base_name}.${LANG_PREF}.md" "$DEST_DIR/${base_name}.md"
        echo "  ✅ Using ${base_name}.${LANG_PREF}.md"
        return 0
    fi
    
    # Fallback to default
    if [ -f "$SOURCE_DIR/${base_name}.md" ]; then
        cp "$SOURCE_DIR/${base_name}.md" "$DEST_DIR/${base_name}.md"
        echo "  ✅ Using ${base_name}.md (fallback)"
        return 0
    fi
    
    return 1
}

# Copy files with language preference
copy_with_lang "SKILL" || { echo "  ⚠️  SKILL.md not found"; }

# For troubleshooting and log, try language version first, fallback to default
if [ -f "$SOURCE_DIR/TROUBLESHOOTING.${LANG_PREF}.md" ]; then
    cp "$SOURCE_DIR/TROUBLESHOOTING.${LANG_PREF}.md" "$DEST_DIR/TROUBLESHOOTING.md"
    echo "  ✅ Using TROUBLESHOOTING.${LANG_PREF}.md"
elif [ -f "$SOURCE_DIR/TROUBLESHOOTING.md" ]; then
    cp "$SOURCE_DIR/TROUBLESHOOTING.md" "$DEST_DIR/TROUBLESHOOTING.md"
    echo "  ✅ Using TROUBLESHOOTING.md"
fi

if [ -f "$SOURCE_DIR/LOG.${LANG_PREF}.md" ]; then
    cp "$SOURCE_DIR/LOG.${LANG_PREF}.md" "$DEST_DIR/LOG.md"
    echo "  ✅ Using LOG.${LANG_PREF}.md"
elif [ -f "$SOURCE_DIR/LOG.md" ]; then
    cp "$SOURCE_DIR/LOG.md" "$DEST_DIR/LOG.md"
    echo "  ✅ Using LOG.md"
fi

# Cleanup
rm -rf "$TMP_DIR"

echo ""
echo "✅ Installed to: $DEST_DIR"
echo ""
echo "Quick start:"
echo "  cat $DEST_DIR/SKILL.md"
