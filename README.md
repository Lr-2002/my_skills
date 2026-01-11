# My Claude Code Skills

Personal collection of Claude Code skills for robotics and development workflows.

## Skills

### daily_learning
Daily random learning assistant. Picks topics from robot/coding/history/math categories with progressive teaching depth.

**Commands:**
- `/daily_learning` - Start daily learning session
- `"继续"` / `"深入"` - Continue to next level
- `"下一个"` / `"next"` - New topic
- `"测验"` / `"quiz"` - Test your knowledge

### save_knowledge
Convert conversation to Obsidian knowledge notes. Organizes using PARA method.

**Usage:**
1. After meaningful discussion, call `save_knowledge`
2. Skill extracts key concepts and saves to Obsidian vault

### update_my_skill
Update skills from this GitHub repository.

**Commands:**
- `"更新"` / `"update"` - Pull latest changes
- `"状态"` / `"status"` - Show sync status

## Installation

### Quick Install

```bash
# Clone to your Claude skills directory
cd ~/.claude/skills
git clone https://github.com/Lr-2002/my_skills.git my_skills

# Or use the install script
curl -sL https://raw.githubusercontent.com/Lr-2002/my_skills/main/install.sh | bash
```

### Manual Install

```bash
# Backup existing skills
cp -r ~/.claude/skills ~/.claude/skills.backup

# Pull latest
cd ~/.claude/skills
git pull origin main
```

## Adding New Skills

1. Create folder: `SKILL_NAME/SKILL.md`
2. Add skill metadata:

```markdown
---
name: skill_name
description: Brief description
---

<objective>
What the skill does
</objective>

<process>
## Step-by-step process
</process>

<success_criteria>
- [ ] Criterion 1
- [ ] Criterion 2
</success_criteria>
```

3. Test the skill
4. Commit and push

## Updating Skills

Just call the skill:
```
/update_my_skill
```

Or manually:

```bash
cd ~/.claude/skills/my_skills
git pull
```

## Structure

```
my_skills/
├── README.md
├── install.sh
├── daily_learning/
│   └── SKILL.md
├── save_knowledge/
│   └── SKILL.md
└── update_my_skill/
    └── SKILL.md
```

## License

MIT
