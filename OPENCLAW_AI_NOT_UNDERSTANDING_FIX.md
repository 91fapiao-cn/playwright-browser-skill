# OpenClaw AI 不知道如何使用 MCP 工具 - 解决方案

## 🔍 问题分析

OpenClaw 的 AI 不知道如何调用 MCP 工具，原因是：

1. **SKILL.md 太长** - 文档有几千行，AI 可能无法快速找到关键信息
2. **缺少明确的调用指南** - 没有在文档开头告诉 AI 如何调用工具
3. **示例不够清晰** - AI 需要更直接的"用户说X → 调用工具Y"的映射

## ✅ 解决方案

### 方案 1：重新部署技能（推荐）

我已经更新了 `skill-package/skills/SKILL.md`，在文档开头添加了 **AI 调用指南**。

#### 步骤：

1. **重新部署技能**
   ```powershell
   cd playwright-browser-skill
   .\auto-deploy-en.ps1
   ```

2. **重启 OpenClaw Gateway**
   - 关闭 OpenClaw
   - 重新启动 OpenClaw

3. **测试**
   在 OpenClaw 中说：
   ```
   "访问 example.com 并获取页面标题"
   ```

---

### 方案 2：手动更新 SKILL.md（如果方案1不行）

如果重新部署后仍然不行，手动编辑已部署的 SKILL.md：

#### 步骤：

1. **打开文件**
   ```
   C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\SKILL.md
   ```

2. **在文档开头（frontmatter 之后）添加以下内容**：

```markdown
## ⚡ AI 调用指南（OpenClaw 必读）

### 如何调用 MCP 工具

当用户请求浏览器操作时，你需要通过 MCP 协议调用相应的工具。以下是调用方法：

#### 基本调用流程

1. **启动浏览器** → 调用 `browser_launch`
2. **访问网页** → 调用 `browser_goto`
3. **执行操作** → 调用相应工具（点击、填写、提取等）
4. **关闭浏览器** → 调用 `browser_close`

#### 常用工具快速参考

| 用户需求 | 调用工具 | 参数示例 |
|---------|---------|---------|
| "访问网站" | `browser_goto` | `{ "url": "https://example.com" }` |
| "点击按钮" | `browser_click` | `{ "selector": "button.submit" }` |
| "填写表单" | `browser_fill` | `{ "selector": "#username", "value": "admin" }` |
| "获取标题" | `browser_get_title` | `{}` |
| "截图" | `browser_screenshot` | `{ "path": "screenshot.png", "fullPage": true }` |
| "获取文本" | `browser_get_text` | `{ "selector": "h1" }` |
| "等待元素" | `browser_wait_for_selector` | `{ "selector": ".content" }` |

#### 完整示例：访问网页并获取标题

```
用户："访问 example.com 并获取页面标题"

你应该调用：
1. browser_launch({ "headless": false })
2. browser_goto({ "url": "https://example.com" })
3. browser_get_title({})
4. browser_close({})
```

#### 完整示例：搜索操作

```
用户："在百度搜索 OpenClaw"

你应该调用：
1. browser_launch({})
2. browser_goto({ "url": "https://www.baidu.com" })
3. browser_fill({ "selector": "#kw", "value": "OpenClaw" })
4. browser_click({ "selector": "#su" })
5. browser_wait_for_selector({ "selector": ".result" })
6. browser_close({})
```

#### 重要提示

- ✅ **必须先调用 browser_launch** - 任何操作前都要先启动浏览器
- ✅ **使用完毕调用 browser_close** - 释放资源
- ✅ **等待元素加载** - 使用 browser_wait_for_selector 确保元素存在
- ✅ **选择器语法** - 使用 CSS 选择器（#id, .class, button[type="submit"]）

---
```

3. **保存文件**

4. **重启 OpenClaw**

---

### 方案 3：创建简化版 SKILL.md（终极方案）

如果上述方案都不行，可能是 SKILL.md 太长导致 AI 无法处理。

#### 步骤：

1. **备份原文件**
   ```powershell
   Copy-Item "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\SKILL.md" `
             "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\SKILL.md.backup"
   ```

2. **创建简化版 SKILL.md**
   
   只保留：
   - Frontmatter（YAML 头部）
   - AI 调用指南
   - 常用工具列表（前20个）
   - 完整示例

3. **重启 OpenClaw**

---

## 🧪 测试方法

### 测试 1：简单访问

在 OpenClaw 中说：
```
"访问 example.com 并获取页面标题"
```

**期望结果：**
- OpenClaw 调用 browser_launch
- OpenClaw 调用 browser_goto
- OpenClaw 调用 browser_get_title
- OpenClaw 调用 browser_close
- 返回页面标题

---

### 测试 2：点击操作

在 OpenClaw 中说：
```
"访问 baidu.com 并点击搜索按钮"
```

**期望结果：**
- OpenClaw 调用 browser_launch
- OpenClaw 调用 browser_goto
- OpenClaw 调用 browser_click
- OpenClaw 调用 browser_close

---

### 测试 3：表单填写

在 OpenClaw 中说：
```
"在百度搜索框输入 'OpenClaw'"
```

**期望结果：**
- OpenClaw 调用 browser_launch
- OpenClaw 调用 browser_goto
- OpenClaw 调用 browser_fill
- OpenClaw 调用 browser_close

---

## 🔍 调试方法

### 查看 OpenClaw 日志

如果 OpenClaw 仍然不知道如何调用工具，查看日志：

1. **查看 OpenClaw 输出**
   - OpenClaw 通常会显示它正在做什么
   - 看看是否有 MCP 工具调用的日志

2. **查看 MCP 服务器日志**
   ```powershell
   # 查看 MCP 服务器进程
   Get-Process -Name node | Where-Object { $_.MainWindowTitle -like "*MCP*" }
   ```

3. **检查 MCP 连接**
   ```powershell
   # 检查端口 18789 是否监听
   netstat -ano | findstr "18789"
   ```

---

## 📋 检查清单

- [ ] MCP 服务器正在运行（端口 18789 监听）
- [ ] OpenClaw Gateway 正在运行
- [ ] 技能状态显示 "Ready"（已注册）
- [ ] SKILL.md 包含 AI 调用指南
- [ ] 已重启 OpenClaw
- [ ] 测试简单命令（"访问 example.com"）

---

## 🆘 如果还是不行

### 可能的原因：

1. **OpenClaw 版本问题**
   - 某些版本的 OpenClaw 可能对 MCP 支持不完善
   - 检查 OpenClaw 版本和更新日志

2. **MCP 协议版本不匹配**
   - 检查 OpenClaw 使用的 MCP 协议版本
   - 检查 playwright-browser-skill 使用的 MCP SDK 版本

3. **SKILL.md 格式问题**
   - OpenClaw 可能对 SKILL.md 的格式有特殊要求
   - 查看 OpenClaw 官方文档或示例技能

4. **AI 模型限制**
   - OpenClaw 使用的 AI 模型可能无法理解复杂的工具调用
   - 需要更简化的指令

### 下一步：

1. **查看 OpenClaw 官方文档**
   - 查找 MCP 技能开发指南
   - 查看示例技能的 SKILL.md 格式

2. **联系 OpenClaw 支持**
   - 询问如何正确编写 SKILL.md
   - 询问 AI 如何理解工具调用

3. **简化工具集**
   - 先只暴露 10-20 个最常用的工具
   - 确保这些工具能正常工作后再添加更多

---

## 📝 更新记录

- **2024-03-01**: 在 SKILL.md 开头添加 AI 调用指南
- **2024-03-01**: 创建此故障排除文档

---

**下一步：请执行方案 1（重新部署技能），然后测试是否能正常工作。**
