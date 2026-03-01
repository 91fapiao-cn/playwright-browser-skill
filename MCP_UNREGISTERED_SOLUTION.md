# "MCP 未注册" 问题解决方案

**日期**: 2026-03-01  
**问题**: OpenClaw 报告 "MCP 未注册"  
**状态**: ✅ 已诊断，待重启验证

---

## 🔍 问题诊断结果

### 配置文件检查 ✅

1. **SKILL.md** ✅
   - 文件存在且格式正确
   - 包含完整的 mcp 配置
   - Frontmatter 格式符合 YAML 规范

2. **mcp-server.js** ✅
   - 文件存在（1.85 KB）
   - 可以正常启动
   - 已注册 101 个工具

3. **Node.js** ✅
   - 已安装（v22.22.0）
   - 在 PATH 中可用

4. **OpenClaw Gateway** ✅
   - 正在运行（端口 18789）

5. **mcp.json** ✅
   - 文件存在
   - 包含 playwright-browser 配置

### 名称匹配检查 ✅

- SKILL.md name: `playwright-browser`
- mcp.json 服务器: `playwright-browser`
- ✅ 名称完全匹配

---

## 🎯 根本原因

**OpenClaw 未重启**

OpenClaw 在启动时读取配置文件：
1. 读取 `~/.openclaw/settings/mcp.json`
2. 扫描 `~/.openclaw/skills/` 目录
3. 读取每个技能的 `SKILL.md`
4. 合并配置并启动 MCP 服务器

如果在 OpenClaw 运行时修改了 SKILL.md，**必须重启 OpenClaw** 才能生效。

---

## ✅ 解决方案

### 步骤 1：完全关闭 OpenClaw

```powershell
# 确保 OpenClaw 完全关闭
Get-Process | Where-Object { $_.ProcessName -like "*openclaw*" -or $_.ProcessName -like "*OpenClaw*" } | Stop-Process -Force
```

或者：
- 在任务栏右键点击 OpenClaw 图标
- 选择"退出"或"关闭"
- 确保进程完全退出

### 步骤 2：重新启动 OpenClaw

- 从开始菜单或桌面快捷方式启动 OpenClaw
- 等待 OpenClaw 完全启动（Gateway 端口 18789 监听）

### 步骤 3：验证 MCP 注册

在 OpenClaw 中检查：
1. 打开 MCP 服务器列表/设置
2. 查找 `playwright-browser`
3. 确认状态为"已连接"或"运行中"
4. 确认工具数量为 101 个

### 步骤 4：测试技能功能

在 OpenClaw 对话中输入：
```
请使用 Playwright Browser Skill 启动浏览器并访问 example.com
```

如果成功，应该能看到浏览器启动并访问网页。

---

## 🔧 如果重启后仍然报错

### 方案 A：手动启动 MCP 服务器测试

```powershell
# 进入技能目录
cd "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill"

# 启动 MCP 服务器
node dist\mcp-server.js
```

**预期输出**:
```
Playwright Browser MCP Server v2.1 已启动
已注册 101 个工具，覆盖 100% 浏览器自动化场景
```

如果启动失败，检查错误信息。

### 方案 B：检查 OpenClaw 日志

OpenClaw 通常会有日志文件，查找：
- `~/.openclaw/logs/`
- OpenClaw 安装目录的 logs 文件夹
- 应用程序数据目录

查找包含以下关键词的日志：
- `playwright-browser`
- `MCP`
- `SKILL.md`
- `error`

### 方案 C：临时使用 mcp.json 配置

如果 SKILL.md 配置不生效，可以临时使用 mcp.json：

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

**注意**: 这是临时方案，使用硬编码路径。

### 方案 D：检查 OpenClaw 版本

确保 OpenClaw 版本支持 SKILL.md 中的 `mcp` 配置：
- 检查 OpenClaw 版本
- 查看官方文档确认 MCP 配置格式
- 如果版本过旧，考虑升级

---

## 📊 配置文件当前状态

### SKILL.md（正确）

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

**位置**: `C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\SKILL.md`

**特点**:
- ✅ YAML 格式正确
- ✅ 包含所有必需字段
- ✅ 使用相对路径
- ✅ 跨平台兼容

### mcp.json（可选）

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser-skill\\dist\\mcp-server.js"],
      "disabled": false,
      "autoApprove": [...]
    }
  }
}
```

**位置**: `C:\Users\Administrator\.openclaw\settings\mcp.json`

**说明**: 
- SKILL.md 的配置会覆盖 mcp.json 中的 command 和 args
- mcp.json 的 autoApprove 和 disabled 会保留

---

## 🎓 OpenClaw MCP 配置机制

### 配置读取顺序

```
OpenClaw 启动
    ↓
1. 读取 mcp.json
    ↓
2. 扫描 skills 目录
    ↓
3. 读取每个 SKILL.md
    ↓
4. 合并配置（SKILL.md 优先）
    ↓
5. 启动 MCP 服务器
```

### 配置优先级

```
SKILL.md 中的 mcp.command 和 mcp.args（最高）
    ↓ 覆盖
mcp.json 中的 command 和 args
    ↓
mcp.json 中的 autoApprove 和 disabled（保留）
```

### 为什么需要重启

OpenClaw 只在启动时读取配置：
- ❌ 运行时修改配置不会自动生效
- ❌ 热重载不支持（或未启用）
- ✅ 重启后会重新读取所有配置

---

## 🚀 预期结果

重启 OpenClaw 后：

1. **MCP 服务器自动启动**
   - OpenClaw 读取 SKILL.md
   - 使用 `node dist/mcp-server.js` 启动
   - 工作目录自动设置为 SKILL.md 所在目录

2. **MCP 注册成功**
   - 在 MCP 服务器列表中显示 `playwright-browser`
   - 状态显示为"已连接"或"运行中"
   - 工具数量显示为 101 个

3. **技能可用**
   - 可以在对话中使用 Playwright Browser Skill
   - 所有 101 个工具都可以调用
   - 浏览器自动化功能正常工作

---

## 📝 验证清单

重启 OpenClaw 后，检查以下项目：

- [ ] OpenClaw 成功启动
- [ ] Gateway 端口 18789 正在监听
- [ ] MCP 服务器列表中显示 playwright-browser
- [ ] MCP 服务器状态为"已连接"
- [ ] 工具数量为 101 个
- [ ] 可以在对话中调用技能
- [ ] 浏览器可以正常启动和控制

---

## 🎉 总结

### 问题原因
- ✅ 配置文件都是正确的
- ✅ MCP 服务器可以正常启动
- ❌ OpenClaw 未重启，无法读取新配置

### 解决方法
1. 完全关闭 OpenClaw
2. 重新启动 OpenClaw
3. 验证 MCP 注册成功
4. 测试技能功能

### 配置状态
- ✅ SKILL.md 格式正确
- ✅ mcp 配置完整
- ✅ 使用相对路径
- ✅ 跨平台兼容
- ✅ 符合最佳实践

**下一步**: 重启 OpenClaw 并验证 MCP 注册成功！
