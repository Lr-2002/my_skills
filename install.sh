#!/bin/bash
#
# My Skills Installation Script
# Installs Claude Code skills from GitHub repository
#

set -e

REPO_URL="https://github.com/Lr-2002/my_skills.git"
SKILLS_DIR="${HOME}/.claude/skills"
REPO_DIR="${SKILLS_DIR}/my_skills"
BRANCH="main"

echo "============================================"
echo "  My Claude Code Skills Installer"
echo "============================================"
echo ""

# Check if git is available
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed"
    exit 1
fi

# Create skills directory if not exists
if [ ! -d "${SKILLS_DIR}" ]; then
    echo "[1/4] Creating skills directory..."
    mkdir -p "${SKILLS_DIR}"
fi

# Check if repo already exists
if [ -d "${REPO_DIR}/.git" ]; then
    echo "[1/4] Repository exists, updating..."
    cd "${REPO_DIR}"
    echo "    Pulling latest changes..."
    git checkout ${BRANCH} 2>/dev/null || git checkout main 2>/dev/null || true
    git pull origin ${BRANCH} 2>/dev/null || git pull origin main 2>/dev/null || true
else
    echo "[1/4] Cloning repository..."
    git clone "${REPO_URL}" "${REPO_DIR}" -b ${BRANCH}
fi

echo ""
echo "[2/4] Syncing skill files..."

# Sync each skill folder
for skill_dir in "${REPO_DIR}"/*/; do
    if [ -d "${skill_dir}" ] && [ -f "${skill_dir}/SKILL.md" ]; then
        skill_name=$(basename "${skill_dir}")
        echo "    - ${skill_name}"
        # Copy SKILL.md to parent skills dir if needed
        # This is handled by Claude Code automatically
    fi
done

echo ""
echo "[3/4] Verifying installation..."

# List installed skills
echo "    Installed skills:"
for skill_dir in "${REPO_DIR}"/*/; do
    if [ -d "${skill_dir}" ] && [ -f "${skill_dir}/SKILL.md" ]; then
        skill_name=$(basename "${skill_dir}")
        echo "      ✓ ${skill_name}"
    fi
done

echo ""
echo "[4/4] Done!"
echo ""

echo "============================================"
echo "  Skills installed successfully!"
echo "============================================"
echo ""
echo "To use a skill, call it in Claude Code:"
echo "  /skill_name"
echo ""
echo "To update skills later:"
echo "  cd ${REPO_DIR} && git pull"
echo ""
echo "Or use the update_my_skill skill:"
echo "  /update_my_skill"
echo ""
