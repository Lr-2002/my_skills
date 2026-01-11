---
name: daily_learning
description: Daily random learning assistant. Randomly picks topics from robot/coding/history/math, teaches with progressive depth, and quizzes on learned material using local cache.
---

<objective>
提供每日随机学习主题，包括机器人、编程、历史、数学。采用渐进式教学深度，记录学习进度，对已学内容进行测验。
</objective>

<cache_location>
~/.claude/cache/daily_learning_progress.json
</cache_location>

<topic_categories>
| 类别 | 示例主题 |
|------|---------|
| robot | 逆运动学、DH参数、PID控制、ROS、传感器融合、力控抓取 |
| coding | 设计模式、算法复杂度、内存管理、并发模型、函数式编程 |
| history | 工业革命、计算机史、图灵冯诺依曼、阿波罗计划、互联网诞生 |
| math | 矩阵变换、李群李代数、卡尔曼滤波、最优化、概率论基础 |
</topic_categories>

<process>
## 启动流程

1. **读取缓存** (`~/.claude/cache/daily_learning_progress.json`)
2. **检查是否有未完成的主题** - 如果用户说"继续"或"上一个"
3. **如果需要新主题** - 从未学习的主题中随机选择
4. **展示主题** - 三层渐进式内容

## 教学层级

**层级1 (基础)**: 什么是这个概念？核心定义
**层级2 (组织)**: 它是如何组织的？结构/原理
**层级3 (关联)**: 与你/你的项目有什么关系？

## 用户指令响应

| 用户输入 | 响应 |
|---------|------|
| "继续", "上一个" | 继续上次未完成的主题 |
| "深入", "更多", "想知道更多" | 展示下一层级的深入内容 |
| "下一个", "next" | 随机选择下一个未学习的主题 |
| "测验", "quiz" | 对已学过的随机主题进行测验 |
| "进度", "进度如何" | 显示已学/未学主题统计 |
| "reset" | 重置学习进度缓存 |

## 缓存格式

```json
{
  "learned_topics": ["robot:inverse_kinematics", "coding:design_patterns"],
  "current_topic": "math:kalman_filter",
  "current_level": 2,
  "learning_history": [
    {
      "topic": "robot:inverse_kinematics",
      "learned_at": "2025-01-11T14:30:25",
      "levels_completed": 3,
      "title": "主题标题"
    }
  ],
  "topic_stats": {
    "robot": 1,
    "coding": 1,
    "history": 0,
    "math": 0
  }
}
```

**注意**：时间戳必须使用 Python 获取实时时间，不要硬编码假想时间！

```python
# 获取实时时间戳的方法
from datetime import datetime

# 方法1: ISO格式（推荐）
timestamp = datetime.now().isoformat()
# 输出: "2025-01-11T14:30:25"

# 方法2: 精确到毫秒
timestamp = datetime.now().strftime("%Y-%m-%dT%H:%M:%S.%f")
# 输出: "2025-01-11T14:30:25.123456"

# 方法3: 仅日期
date_str = datetime.now().strftime("%Y-%m-%d")
# 输出: "2025-01-11"
```

## 主题内容模板

每个主题应包含：

```yaml
robot:
  inverse_kinematics:
    level1: |
      **逆运动学 (Inverse Kinematics)** 是根据末端执行器的期望位置和姿态，
      计算出机器人各关节角度的数学过程。
      - 输入：末端位置 (x, y, z) + 姿态
      - 输出：关节角度 [θ1, θ2, ..., θn]
    level2: |
      **解析法 vs 数值法**

      1. **解析法 (Geometric/Analytical)**
         - 使用三角函数和几何关系
         - 速度快，但只适用于特定机构
         - 6DOF机械臂常用

      2. **数值法 (Numerical - Jacobian)**
         - 迭代求解：Δθ = J⁻¹ * Δx
         - 通用性强，速度较慢
         - 适用于冗余度机器人

      **DH参数 (Denavit-Hartenberg)**
      - 每个关节4个参数：θ, d, a, α
      - 建立连杆坐标系的标准方法
    level3: |
      **与 DataArm 的关系**

      DataArm 的 8DOF 机械臂需要：
      - 冗余度解析法避免奇异位形
      - 数值法配合阻尼最小二乘 (DLS)
      - 任务空间 → 关节空间的实时映射

      ```cpp
      // 伪代码示例
      VectorXd ik_solver::solve(Vector3d target_pos) {
          // 初始猜测
          VectorXd theta = current_positions_;
          for (int i = 0; i < max_iterations; ++i) {
              Vector3d current_pos = forward_kinematics(theta);
              Vector3d error = target_pos - current_pos;
              if (error.norm() < tolerance) break;
              // Jacobian 迭代
              MatrixXd J = compute_jacobian(theta);
              theta += J.pinv() * error;
          }
          return theta;
      }
      ```

learning_level2:
  1. 解释 DH 参数的物理意义
  2. 为什么 6DOF 机械臂可以用解析法？
  3. 数值法的迭代收敛条件是什么？

learning_level3:
  1. DataArm 如何处理奇异位形？
  2. 冗余度机器人有什么优势？
  3. 阻尼最小二乘的作用是什么？
</process>

<success_criteria>
技能正常工作当：
- 能读取和写入缓存文件
- 能从4个类别中随机选择未学习的主题
- 能渐进式展示3个层级的教学内容
- 能根据用户指令（继续/深入/下一个/测验）正确响应
- 能追踪和显示学习进度
</success_criteria>
