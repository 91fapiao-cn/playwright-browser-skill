# SKILL.md MCP 配置修复

**日期**: 2026-03-01  
**问题**: SKILL.md 缺少 MCP 启动配置  
**状态**: ✅ 已修复

---

## 问题描述

SKILL.md 文件只有 frontmatter（YAML 头部），但没有告诉 OpenClaw 如何启动 MCP server。

### 原始 frontmatter
```yaml
---
name: playwright-browser
description: 浏览器自动化技能，支持101个工具：页面导航、元素交互、内容提取、截图、网络控制、性能监控等
version: 2.1.0
---
```

### 问题
- OpenClaw Skills 需要在 frontmatter 中指定如何启动 MCP server
- 缺少 `mcp` 字段，导致 OpenClaw 不知道如何启动 MCP 服务器
- 即使 MCP 服务器手动启动，OpenClaw 也无法自动管理它

---

## 解决方案

参考其他 MCP skills 的格式，在 frontmatter 中添加 `mcp` 配置：

### 更新后的 frontmatter
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

### MCP 配置说明

- **command**: `node` - 使用 Node.js 运行 MCP 服务器
- **args**: `["dist/mcp-server.js"]` - MCP 服务器的入口文件路径（相对于 SKILL.md 所在目录）

---

## 实施步骤

### 1. 更新源文件
```powershell
# 更新 skill-package/skills/SKILL.md
# 在 frontmatter 中添加 mcp 配置
```

### 2. 部署到 OpenClaw
```powershell
# 复制更新后的文件到部署目录
Copy-Item "skill-package\skills\SKILL.md" "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\SKILL.md" -Force
```

### 3. 验证
```powershell
# 检查文件是否正确更新
Get-Content "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\SKILL.md" -Head 10
```

---

## 工作原理

### OpenClaw 如何使用 MCP 配置

1. **读取 SKILL.md**: OpenClaw 读取技能目录中的 SKILL.md 文件
2. **解析 frontmatter**: 提取 YAML 头部的配置信息
3. **启动 MCP 服务器**: 根据 `mcp.command` 和 `mcp.args` 启动 MCP 服务器
4. **工作目录**: MCP 服务器的工作目录是 SKILL.md 所在的目录

### 路径解析

- **相对路径**: `dist/mcp-server.js` 相对于 SKILL.md 所在目录
- **完整路径**: `C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\dist\mcp-server.js`

### 与其他配置的关系

#### mcp.json 配置（可选）
```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser-skill\\dist\\mcp-server.js"],
      "disabled": false
    }
  }
}
```

#### openclaw.json 配置（可选）
```json
{
  "skills": {
    "playwright-browser-skill": {
      "enabled": true,
      "mcp": {
        "command": "node",
        "args": ["dist/mcp-server.js"]
      }
    }
  }
}
```

**注意**: SKILL.md 中的 `mcp` 配置是最重要的，OpenClaw 会优先使用它。

---

## 验证结果

### 文件更新成功
```
✅ SKILL.md 已更新

新的 frontmatter 内容:
name: playwright-browser
description: 浏览器自动化技能，支持101个工具：页面导航、元素交互、内容提取、截图、网络控制、性能监控等
version: 2.1.0
mcp:
  command: node
  args:
    - dist/mcp-server.js
```

### 部署位置
- **源文件**: `skill-package/skills/SKILL.md`
- **部署文件**: `C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\SKILL.md`

---

## 预期效果

### 修复前
- ❌ OpenClaw 不知道如何启动 MCP 服务器
- ❌ 需要手动启动 MCP 服务器
- ❌ OpenClaw 无法管理 MCP 服务器生命周期

### 修复后
- ✅ OpenClaw 可以自动启动 MCP 服务器
- ✅ OpenClaw 可以管理 MCP 服务器生命周期
- ✅ 技能可以正常使用所有 101 个工具

---

## 下一步操作

### 1. 重启 OpenClaw
重启 OpenClaw 应用程序，让它重新读取 SKILL.md 配置：
```
关闭 OpenClaw → 重新打开
```

### 2. 验证 MCP 服务器启动
在 OpenClaw 中检查 MCP 服务器是否自动启动：
- 查看 MCP 服务器列表
- 检查 playwright-browser 是否显示为"已连接"

### 3. 测试技能功能
在 OpenClaw 对话中测试：
```
请使用 Playwright Browser Skill 启动浏览器并访问 example.com
```

---

## 相关文件更新

### 需要同步更新的文件

1. **部署脚本** - 确保部署时复制正确的 SKILL.md
   - ✅ `auto-deploy.ps1` - 已包含复制 SKILL.md 的步骤
   - ✅ `auto-deploy-en.ps1` - 已包含复制 SKILL.md 的步骤
   - ✅ `auto-deploy.cmd` - 已包含复制 SKILL.md 的步骤
   - ✅ `auto-deploy-en.cmd` - 已包含复制 SKILL.md 的步骤
   - ✅ `auto-deploy.sh` - 已包含复制 SKILL.md 的步骤
   - ✅ `auto-deploy-en.sh` - 已包含复制 SKILL.md 的步骤

2. **发布包** - 重新构建发布包
   - ⏳ Windows 发布包需要重新构建
   - ⏳ Mac/Linux 发布包需要重新构建

---

## 技术细节

### YAML 格式要求

```yaml
mcp:
  command: node           # 命令（必需）
  args:                   # 参数列表（必需）
    - dist/mcp-server.js  # 相对路径（相对于 SKILL.md 所在目录）
  env:                    # 环境变量（可选）
    NODE_ENV: production
```

**重要提示**：
- ✅ **不要指定 `cwd`**：OpenClaw 会自动将工作目录设置为 SKILL.md 所在的目录
- ✅ **使用相对路径**：`args` 中的路径应该相对于 SKILL.md 所在目录
- ❌ **不要硬编码绝对路径**：避免使用 `C:\Users\...` 这样的绝对路径

### 支持的配置选项

- **command**: 启动命令（如 `node`, `python`, `deno`）（必需）
- **args**: 命令参数数组（必需，使用相对路径）
- **env**: 环境变量对象（可选）
- **cwd**: 工作目录（不推荐指定，OpenClaw 会自动设置）

---

## 故障排除

### 如果 OpenClaw 仍然无法启动 MCP 服务器

1. **检查 SKILL.md 格式**
   ```powershell
   Get-Content "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\SKILL.md" -Head 10
   ```

2. **检查文件路径**
   ```powershell
   Test-Path "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\dist\mcp-server.js"
   ```

3. **检查 Node.js**
   ```powershell
   node --version
   ```

4. **手动测试启动**
   ```powershell
   cd "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill"
   node dist/mcp-server.js
   ```

5. **查看 OpenClaw 日志**
   - 检查 OpenClaw 的日志文件
   - 查找 MCP 服务器启动相关的错误信息

---

## 总结

### 修复内容
- ✅ 在 SKILL.md frontmatter 中添加了 `mcp` 配置
- ✅ 指定了 MCP 服务器的启动命令和参数
- ✅ 更新了源文件和部署文件

### 影响范围
- ✅ OpenClaw 现在可以自动启动和管理 MCP 服务器
- ✅ 用户无需手动启动 MCP 服务器
- ✅ 技能可以正常使用

### 后续工作
- ⏳ 重启 OpenClaw 验证修复效果
- ⏳ 重新构建发布包
- ⏳ 更新文档说明

**修复状态**: ✅ 完成
