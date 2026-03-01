# OpenClaw MCP 配置优先级和调用时机

**日期**: 2026-03-01  
**主题**: mcp.json vs SKILL.md 中的 MCP 配置

---

## 📋 配置文件对比

### 1. SKILL.md 中的 MCP 配置（推荐）

**位置**: `~/.openclaw/skills/playwright-browser-skill/SKILL.md`

**格式**:
```yaml
---
name: playwright-browser
description: 浏览器自动化技能
version: 2.1.0
mcp:
  command: node
  args:
    - dist/mcp-server.js
---
```

**特点**:
- ✅ 与技能绑定，随技能一起分发
- ✅ 自动适配安装路径（使用相对路径）
- ✅ 跨平台兼容
- ✅ 用户无需手动配置
- ✅ 技能自包含，易于分享

### 2. mcp.json 配置（传统方式）

**位置**: `~/.openclaw/settings/mcp.json`

**格式**:
```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser-skill\\dist\\mcp-server.js"],
      "disabled": false,
      "autoApprove": ["browser_launch", "browser_goto", ...]
    }
  }
}
```

**特点**:
- ⚠️ 需要硬编码绝对路径
- ⚠️ 用户需要手动配置
- ⚠️ 不同用户/系统需要修改路径
- ✅ 可以配置全局 MCP 服务器（不属于任何技能）
- ✅ 可以配置 autoApprove 等高级选项

---

## 🔄 调用时机和优先级

### OpenClaw 启动流程

```
OpenClaw 启动
    ↓
1. 读取 ~/.openclaw/settings/mcp.json
    ↓
2. 扫描 ~/.openclaw/skills/ 目录
    ↓
3. 读取每个技能的 SKILL.md
    ↓
4. 合并 MCP 配置
    ↓
5. 启动所有 MCP 服务器
```

### 配置优先级

**优先级顺序**（从高到低）：

1. **SKILL.md 中的 mcp 配置**（最高优先级）
   - 如果 SKILL.md 包含 `mcp` 配置，OpenClaw 会使用它
   - 会覆盖 mcp.json 中同名的配置

2. **mcp.json 中的配置**（次优先级）
   - 如果 SKILL.md 没有 `mcp` 配置，才会使用 mcp.json
   - 用于配置全局 MCP 服务器

3. **openclaw.json 中的 skills 配置**（最低优先级）
   - 主要用于启用/禁用技能
   - 不推荐在这里配置 MCP

---

## 📊 调用时机详解

### 场景 1：只有 SKILL.md 配置

```
技能目录结构:
~/.openclaw/skills/playwright-browser-skill/
├── SKILL.md (包含 mcp 配置)
└── dist/mcp-server.js

mcp.json: 不存在或不包含 playwright-browser 配置
```

**调用时机**:
- ✅ OpenClaw 启动时读取 SKILL.md
- ✅ 自动启动 MCP 服务器
- ✅ 工作目录自动设置为 SKILL.md 所在目录

**结果**: MCP 服务器正常启动

---

### 场景 2：只有 mcp.json 配置

```
mcp.json:
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["C:\\...\\dist\\mcp-server.js"]
    }
  }
}

SKILL.md: 不包含 mcp 配置
```

**调用时机**:
- ✅ OpenClaw 启动时读取 mcp.json
- ✅ 启动 MCP 服务器
- ⚠️ 需要硬编码绝对路径

**结果**: MCP 服务器启动，但路径不灵活

---

### 场景 3：两者都有（SKILL.md 优先）

```
SKILL.md:
---
mcp:
  command: node
  args:
    - dist/mcp-server.js
---

mcp.json:
{
  "mcpServers": {
    "playwright-browser": {
      "command": "python",
      "args": ["other-server.py"]
    }
  }
}
```

**调用时机**:
- ✅ OpenClaw 读取两个配置
- ✅ **SKILL.md 的配置优先**
- ✅ 使用 `node dist/mcp-server.js`（不是 python）

**结果**: SKILL.md 配置覆盖 mcp.json

---

### 场景 4：mcp.json 用于全局 MCP 服务器

```
mcp.json:
{
  "mcpServers": {
    "playwright-browser": { ... },  // 被 SKILL.md 覆盖
    "global-tool": {                // 全局工具，不属于任何技能
      "command": "node",
      "args": ["C:\\tools\\global-mcp.js"]
    }
  }
}
```

**调用时机**:
- ✅ OpenClaw 启动时读取 mcp.json
- ✅ 启动 playwright-browser（使用 SKILL.md 配置）
- ✅ 启动 global-tool（使用 mcp.json 配置）

**结果**: 两种配置共存

---

## 🎯 最佳实践

### 推荐配置方式

#### 对于技能开发者（Skill 作者）

**✅ 在 SKILL.md 中配置 MCP**

```yaml
---
name: my-skill
version: 1.0.0
mcp:
  command: node
  args:
    - dist/mcp-server.js
---
```

**优势**:
- 技能自包含
- 用户无需配置
- 自动适配路径
- 易于分享和安装

#### 对于用户（Skill 使用者）

**✅ 不需要手动配置 mcp.json**

只需：
1. 将技能复制到 `~/.openclaw/skills/` 目录
2. 重启 OpenClaw
3. 技能自动工作

**⚠️ 只在以下情况需要 mcp.json**:
- 配置全局 MCP 服务器（不属于任何技能）
- 覆盖技能的默认配置（不推荐）
- 配置高级选项（如 autoApprove）

---

## 🔧 高级配置选项

### mcp.json 的额外功能

虽然 SKILL.md 配置优先，但 mcp.json 可以提供额外配置：

```json
{
  "mcpServers": {
    "playwright-browser": {
      "disabled": false,           // 启用/禁用
      "autoApprove": [             // 自动批准的工具
        "browser_launch",
        "browser_goto"
      ],
      "env": {                     // 环境变量
        "DEBUG": "mcp:*"
      }
    }
  }
}
```

**注意**: 这些选项会与 SKILL.md 配置合并，而不是覆盖。

---

## 📝 配置合并规则

### 合并逻辑

```javascript
// 伪代码
const finalConfig = {
  ...mcpJsonConfig,           // 基础配置
  ...skillMdConfig,           // 覆盖 command 和 args
  autoApprove: mcpJsonConfig.autoApprove,  // 保留 mcp.json 的 autoApprove
  disabled: mcpJsonConfig.disabled         // 保留 mcp.json 的 disabled
}
```

### 示例

**SKILL.md**:
```yaml
mcp:
  command: node
  args:
    - dist/mcp-server.js
```

**mcp.json**:
```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "python",        // 被覆盖
      "args": ["old.py"],         // 被覆盖
      "disabled": false,          // 保留
      "autoApprove": ["tool1"]    // 保留
    }
  }
}
```

**最终配置**:
```json
{
  "command": "node",              // 来自 SKILL.md
  "args": ["dist/mcp-server.js"], // 来自 SKILL.md
  "disabled": false,              // 来自 mcp.json
  "autoApprove": ["tool1"]        // 来自 mcp.json
}
```

---

## 🚀 实际应用

### 当前 Playwright Browser Skill 配置

#### SKILL.md（主配置）
```yaml
---
name: playwright-browser
version: 2.1.0
mcp:
  command: node
  args:
    - dist/mcp-server.js
---
```

#### mcp.json（可选的额外配置）
```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser-skill\\dist\\mcp-server.js"],
      "disabled": false,
      "autoApprove": [
        "browser_launch",
        "browser_goto",
        "browser_get_title",
        "browser_get_text",
        "browser_get_html",
        "browser_get_links",
        "browser_get_cookies",
        "browser_close"
      ]
    }
  }
}
```

**实际使用的配置**:
- ✅ command: `node`（来自 SKILL.md）
- ✅ args: `["dist/mcp-server.js"]`（来自 SKILL.md，相对路径）
- ✅ autoApprove: 工具列表（来自 mcp.json）
- ✅ disabled: `false`（来自 mcp.json）

---

## 🎓 总结

### mcp.json 调用时机

1. **OpenClaw 启动时**
   - 读取 `~/.openclaw/settings/mcp.json`
   - 加载所有 MCP 服务器配置

2. **扫描技能目录时**
   - 读取每个 SKILL.md
   - 如果有 `mcp` 配置，覆盖 mcp.json 中的 command 和 args

3. **启动 MCP 服务器时**
   - 使用合并后的配置
   - SKILL.md 的 command/args 优先
   - mcp.json 的 autoApprove/disabled 保留

### 配置建议

| 场景 | 推荐配置位置 | 原因 |
|------|------------|------|
| 技能开发 | SKILL.md | 自包含，易分享 |
| 全局工具 | mcp.json | 不属于特定技能 |
| autoApprove | mcp.json | 用户偏好设置 |
| 路径配置 | SKILL.md | 自动适配 |
| 禁用技能 | mcp.json | 临时控制 |

### 最佳实践

1. ✅ **技能作者**: 在 SKILL.md 中配置 MCP
2. ✅ **用户**: 通常不需要修改 mcp.json
3. ✅ **高级用户**: 使用 mcp.json 配置 autoApprove 和全局工具
4. ❌ **避免**: 在 mcp.json 中硬编码技能路径

---

## 🔍 调试技巧

### 查看实际使用的配置

1. **查看 OpenClaw 日志**
   - 启动时会显示加载的 MCP 配置
   - 显示配置来源（SKILL.md 或 mcp.json）

2. **测试配置优先级**
   ```powershell
   # 临时修改 mcp.json 中的 command
   # 重启 OpenClaw
   # 检查是否使用了 SKILL.md 的配置
   ```

3. **验证路径解析**
   ```powershell
   # 检查 MCP 服务器进程的命令行
   Get-Process node | ForEach-Object {
       (Get-WmiObject Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine
   }
   ```

**配置状态**: ✅ 清晰明了
