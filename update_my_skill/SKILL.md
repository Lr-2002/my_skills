---
name: update_my_skill
description: Pull and sync skills from GitHub repository
---

<objective>
从 GitHub 仓库拉取最新技能，保持本地技能与远程同步。提供更新状态查询和手动更新功能。
</objective>

<paths>
REPO_DIR: "${HOME}/.claude/skills/my_skills"
BACKUP_DIR: "${HOME}/.claude/skills.backup"
</paths>

<process>
## 启动检查

1. **检查仓库是否存在**
   - 如果 `REPO_DIR` 不存在，提示用户先运行 install.sh
   - 如果存在，继续执行

2. **获取远程状态**
   ```bash
   cd REPO_DIR
   git remote show origin --porcelain
   git rev-parse HEAD
   git rev-parse origin/BRANCH
   ```

## 用户指令响应

| 用户输入 | 响应 |
|---------|------|
| `"更新"`, `"update"` | 执行 git pull |
| `"状态"`, `"status"` | 显示同步状态 |
| `"回滚"`, `"rollback"` | 回滚到上一个版本 |
| `"备份"`, `"backup"` | 创建备份 |

## 更新流程

### Step 1: 备份当前状态
```bash
# 创建带时间戳的备份
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
cp -r REPO_DIR BACKUP_DIR/TIMESTAMP
```

### Step 2: 获取远程更新
```bash
cd REPO_DIR
git fetch origin
git pull origin BRANCH
```

### Step 3: 显示更新内容
- 列出新增/修改的文件
- 显示最新提交信息
- 提示需要重启/重载

### Step 4: 验证安装
```bash
# 检查 SKILL.md 文件完整性
for skill in REPO_DIR/*/; do
    if [ -f "$skill/SKILL.md" ]; then
        echo "✓ $(basename $skill)"
    else
        echo "✗ $(basename $skill) - missing SKILL.md"
    fi
done
```

## 状态显示格式

```
┌─────────────────────────────────────────┐
│  Skills 同步状态                         │
├─────────────────────────────────────────┤
│  本地版本: 231a90d                       │
│  远程版本: 231a90d                       │
│  状态: 已同步                            │
│                                         │
│  最近更新: 2026-01-11 20:30:00           │
│  远程仓库: Lr-2002/my_skills             │
│                                         │
│  技能列表:                               │
│  ✓ daily_learning                       │
│  ✓ save_knowledge                       │
│  ✓ update_my_skill                      │
└─────────────────────────────────────────┘
```

## 错误处理

| 错误 | 处理方式 |
|------|---------|
| 仓库不存在 | 提示运行 install.sh |
| 网络错误 | 显示错误信息，建议重试 |
| 合并冲突 | 提示手动解决 |
| 权限错误 | 检查 git 配置 |

## 成功标准

- [ ] 能检测仓库是否存在
- [ ] 能显示同步状态
- [ ] 能执行 git pull 更新
- [ ] 能创建备份
- [ ] 能处理常见错误
- [ ] 输出清晰的状态信息

## 示例对话

**用户:** `/update_my_skill`

**助手:**
```
正在检查 skills 仓库状态...
  仓库位置: /home/lr-2002/.claude/skills/my_skills
  当前分支: main
  本地版本: 231a90d
  远程版本: 231a90d
  状态: 已同步 ✓

可用技能:
  ✓ daily_learning
  ✓ save_knowledge
  ✓ update_my_skill

所有技能已是最新版本！
```

**用户:** `"更新"`

**助手:**
```
正在更新 skills...
  备份到: /home/lr-2002/.claude/skills.backup/20260111_203000
  执行 git pull...
  ✓ 更新完成!

更新内容:
  - 231a90d Initial commit: Claude Code skills

请重新启动 Claude Code 或加载新技能！
```
