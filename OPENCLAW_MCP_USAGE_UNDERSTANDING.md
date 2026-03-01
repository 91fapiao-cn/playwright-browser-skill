# OpenClaw MCP 技能使用方式理解

**日期**: 2026-03-01  
**关键发现**: MCP 技能的调用方式  
**状态**: ✅ 已理解

---

## 🎯 关键发现

### MCP 技能注册成功

- ✅ 技能状态：**Ready**（已就绪）
- ✅ MCP 服务器：已注册
- ✅ 工具数量：101 个
- ✅ 配置正确：mcp.json 和 SKILL.md 都正确

### 问题不是"未注册"

之前理解有误，问题不是 MCP 未注册，而是：
- **不知道如何调用 MCP 技能**
- OpenClaw 可能还没有暴露直接调用 MCP 工具的接口

---

## 🔍 OpenClaw 的工具调用方式

### 当前可用的工具类型

根据你的描述，OpenClaw 目前可以直接调用：
- `exec` - 执行命令
- `read` - 读取文件
- 其他内置工具

### MCP 技能的调用方式

**关键点**: MCP 技能不是像 `exec`、`read` 那样直接调用工具名称。

可能的调用方式：

#### 方式 1：通过自然语言描述（推荐）

OpenClaw 的 AI 应该能理解自然语言请求并自动选择合适的 MCP 工具：

```
用户：帮我访问 example.com 并获取页面标题
OpenClaw AI：理解需求 → 选择 browser_launch 和 browser_goto → 调用 MCP 工具
```

#### 方式 2：通过技能名称引导

在对话中明确提到技能名称：

```
用户：使用 Playwright Browser Skill 访问 example.com
用户：用浏览器技能帮我截图
用户：请调用 playwright-browser 技能启动浏览器
```

#### 方式 3：通过 SKILL.md 的描述

SKILL.md 中的描述和示例应该帮助 OpenClaw AI 理解何时使用这个技能：

```yaml
---
name: playwright-browser
description: 浏览器自动化技能，支持101个工具：页面导航、元素交互、内容提取、截图、网络控制、性能监控等
---

# 使用示例
- "帮我访问 example.com 并获取页面标题"
- "打开百度搜索 'OpenClaw'"
- "访问 github.com 并截图"
```

---

## 📋 OpenClaw MCP 架构理解

### 工具调用流程

```
用户输入
    ↓
OpenClaw AI 理解意图
    ↓
选择合适的工具/技能
    ↓
如果是 MCP 技能：
    ↓
通过 MCP 协议调用工具
    ↓
MCP 服务器执行
    ↓
返回结果给 OpenClaw
    ↓
OpenClaw 展示给用户
```

### MCP 技能 vs 内置工具

| 特性 | 内置工具 (exec, read) | MCP 技能 (playwright-browser) |
|------|---------------------|-------------------------------|
| 调用方式 | 直接调用工具名 | 通过 AI 理解和路由 |
| 注册方式 | 内置在 OpenClaw | 通过 mcp.json 注册 |
| 工具发现 | 固定的工具列表 | 动态从 MCP 服务器获取 |
| 使用场景 | 系统级操作 | 专业领域任务 |

---

## 🎓 正确的使用方式

### 1. 自然语言描述任务

**推荐方式**：直接描述你想做什么，让 OpenClaw AI 自动选择工具。

```
✅ 好的示例：
- "帮我访问 example.com 并获取页面内容"
- "打开浏览器访问百度"
- "截取 github.com 首页的截图"
- "从 news.ycombinator.com 提取今天的热门文章"

❌ 不好的示例：
- "调用 browser_launch 工具"（太技术化）
- "执行 playwright-browser.browser_goto"（不是正确的调用格式）
```

### 2. 提及技能名称

如果 AI 没有自动选择 MCP 技能，可以明确提及：

```
✅ 好的示例：
- "使用 Playwright Browser Skill 访问 example.com"
- "用浏览器自动化技能帮我截图"
- "请使用 playwright-browser 技能"

❌ 不好的示例：
- "使用 mcp 工具"（太模糊）
- "调用 playwright-browser 服务器"（不是用户语言）
```

### 3. 描述具体场景

提供足够的上下文，帮助 AI 理解你的需求：

```
✅ 好的示例：
- "我需要测试一个网站的登录功能，帮我打开浏览器并填写表单"
- "帮我从这个电商网站提取所有商品的价格"
- "我想监控这个网页的变化，每隔5分钟检查一次"

❌ 不好的示例：
- "打开浏览器"（太简单，可能不会触发 MCP 技能）
- "访问网页"（太模糊）
```

---

## 🔧 OpenClaw 可能的限制

### 当前版本可能的限制

根据你的描述，OpenClaw 当前版本可能：

1. **没有直接的 MCP 工具调用界面**
   - 不能像 `exec("command")` 那样直接调用 `browser_launch()`
   - 需要通过 AI 理解和路由

2. **MCP 技能是"被动"的**
   - 技能注册后处于 Ready 状态
   - 等待 OpenClaw AI 调用
   - 不是用户直接可见的工具列表

3. **依赖 AI 的理解能力**
   - OpenClaw AI 需要理解用户意图
   - 然后决定是否使用 MCP 技能
   - 可能需要明确的提示词

---

## 💡 测试建议

### 测试 MCP 技能是否可用

尝试以下对话，看 OpenClaw 是否会调用 Playwright Browser Skill：

#### 测试 1：简单的浏览器操作
```
用户：帮我打开浏览器并访问 example.com
预期：OpenClaw 应该调用 browser_launch 和 browser_goto
```

#### 测试 2：明确提及技能
```
用户：使用 Playwright Browser Skill 访问 example.com 并获取页面标题
预期：OpenClaw 应该识别技能名称并调用相应工具
```

#### 测试 3：复杂任务
```
用户：帮我从 news.ycombinator.com 提取前10条新闻的标题和链接
预期：OpenClaw 应该调用多个浏览器工具完成任务
```

#### 测试 4：截图任务
```
用户：帮我截取 github.com 首页的截图并保存
预期：OpenClaw 应该调用 browser_screenshot
```

### 观察 OpenClaw 的响应

注意观察：
- OpenClaw 是否提示"正在使用 Playwright Browser Skill"
- 是否有工具调用的日志或提示
- 是否真的启动了浏览器
- 是否返回了预期的结果

---

## 📊 SKILL.md 的作用

### SKILL.md 不仅仅是配置

SKILL.md 的内容对 OpenClaw AI 很重要：

```yaml
---
name: playwright-browser
description: 浏览器自动化技能，支持101个工具：页面导航、元素交互、内容提取、截图、网络控制、性能监控等
---

# Playwright Browser Skill - 浏览器自动化技能

## 🚀 快速开始

### 如何使用这个技能

**基本用法：**
当你需要访问网页、提取信息或控制浏览器时，直接告诉我你的需求即可。

**示例对话：**
- "帮我访问 example.com 并获取页面标题"
- "打开百度搜索 'OpenClaw'"
- "访问 github.com 并截图"
```

**作用**：
1. 告诉 OpenClaw AI 这个技能能做什么
2. 提供使用示例，帮助 AI 理解何时使用
3. 作为 AI 的"提示词"或"上下文"

---

## 🎯 下一步行动

### 1. 测试自然语言调用

在 OpenClaw 中尝试：
```
帮我访问 example.com 并获取页面标题
```

### 2. 观察 OpenClaw 的行为

注意：
- 是否识别到需要使用浏览器
- 是否调用了 MCP 技能
- 是否有任何错误或提示

### 3. 调整提示词

如果不工作，尝试更明确的提示：
```
使用 Playwright Browser Skill 访问 example.com
```

### 4. 查看 OpenClaw 文档

查找：
- MCP 技能的使用说明
- 如何调用自定义技能
- 是否有特殊的调用语法

---

## 📝 总结

### 关键理解

1. **MCP 技能已注册成功**
   - 状态：Ready
   - 配置：正确
   - 服务器：运行中

2. **调用方式不同于内置工具**
   - 不是直接调用工具名
   - 通过自然语言描述任务
   - 依赖 OpenClaw AI 的理解和路由

3. **SKILL.md 很重要**
   - 提供技能描述
   - 提供使用示例
   - 帮助 AI 理解何时使用

4. **需要测试验证**
   - 尝试不同的提示词
   - 观察 OpenClaw 的响应
   - 找到最佳的调用方式

### 可能的情况

#### 情况 A：OpenClaw 支持 MCP 技能调用
- 使用自然语言描述任务
- OpenClaw AI 自动选择并调用 MCP 工具
- 一切正常工作

#### 情况 B：OpenClaw 需要特殊语法
- 可能需要特定的命令格式
- 例如：`@playwright-browser browser_launch`
- 需要查看 OpenClaw 文档

#### 情况 C：OpenClaw 当前版本不完全支持
- MCP 技能可以注册
- 但 AI 还不能自动调用
- 需要等待 OpenClaw 更新

---

## 🎉 恭喜

你已经成功：
- ✅ 部署了 Playwright Browser Skill
- ✅ 配置了 MCP 服务器
- ✅ 技能状态为 Ready
- ✅ 理解了 MCP 技能的工作方式

现在只需要找到正确的调用方式，就可以使用这 101 个强大的浏览器自动化工具了！

**建议**: 在 OpenClaw 中尝试自然语言描述任务，看看 AI 是否会自动调用 Playwright Browser Skill。
