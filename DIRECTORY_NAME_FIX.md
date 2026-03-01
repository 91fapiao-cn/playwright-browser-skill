# 目录命名一致性修复

## 问题描述

在之前的版本中，发行版包名和部署脚本创建的目录名不一致：

- **发行版包名**：`playwright-browser-skill-windows-v2.1.0.zip`
- **部署脚本创建的目录**：`playwright-browser`（❌ 不一致）

这导致：
1. 用户按照文档配置 mcp.json 时，路径可能不正确
2. 发行版包名和实际安装目录名不一致，造成混淆
3. MCP 服务器无法自动启动

## 修复方案

采用方案 B：统一使用 `playwright-browser-skill` 作为目录名

### 修改的文件

1. **部署脚本（英文版）**
   - `auto-deploy-en.cmd`
   - `auto-deploy-en.ps1`
   - `auto-deploy-en.sh`

2. **部署脚本（中文版）**
   - `auto-deploy.cmd`
   - `auto-deploy.ps1`
   - `auto-deploy.sh`

3. **配置文件示例**
   - `mcp-config-fix.json`

4. **文档**
   - `MCP_CONFIG_FIX.md`

### 修改内容

所有部署脚本中的目录名从 `playwright-browser` 改为 `playwright-browser-skill`：

```bash
# 修改前
SKILL_DIR="$SKILLS_DIR/playwright-browser"

# 修改后
SKILL_DIR="$SKILLS_DIR/playwright-browser-skill"
```

## 命名规范

统一后的命名规范：

| 项目 | 名称 | 说明 |
|------|------|------|
| 发行版包名（Windows） | `playwright-browser-skill-windows-v2.1.0.zip` | 保持不变 |
| 发行版包名（Mac/Linux） | `playwright-browser-skill-macos-linux-v2.1.0.tar.gz` | 保持不变 |
| 安装目录名 | `playwright-browser-skill` | ✅ 已修复 |
| MCP 服务器名 | `playwright-browser` | 在 mcp.json 中使用 |
| npm 包名 | `playwright-browser-skill` | package.json 中 |

## 用户影响

### 新用户
- 使用更新后的部署脚本，会自动创建正确的目录名
- 无需任何额外操作

### 已部署的用户
如果你已经使用旧版本脚本部署，有两个选择：

#### 选项 1：重新部署（推荐）
```cmd
# 删除旧的安装
rmdir /s /q C:\Users\Administrator\.openclaw\skills\playwright-browser

# 重新运行部署脚本
.\auto-deploy-en.cmd
```

#### 选项 2：手动重命名
```cmd
# 重命名目录
cd C:\Users\Administrator\.openclaw\skills
move playwright-browser playwright-browser-skill

# 更新 mcp.json 中的路径
# 将路径从 .../playwright-browser/... 改为 .../playwright-browser-skill/...
```

## 验证

部署后，确认以下内容：

1. **目录结构**
   ```
   C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\
   ├── dist\
   │   ├── mcp-server.js
   │   └── index.js
   ├── node_modules\
   ├── package.json
   └── SKILL.md
   ```

2. **mcp.json 配置**
   ```json
   {
     "mcpServers": {
       "playwright-browser": {
         "command": "node",
         "args": [
           "C:/Users/Administrator/.openclaw/skills/playwright-browser-skill/dist/mcp-server.js"
         ]
       }
     }
   }
   ```

3. **MCP 服务器状态**
   - 在 OpenClaw 的 MCP Server 视图中，`playwright-browser` 应显示为 "运行中"

## 测试

修复后，测试 MCP 服务器是否正常工作：

```cmd
# 手动启动测试
node C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\dist\mcp-server.js
```

应该看到：
```
Playwright Browser MCP Server v2.1 已启动
已注册 101 个工具，覆盖 100% 浏览器自动化场景
```

## 相关文档

- [MCP 配置修复指南](MCP_CONFIG_FIX.md)
- [OpenClaw MCP 使用指南](OPENCLAW_MCP_GUIDE.md)
- [Windows 使用指南](WINDOWS_GUIDE.md)

## 总结

✅ 所有部署脚本已更新
✅ 目录命名与发行版包名保持一致
✅ 配置文件示例已更新
✅ 文档已更新

现在发行版包名、安装目录名和文档都使用统一的 `playwright-browser-skill` 命名。
