---
name: save_thread
description: Fetch URL content and save to Obsidian knowledge vault
---

<objective>
用户提供一个链接（网页、文档、GitHub等），技能会抓取链接内容，提取关键信息，并保存到 Obsidian 知识库。
</objective>

<tools>
## 可用工具

1. **WebFetch** - 获取网页内容
   - 输入：URL
   - 输出：页面文本内容（AI处理后）

2. **Read** - 读取本地文件
3. **Write** - 创建/修改笔记文件
4. **Edit** - 更新索引文件

5. **Glob** - 检查文件是否存在
6. **Bash** - 执行 git 命令（可选）
</tools>

<process>
## 工作流程

### Step 1: 验证链接
- 检查链接格式是否有效
- 识别链接类型（GitHub, 文档, 论文, 博客等）

### Step 2: 获取内容
```python
# 使用 WebFetch 获取页面
url = "用户提供的链接"
result = WebFetch(url=url, prompt="提取页面中的关键信息：标题、核心概念、技术细节、代码示例")
```

### 特殊处理：X/Twitter
X (Twitter) 需要 JavaScript 渲染，无法直接抓取。使用 jina.ai 作为代理：

**方法**: 将 URL 前缀改为 `https://r.jina.ai/`

```python
# X/Twitter 链接处理
if "x.com" in url or "twitter.com" in url:
    # 原始链接: https://x.com/username/status/123456789
    # 转换后:   https://r.jina.ai/https://x.com/username/status/123456789
    fetch_url = "https://r.jina.ai/" + url
    result = WebFetch(url=fetch_url, prompt="提取推文内容、作者、关键观点、技术细节")

# 记录获取方式
metadata["fetch_method"] = "jina.ai"
```

**支持的 jina.ai 格式**:
- `https://r.jina.ai/https://x.com/...` - Twitter/X
- `https://r.jina.ai/http://...` - 普通网页
- `https://r.jina.ai/https://github.com/...` - GitHub

### Step 3: 分析和提取
从获取的内容中提取：
- 标题（从页面或URL推断）
- 核心概念/定义
- 技术细节
- 代码示例（如果有）
- 重要参考链接
- 标签/分类

### Step 4: 保存到 Obsidian
- 生成文件名：`YYYYMMDD_主题名.md`
- 位置：`30 Resources/10 Engineering/` 或对应分类
- 使用 save_knowledge 的模板格式

### Step 5: 更新索引
- 在 `30 Resources/Resources.md` 添加链接
- 添加双向链接（如果相关笔记存在）

## 链接类型处理

| 类型 | 示例 | 保存位置 |
|------|------|---------|
| GitHub README | github.com/xxx/repo | 30 Resources/10 Engineering/ |
| 技术文档 | docs.example.com/... | 30 Resources/10 Engineering/ |
| 论文 | arxiv.org/papers/... | 30 Resources/30 Resources/ |
| 博客 | medium.com/... | 20 Areas/ 对应领域 |
| 教程 | guide.example.com | 30 Resources/10 Engineering/ |
| 其他 | - | 00 Inbox/ (待整理) |

## 链接分类规则

```python
def get_save_location(url: str) -> str:
    """根据URL确定保存位置"""
    if "github.com" in url and "blob" in url:
        return "30 Resources/10 Engineering/"
    elif "arxiv.org" in url:
        return "30 Resources/30 Resources/"
    elif "docs." in url or "documentation" in url:
        return "30 Resources/10 Engineering/"
    elif "medium.com" in url or "blog" in url:
        return "20 Areas/"
    else:
        return "00 Inbox/"
```

## 文件名生成

```python
from datetime import datetime

def generate_filename(url: str, title: str = None) -> str:
    """生成 Obsidian 文件名"""
    date = datetime.now().strftime("%Y%m%d")

    # 从URL提取项目名
    if "github.com" in url:
        parts = url.split("/")
        repo_idx = parts.index("github.com") + 1
        repo_name = parts[repo_idx + 1]
        return f"{date}_{repo_name}.md"

    # 使用标题
    if title:
        # 清理标题，只保留字母数字
        clean_title = "".join(c for c in title[:30] if c.isalnum())
        return f"{date}_{clean_title}.md"

    # 默认
    return f"{date}_web_note.md"
```

## 笔记模板

```markdown
---
tags: [web, source/type]
created: {{created_date}}
updated: {{updated_date}}
source: {{url}}
source_type: {{github|docs|blog|paper|other}}
---

# {{标题}}

## 来源
- URL: [{{域名}}]({{完整URL}})
- 访问时间: {{时间戳}}

## 概述
{{页面摘要}}

## 核心内容

### {{章节1}}
- 要点1
- 要点2

### {{章节2}}
...

## 关键概念
- **概念1**: 定义
- **概念2**: 定义

## 代码示例
```{{语言}}
{{代码}}
```

## 重要引用
> 引用内容

## 相关资源
- [相关链接1](url)
- [相关链接2](url)

## 待整理
- [ ] 验证信息准确性
- [ ] 添加内部链接
- [ ] 补充相关笔记

## 标签
#{{标签1}} #{{标签2}}
```

## 用户指令

| 用户输入 | 响应 |
|---------|------|
| `save_thread https://github.com/...` | 抓取并保存 |
| `保存 https://...` | 同上 |
| `"提取这个链接"` | 同上 |
| `"保存这个网页"` | 同上 |

## 错误处理

| 错误 | 处理 |
|------|------|
| 链接无效/404 | 提示用户检查链接 |
| 访问被拒绝 | 尝试其他方法或提示 |
| 内容为空 | 提示用户手动复制 |
| 网络错误 | 显示错误，建议重试 |
</process>

<example>
## 示例对话

**用户:** `save_thread https://github.com/microsoft/TypeScript`

**助手:**
```
正在获取: https://github.com/microsoft/TypeScript
  类型: GitHub Repository
  标题: TypeScript

提取内容中...
✓ 完成!

保存位置: 30 Resources/10 Engineering/20260111_TypeScript.md

内容预览:
---
tags: [web, github, typescript]
created: 2026-01-11
source: https://github.com/microsoft/TypeScript
source_type: github
---

# TypeScript

## 来源
- URL: GitHub
- 访问时间: 2026-01-11T20:30:00

## 概述
TypeScript 是 JavaScript 的超集，添加了静态类型支持。

## 核心内容

### 主要特性
- 静态类型检查
- 面向对象特性
- 编译到纯 JavaScript

### ...
```

**用户:** `save_thread https://arxiv.org/abs/2304.03443`

**助手:**
```
正在获取: https://arxiv.org/abs/2304.03443
  类型: Academic Paper
  标题: Attention Is All You Need

保存位置: 30 Resources/30 Resources/20260111_Attention_Is_All_You_Need.md

已保存到论文库！
```

## 注意事项

1. **尊重版权** - 只提取摘要和关键信息，不复制全文
2. **验证信息** - AI处理可能有不准确之处
3. **添加时间戳** - 使用实时时间
4. **去重** - 检查是否已存在相同笔记
5. **提取代码** - 保留有用的代码示例
</example>

<success_criteria>
- [ ] 能识别链接类型
- [ ] 能获取页面内容
- [ ] 能提取关键信息
- [ ] 能生成规范文件名
- [ ] 能保存到正确位置
- [ ] 能更新索引
- [ ] 能处理常见错误
</success_criteria>
