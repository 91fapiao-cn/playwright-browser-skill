# 部署脚本更新计划

**创建时间：** 2026-03-01  
**目的：** 评估是否需要更新部署脚本以支持 OpenClaw 配置  
**状态：** ✅ 评估完成

---

## 🔍 当前状态分析

### 当前部署脚本的行为

**所有部署脚本（auto-deploy.cmd, auto-deploy.ps1, auto-deploy.sh）都：**

1. ✅ 复制 SKILL.md 到 `~/.openclaw/skills/playwright-browser/`
2. ✅ 复制 dist/ 到技能目录
3. ✅ 复制 node_modules/ 到技能目录
4. ✅ 复制 package.json 到技能目录
5. ✅ 创建/更新 `~/.openclaw/settings/mcp.json`
6. ❌ **不处理** `~/.openclaw/openclaw.json`

### OpenClaw 的实际行为

根据我们的发现：

1. **OpenClaw 优先读取 `openclaw.json`**
   - 如果 `openclaw.json` 中有技能配置，使用它
   - 忽略 `mcp.json` 中的配置

2. **`mcp.json` 是备选配置**
   - 只有当 `openclaw.json` 中没有配置时才使用
   - 或者 OpenClaw 的某些版本可能只支持 `mcp.json`

---

## 🤔 是否需要更新部署脚本？

### 方案 1：不更新（推荐）✅

**理由：**

1. **保持简单**
   - 只配置 `mcp.json`
   - 让用户手动管理 `openclaw.json`
   - 避免复杂的配置合并逻辑

2. **避免冲突**
   - `openclaw.json` 是 OpenClaw 的主配置文件
   - 包含用户的所有设置（模型、代理、插件等）
   - 自动修改可能破坏用户配置

3. **兼容性**
   - 不同版本的 OpenClaw 可能有不同的配置格式
   - `mcp.json` 是更稳定的配置方式
   - 如果 OpenClaw 没有 `openclaw.json` 中的配置，会自动使用 `mcp.json`

4. **用户控制**
   - 用户可以选择使用哪种配置方式
   - 提供文档说明两种配置方式
   - 用户可以根据需要手动调整

**结论：** ✅ **不需要更新部署脚本**

### 方案 2：更新脚本（不推荐）❌

**如果要更新，需要做什么：**

1. **读取 `openclaw.json`**
   - 解析 JSON 文件
   - 检查 `skills.entries` 是否存在

2. **合并配置**
   - 如果已有技能配置，更新路径
   - 如果没有，添加新配置
   - 保留其他所有配置

3. **处理边缘情况**
   - 配置文件损坏
   - 配置格式不兼容
   - 权限问题

**问题：**
- ❌ 复杂度高
- ❌ 容易出错
- ❌ 可能破坏用户配置
- ❌ 需要处理多种 OpenClaw 版本

**结论：** ❌ **不推荐更新**

---

## ✅ 推荐方案：文档化 + 手动配置

### 1. 保持部署脚本不变

**当前行为：**
- 只配置 `mcp.json`
- 不修改 `openclaw.json`

**优点：**
- 简单可靠
- 不会破坏用户配置
- 兼容性好

### 2. 提供清晰的文档

**已创建的文档：**
- ✅ `OPENCLAW_MCP_GUIDE.md` - 完整的配置指南
- ✅ 说明了两种配置方式
- ✅ 提供了手动配置步骤
- ✅ 提供了自动修复脚本

### 3. 在部署脚本输出中添加提示

**建议在部署完成后添加提示：**

```
========================================
部署完成！
========================================

⚠️ 重要提示：
如果 OpenClaw 无法识别技能，请检查配置：

方法 1：使用 mcp.json（推荐）
  - 确保 openclaw.json 中没有 playwright-browser 配置
  - 重启 OpenClaw

方法 2：使用 openclaw.json
  - 手动编辑 ~/.openclaw/openclaw.json
  - 添加技能配置到 skills.entries
  - 参考：OPENCLAW_MCP_GUIDE.md

详细说明请查看：OPENCLAW_MCP_GUIDE.md
```

---

## 📝 需要做的修改

### 修改 1：更新部署脚本的输出提示

**文件：**
- `auto-deploy.cmd`
- `auto-deploy-en.cmd`
- `auto-deploy.ps1`
- `auto-deploy-en.ps1`
- `auto-deploy.sh`
- `auto-deploy-en.sh`

**修改内容：**
在"下一步"部分添加配置检查提示

### 修改 2：更新 README 文档

**文件：**
- `README.md`
- `README_EN.md`

**修改内容：**
添加 OpenClaw 配置说明的链接

### 修改 3：创建快速配置脚本（可选）

**新文件：**
- `fix-openclaw-config.ps1` - 自动修复 openclaw.json 配置的脚本

**功能：**
- 检查 `openclaw.json` 中的配置
- 如果路径错误，自动修复
- 如果没有配置，提示用户选择配置方式

---

## 🎯 实施计划

### 阶段 1：最小修改（推荐）✅

**只做必要的修改：**

1. ✅ 保持部署脚本不变
2. ✅ 已创建 `OPENCLAW_MCP_GUIDE.md`
3. ⏳ 在部署脚本输出中添加配置提示
4. ⏳ 更新 README 添加配置说明链接

**优点：**
- 改动最小
- 风险最低
- 快速完成

### 阶段 2：增强功能（可选）⏳

**如果需要更好的用户体验：**

1. ⏳ 创建 `fix-openclaw-config.ps1` 脚本
2. ⏳ 在部署脚本中提供配置检查选项
3. ⏳ 添加交互式配置向导

**优点：**
- 用户体验更好
- 减少手动配置
- 但增加了复杂度

---

## 🔍 具体修改内容

### 修改 1：部署脚本输出提示

**在所有部署脚本的"下一步"部分添加：**

```batch
echo.
echo ⚠️ 配置检查：
echo   如果 OpenClaw 无法识别技能，请运行：
echo   fix-openclaw-config.ps1
echo.
echo   或手动检查：
echo   1. 打开 %USERPROFILE%\.openclaw\openclaw.json
echo   2. 查找 "playwright-browser" 配置
echo   3. 确保路径正确（不是 backup 目录）
echo.
echo   详细说明：OPENCLAW_MCP_GUIDE.md
echo.
```

### 修改 2：README 更新

**在 README.md 的"部署"部分添加：**

```markdown
## OpenClaw 配置

部署完成后，如果 OpenClaw 无法识别技能，请参考：

- [OpenClaw MCP 配置指南](OPENCLAW_MCP_GUIDE.md) - 完整的配置说明
- [快速修复脚本](#快速修复) - 自动修复配置问题

### 快速修复

如果遇到配置问题，运行：

```powershell
.\fix-openclaw-config.ps1
```

该脚本会自动检查并修复 OpenClaw 配置。
```

---

## 📊 修改优先级

### 高优先级（必须做）✅

1. ✅ 创建 `OPENCLAW_MCP_GUIDE.md` - **已完成**
2. ⏳ 在部署脚本输出中添加配置提示
3. ⏳ 更新 README 添加配置说明

### 中优先级（建议做）⏳

1. ⏳ 创建 `fix-openclaw-config.ps1` 快速修复脚本
2. ⏳ 在部署脚本中添加配置检查选项

### 低优先级（可选）⏳

1. ⏳ 创建交互式配置向导
2. ⏳ 添加配置验证工具

---

## 🎯 最终建议

### 推荐方案：最小修改 ✅

**理由：**
1. 部署脚本已经工作正常
2. 配置 `mcp.json` 是正确的做法
3. 用户可以根据需要手动调整 `openclaw.json`
4. 已有完整的文档指导

**需要做的：**
1. ✅ 保持部署脚本不变（已完成）
2. ✅ 创建配置指南（已完成）
3. ⏳ 添加部署脚本输出提示（简单修改）
4. ⏳ 更新 README（简单修改）

**不需要做的：**
- ❌ 修改部署脚本的核心逻辑
- ❌ 自动修改 `openclaw.json`
- ❌ 复杂的配置合并逻辑

---

## 总结

### ✅ 当前状态

1. ✅ 部署脚本工作正常
2. ✅ 配置 `mcp.json` 是正确的
3. ✅ 已创建完整的配置指南
4. ✅ 已提供手动修复方案

### ⏳ 建议修改

1. ⏳ 在部署脚本输出中添加配置提示（5分钟）
2. ⏳ 更新 README 添加配置说明链接（5分钟）
3. ⏳ 可选：创建快速修复脚本（30分钟）

### ❌ 不建议修改

1. ❌ 不要修改部署脚本的核心逻辑
2. ❌ 不要自动修改 `openclaw.json`
3. ❌ 不要添加复杂的配置合并功能

---

**评估完成时间：** 2026-03-01  
**结论：** ✅ 部署脚本基本不需要修改，只需添加简单的提示信息

