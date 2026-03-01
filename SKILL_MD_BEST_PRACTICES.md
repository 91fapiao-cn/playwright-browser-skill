# SKILL.md 最佳实践

**日期**: 2026-03-01  
**主题**: SKILL.md MCP 配置的最佳实践

---

## ✅ 正确的配置方式

### 推荐配置（当前使用）

```yaml
---
name: playwright-browser
description: 浏览器自动化技能，支持101个工具：页面导航、元素交互、内容提取、截图、网络控制、性能监控等
version: 2.1.0
mcp:
  command: node
  args:
    - dist/mcp-server.js
---
```

### 为什么这样配置？

1. **自动适配路径**
   - OpenClaw 会自动将工作目录设置为 SKILL.md 所在的目录
   - 无论用户将技能安装在哪里，都能正常工作
   - 支持多用户、多系统

2. **使用相对路径**
   - `dist/mcp-server.js` 相对于 SKILL.md 所在目录
   - 跨平台兼容（Windows、macOS、Linux）
   - 便于移植和分享

3. **不指定 cwd**
   - OpenClaw 会自动处理
   - 避免硬编码路径
   - 减少配置错误

---

## ❌ 错误的配置方式

### 错误示例 1：硬编码绝对路径

```yaml
# ❌ 不要这样做
mcp:
  command: node
  args:
    - C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\dist\mcp-server.js
```

**问题**：
- 只能在特定用户的特定路径下工作
- 无法在其他用户或系统上使用
- 路径变化时需要手动修改

### 错误示例 2：指定硬编码的 cwd

```yaml
# ❌ 不要这样做
mcp:
  command: node
  args:
    - dist/mcp-server.js
  cwd: C:\Users\Administrator\.openclaw\skills\playwright-browser-skill
```

**问题**：
- 硬编码了用户路径
- 无法适配不同的安装位置
- 不必要的配置（OpenClaw 会自动设置）

### 错误示例 3：使用错误的相对路径

```yaml
# ❌ 不要这样做
mcp:
  command: node
  args:
    - ../playwright-browser-skill/dist/mcp-server.js
```

**问题**：
- 假设了特定的目录结构
- 容易出错
- 不符合 OpenClaw 的约定

---

## 📁 目录结构说明

### 标准技能目录结构

```
C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\
├── SKILL.md                    # 技能描述文件（包含 MCP 配置）
├── dist\
│   ├── mcp-server.js          # MCP 服务器入口文件
│   └── index.js               # 其他编译文件
├── node_modules\              # 运行时依赖
├── package.json               # 包配置
└── start-mcp-server.ps1       # 手动启动脚本
```

### 路径解析

当 OpenClaw 读取 SKILL.md 时：

1. **SKILL.md 位置**: `C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\SKILL.md`
2. **自动设置 cwd**: `C:\Users\Administrator\.openclaw\skills\playwright-browser-skill`
3. **解析相对路径**: `dist/mcp-server.js` → `C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\dist\mcp-server.js`

---

## 🔧 部署脚本中的处理

### 部署脚本不需要修改 SKILL.md

部署脚本只需要：
1. 复制 SKILL.md 到目标目录
2. 确保 dist/mcp-server.js 存在
3. 不需要修改 SKILL.md 中的路径

```powershell
# 正确的部署方式
$sourceFile = "skill-package\skills\SKILL.md"
$targetFile = Join-Path $skillDir "SKILL.md"
Copy-Item $sourceFile $targetFile -Force

# ✅ 不需要修改 SKILL.md 中的路径
# ✅ OpenClaw 会自动处理
```

---

## 🌍 跨平台兼容性

### Windows
```yaml
mcp:
  command: node
  args:
    - dist/mcp-server.js
```
实际路径：`C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\dist\mcp-server.js`

### macOS
```yaml
mcp:
  command: node
  args:
    - dist/mcp-server.js
```
实际路径：`/Users/username/.openclaw/skills/playwright-browser-skill/dist/mcp-server.js`

### Linux
```yaml
mcp:
  command: node
  args:
    - dist/mcp-server.js
```
实际路径：`/home/username/.openclaw/skills/playwright-browser-skill/dist/mcp-server.js`

**关键点**：相同的配置在所有平台上都能正常工作！

---

## 📝 配置选项详解

### 必需字段

#### command
- **类型**: string
- **说明**: 启动 MCP 服务器的命令
- **示例**: `node`, `python`, `deno`
- **注意**: 命令必须在系统 PATH 中

#### args
- **类型**: array of strings
- **说明**: 传递给命令的参数
- **示例**: `["dist/mcp-server.js"]`
- **注意**: 使用相对路径，相对于 SKILL.md 所在目录

### 可选字段

#### env
- **类型**: object
- **说明**: 环境变量
- **示例**: `{ "NODE_ENV": "production" }`
- **用途**: 设置运行时环境变量

```yaml
mcp:
  command: node
  args:
    - dist/mcp-server.js
  env:
    NODE_ENV: production
    DEBUG: "mcp:*"
```

#### cwd
- **类型**: string
- **说明**: 工作目录
- **默认**: SKILL.md 所在目录
- **建议**: 不要指定，让 OpenClaw 自动处理

---

## 🧪 测试配置

### 验证配置是否正确

1. **检查 SKILL.md 格式**
```powershell
Get-Content "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\SKILL.md" -Head 10
```

2. **检查文件是否存在**
```powershell
Test-Path "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\dist\mcp-server.js"
```

3. **手动测试启动**
```powershell
cd "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill"
node dist/mcp-server.js
```

4. **在 OpenClaw 中测试**
- 重启 OpenClaw
- 检查 MCP 服务器是否自动启动
- 测试技能功能

---

## 📚 参考其他 MCP Skills

### 标准格式

大多数 MCP skills 都使用类似的配置：

```yaml
---
name: skill-name
description: Skill description
version: 1.0.0
mcp:
  command: node
  args:
    - dist/server.js
---
```

### 变体

#### Python MCP Server
```yaml
mcp:
  command: python
  args:
    - -m
    - mcp_server
```

#### Deno MCP Server
```yaml
mcp:
  command: deno
  args:
    - run
    - --allow-all
    - server.ts
```

---

## ✅ 检查清单

在部署或更新 SKILL.md 时，确保：

- [ ] 使用相对路径（不是绝对路径）
- [ ] 不指定 `cwd`（让 OpenClaw 自动处理）
- [ ] `command` 在系统 PATH 中可用
- [ ] `args` 中的文件路径存在
- [ ] YAML 格式正确（缩进、语法）
- [ ] 在多个平台上测试（如果需要）

---

## 🎯 总结

### 最佳实践

1. ✅ **使用相对路径**：`dist/mcp-server.js`
2. ✅ **不指定 cwd**：让 OpenClaw 自动设置
3. ✅ **简单配置**：只指定必需的 `command` 和 `args`
4. ✅ **跨平台兼容**：相同配置在所有平台工作

### 避免的做法

1. ❌ **硬编码绝对路径**：`C:\Users\...`
2. ❌ **指定硬编码的 cwd**：`cwd: C:\Users\...`
3. ❌ **复杂的相对路径**：`../../other/path`
4. ❌ **平台特定配置**：Windows 和 macOS 使用不同配置

### 当前配置状态

我们的 Playwright Browser Skill 使用了最佳实践：

```yaml
mcp:
  command: node
  args:
    - dist/mcp-server.js
```

这个配置：
- ✅ 简单明了
- ✅ 跨平台兼容
- ✅ 自动适配路径
- ✅ 易于维护

**配置状态**: ✅ 完美
