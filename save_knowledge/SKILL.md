---
name: save_knowledge
description: Convert conversation to knowledge and save to Obsidian vault at /home/lr-2002/Documents/default-obsidian/default/. Organizes notes properly using PARA method.
---

<objective>
将对话内容转换为知识，保存到 Obsidian 知识库。提取重要信息，智能分类到正确的位置，保持知识库整洁有序。
</objective>

<vault_structure>
## Obsidian Vault 结构 (PARA 方法)

```
default/
├── 00 Inbox/              # 新想法暂存区
├── 05 Maps/               # 思维导图、概念图
├── 10 Projects/           # 当前项目（有时限）
├── 20 Areas/              # 持续关注的领域（无时限）
├── 30 Resources/          # 资源库
│   ├── 10 Engineering/    # 工程知识
│   ├── Notes/             # 通用笔记
│   └── Sources/           # 信息来源
├── 40 Archives/           # 归档内容
├── 50 Journal/            # 日记
├── 99 System/             # 系统文件（索引、模板）
├── HOME.md                # 主页
└── README.md              # 说明
```

**分类规则：**
- **Project**: 有明确截止日期的项目
- **Area**: 长期持续关注的领域（如"机器人"、"编程"）
- **Resource**: 有参考价值的知识库
- **Archive**: 已完成/过时的内容
</vault_structure>

<note_template>
## 笔记模板

```markdown
---
tags: [knowledge, category/tag]
created: {{created_date}}
updated: {{updated_date}}
source: {{source}}
---

# {{主题名称}}

## 概述
{{简短摘要}}

## 关键概念

### 概念1
- 定义：
- 重要细节：
- 示例：

### 概念2
...

## 核心要点

1. {{要点1}}
2. {{要点2}}
3. {{要点3}}

## 代码示例
```{{语言}}
{{代码}}
```

## 与其他知识的关联
- [[相关笔记链接]]
- [[相关主题]]

## 待补充
- [ ] {{需要补充的信息}}
```

**文件名格式:** `YYYYMMDD_主题名.md`

**时间戳获取方法（必须使用实时时间）：**
```python
from datetime import datetime

# 获取当前时间
now = datetime.now()

# 文件名日期 (创建时)
created_date = now.strftime("%Y-%m-%d")
# 输出: "2026-01-11"

# 更新时间 (每次更新)
updated_date = now.strftime("%Y-%m-%d")
# 输出: "2026-01-11"

# ISO完整时间戳
iso_timestamp = now.isoformat()
# 输出: "2026-01-11T14:30:25"
```

**保存位置:** 根据主题分类到对应文件夹
</note_template>

<extraction_rules>
## 信息提取规则

### 高优先级提取
- **技术概念定义** → Resources/Engineering/
- **项目相关知识** → Projects/
- **可复用的代码/模式** → Resources/Notes/
- **学习笔记** → 20 Areas/ 下的对应领域

### 中优先级提取
- **工具/库的使用方法** → Resources/Engineering/
- **最佳实践** → Resources/Notes/
- **参考资料链接** → Resources/Sources/

### 低优先级/归档
- **临时讨论** → 00 Inbox/ (后续整理)
- **过时内容** → 40 Archives/
</extraction_rules>

<process>
## 保存知识流程

### Step 1: 分析对话内容
1. 阅读完整对话历史
2. 识别主要主题和概念
3. 提取关键技术点、代码、定义
4. 判断与现有笔记的关联

### Step 2: 确定保存位置
根据主题分类：
- 机器人/控制 → `30 Resources/10 Engineering/`
- 编程/代码 → `30 Resources/10 Engineering/` 或 `30 Resources/Notes/`
- 学习笔记 → `20 Areas/` 对应文件夹
- 项目具体 → `10 Projects/`
- 临时想法 → `00 Inbox/`

### Step 3: 提取和总结
**必须包含：**
- 主题名称（标题）
- 核心定义/概念
- 关键要点（3-5条）
- 代码示例（如有）
- 相关主题链接

**可选包含：**
- 使用场景
- 优缺点
- 注意事项

### Step 4: 生成笔记文件
1. 使用模板生成内容
2. 生成文件名：`YYYYMMDD_主题.md`
3. 保存到正确位置
4. 创建双向链接

### Step 5: 更新索引
如果需要，更新：
- `30 Resources/Resources.md` (资源索引)
- `HOME.md` (主页链接)
- 相关主题的链接

### Step 6: 验证
- 文件是否正确保存？
- 链接是否有效？
- 格式是否整洁？
</process>

<file_naming>
## 文件命名规范

| 类型 | 格式 | 示例 |
|------|------|------|
| 技术概念 | `YYYYMMDD_概念名.md` | `20260111_Functional_Programming.md` |
| 教程 | `YYYYMMDD_How_To_主题.md` | `20260111_How_To_Use_CPP_Lambda.md` |
| 项目笔记 | `YYYYMMDD_项目名_备注.md` | `20260111_DataArm_IK_Solver.md` |
| 资源索引 | `序号_主题.md` | `03_CPP_Concurrency_Notes.md` |

**文件名中的日期必须使用实时时间：**
```python
from datetime import datetime

# 获取当前日期用于文件名
filename_date = datetime.now().strftime("%Y%m%d")
# 输出: "20260111" （而非假想的日期）
```

**规则：**
- 使用下划线 `_` 而非空格
- 英文命名（中文可加在后面）
- 保持简短（<50字符）
</file_naming>

<linking_strategy>
## 双向链接策略

### 链接格式
```markdown
[[笔记名]]           # 链接到同目录笔记
[[文件夹/笔记名]]    # 链接到子目录
[[../文件夹/笔记名]] # 链接到上级目录
```

### 链接场景
1. **概念关联**
   - "这与 [[函数式编程]] 相关"
   - "详见 [[逆运动学]]"

2. **主题归类**
   - "属于领域: [[20 Areas/Robotics]]"
   - "标签: #robotics #kinematics"

3. **索引更新**
   - 在 `30 Resources/Resources.md` 添加链接
   - 在 `20 Areas/` 对应领域笔记添加链接
</linking_strategy>

<quality_checklist>
## 质量检查清单

保存前检查：

- [ ] 主题明确，标题清晰
- [ ] 核心概念解释清楚
- [ ] 代码示例语法正确
- [ ] 格式一致（标题层级、列表）
- [ ] 链接存在或已创建
- [ ] 标签合理
- [ ] 放在正确的文件夹
- [ ] 文件名规范
- [ ] 不重复已有笔记（检查后再新建）
</quality_checklist>

<example>
## 保存示例

**对话内容：** 关于函数式编程的讨论

**分析：**
- 主题：函数式编程 (Functional Programming)
- 分类：编程/软件工程
- 关键点：纯函数、不可变性、高阶函数、map/filter/reduce
- 代码：Python 和 C++ 示例
- 相关：DataArm 机器人控制

**保存位置：** `30 Resources/10 Engineering/`

**文件名：** `20260111_Functional_Programming.md`

**内容：**
```markdown
---
tags: [knowledge, programming, fp]
created: 2026-01-11
updated: 2026-01-11
source: conversation/daily_learning
---

# 函数式编程 (Functional Programming)

## 概述
函数式编程是一种编程范式，把计算视为数学函数的求值，避免改变状态和可变数据。

## 核心概念

### 纯函数 (Pure Functions)
- 相同输入，永远相同输出
- 无副作用（不修改外部状态）

### 不可变性 (Immutability)
- 数据创建后永不修改
- 创建新数据而非修改原数据

### 高阶函数 (Higher-Order Functions)
接收函数作为参数，或返回函数的函数。

## map / filter / reduce

| 函数 | 作用 | 示例 |
|------|------|------|
| map | 转换每个元素 | `map(x→x*2, [1,2,3])` |
| filter | 过滤元素 | `filter(x→x>2, [1,2,3])` |
| reduce | 累积计算 | `reduce(+, [1,2,3])` |

## 关键要点

1. 纯函数使代码可测试、可预测
2. 不可变性避免并发 race condition
3. 高阶函数支持函数组合
4. map/filter/reduce 提供声明式数据处理

## 与 DataArm 的关系
- C++ lambda 用于控制回调
- 状态更新管道可用函数组合实现
- [[20260111_Inverse_Kinematics]]

## 标签
#functional-programming #programming-paradigm
```

**索引更新：**
- 在 `30 Resources/Resources.md` 添加链接

**注意：** 文件名和 created/updated 日期必须使用实时时间，不要硬编码！
```python
from datetime import datetime
filename = datetime.now().strftime("%Y%m%d") + "_Functional_Programming.md"
# 正确: "20260111_Functional_Programming.md"
# 错误: "20250111_Functional_Programming.md" (假想时间)
```
</example>

<success_criteria>
技能正常工作当：
- [ ] 能分析对话提取关键信息
- [ ] 能正确分类到对应文件夹
- [ ] 生成符合模板的笔记
- [ ] 文件命名规范
- [ ] 双向链接正确
- [ ] 保持知识库整洁有序
</success_criteria>
