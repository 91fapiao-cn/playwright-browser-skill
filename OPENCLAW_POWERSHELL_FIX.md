# OpenClaw PowerShell 启动问题修复

**问题时间：** 2026-03-01  
**问题：** OpenClaw 在 Windows 上使用 `&&` 语法启动 MCP 服务器失败  
**原因：** PowerShell 不支持 `&&` 语法（这是 Bash 语法）  
**状态：** ✅ 已提供解决方案

---

## 🔍 问题分析

### 错误信息

```
初始尝试失败：直接用 PowerShell 的 && 语法启动 MCP 服务器失败
（PowerShell 不支持 &&）
```

### 问题原因

**OpenClaw 的启动逻辑：**
1. OpenClaw 尝试使用 `&&` 语法启动 MCP 服务器
2. 例如：`cd /path && node mcp-server.js`
3. 但 PowerShell 不支持 `&&` 语法
4. 导致启动失败

**为什么会这样：**
- `&&` 是 Bash/CMD 的语法
- PowerShell 使用 `;` 或换行来分隔命令
- OpenClaw 可能没有正确检测 Windows 环境

---

## ✅ 解决方案

### 方案 1：使用 CMD 而不是 PowerShell（推荐）

OpenClaw 应该在 Windows 上使用 CMD 而不是 PowerShell。

**检查 OpenClaw 配置：**

查看 `openclaw.json` 中是否有 shell 配置：

```json
{
  "commands": {
    "native": "auto",
    "nativeSkills": "auto"
  }
}
```

**如果有 shell 配置，尝试设置为 CMD：**

```json
{
  "commands": {
    "native": "cmd",
    "nativeSkills": "cmd",
    "shell": "cmd"
  }
}
```

### 方案 2：简化配置（推荐）✅

**当前配置已经是最简单的形式：**

```json
{
  "skills": {
    "entries": {
      "playwright-browser": {
        "enabled": true,
        "config": {
          "command": "node",
          "args": [
            "C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser\\dist\\mcp-server.js"
          ],
          "type": "mcp"
        }
      }
    }
  }
}
```

**这个配置不应该使用 `&&` 语法！**

OpenClaw 应该直接执行：
```
node C:\Users\Administrator\.openclaw\skills\playwright-browser\dist\mcp-server.js
```

### 方案 3：创建启动脚本

如果 OpenClaw 坚持使用复杂的启动逻辑，我们可以创建一个启动脚本。

**创建 `start-mcp.cmd`：**

```batch
@echo off
cd /d "%~dp0"
node dist\mcp-server.js
```

**然后修改配置：**

```json
{
  "skills": {
    "entries": {
      "playwright-browser": {
        "enabled": true,
        "config": {
          "command": "cmd",
          "args": [
            "/c",
            "C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser\\start-mcp.cmd"
          ],
          "type": "mcp"
        }
      }
    }
  }
}
```

### 方案 4：使用 mcp.json 而不是 openclaw.json

**删除 openclaw.json 中的配置：**

```json
{
  "skills": {
    "entries": {}
  }
}
```

**确保 mcp.json 配置正确：**

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": [
        "C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser\\dist\\mcp-server.js"
      ],
      "disabled": false
    }
  }
}
```

---

## 🔧 实施步骤

### 步骤 1：尝试方案 4（最简单）✅

**1. 备份当前配置：**

```powershell
Copy-Item "$env:USERPROFILE\.openclaw\openclaw.json" "$env:USERPROFILE\.openclaw\openclaw.json.backup"
```

**2. 从 openclaw.json 中删除技能配置：**

```powershell
$configPath = "$env:USERPROFILE\.openclaw\openclaw.json"
$config = Get-Content $configPath -Raw | ConvertFrom-Json

# 清空 skills.entries
$config.skills.entries = @{}

# 保存
$config | ConvertTo-Json -Depth 100 | Set-Content $configPath -Encoding UTF8

Write-Host "✅ 已从 openclaw.json 中删除技能配置"
Write-Host "📝 OpenClaw 现在将使用 mcp.json 中的配置"
```

**3. 验证 mcp.json 配置：**

```powershell
Get-Content "$env:USERPROFILE\.openclaw\settings\mcp.json" -Raw
```

应该看到：
```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": [
        "C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser\\dist\\mcp-server.js"
      ],
      "disabled": false,
      "autoApprove": [...]
    }
  }
}
```

**4. 重启 OpenClaw**

### 步骤 2：如果方案 4 不行，尝试方案 3

**1. 创建启动脚本：**

```powershell
$scriptContent = @"
@echo off
cd /d "%~dp0"
node dist\mcp-server.js
"@

$scriptPath = "$env:USERPROFILE\.openclaw\skills\playwright-browser\start-mcp.cmd"
$scriptContent | Set-Content $scriptPath -Encoding ASCII

Write-Host "✅ 已创建启动脚本：$scriptPath"
```

**2. 修改 openclaw.json：**

```powershell
$configPath = "$env:USERPROFILE\.openclaw\openclaw.json"
$config = Get-Content $configPath -Raw | ConvertFrom-Json

# 修改配置
$config.skills.entries.'playwright-browser'.config.command = "cmd"
$config.skills.entries.'playwright-browser'.config.args = @("/c", "$env:USERPROFILE\.openclaw\skills\playwright-browser\start-mcp.cmd")

# 保存
$config | ConvertTo-Json -Depth 100 | Set-Content $configPath -Encoding UTF8

Write-Host "✅ 已更新配置使用启动脚本"
```

**3. 重启 OpenClaw**

---

## 🎯 推荐方案

### 最佳方案：使用 mcp.json（方案 4）✅

**理由：**
1. ✅ 最简单
2. ✅ 不修改 OpenClaw 主配置
3. ✅ 避免 PowerShell/CMD 兼容性问题
4. ✅ OpenClaw 原生支持

**实施：**

```powershell
# 1. 备份
Copy-Item "$env:USERPROFILE\.openclaw\openclaw.json" "$env:USERPROFILE\.openclaw\openclaw.json.backup"

# 2. 删除 openclaw.json 中的技能配置
$configPath = "$env:USERPROFILE\.openclaw\openclaw.json"
$config = Get-Content $configPath -Raw | ConvertFrom-Json
$config.skills.entries = @{}
$config | ConvertTo-Json -Depth 100 | Set-Content $configPath -Encoding UTF8

# 3. 验证 mcp.json
Write-Host "`n=== mcp.json 配置 ===" -ForegroundColor Cyan
Get-Content "$env:USERPROFILE\.openclaw\settings\mcp.json" -Raw

Write-Host "`n✅ 配置已更新！" -ForegroundColor Green
Write-Host "🔄 请重启 OpenClaw" -ForegroundColor Yellow
```

---

## 📊 方案对比

| 方案 | 复杂度 | 成功率 | 推荐度 |
|------|--------|--------|--------|
| 方案 1：设置 shell | 低 | 中 | ⭐⭐ |
| 方案 2：简化配置 | 低 | 中 | ⭐⭐ |
| 方案 3：启动脚本 | 中 | 高 | ⭐⭐⭐ |
| 方案 4：使用 mcp.json | 低 | 高 | ⭐⭐⭐⭐⭐ |

---

## 🔍 故障排查

### 问题 1：删除配置后仍然报错

**可能原因：**
- OpenClaw 缓存了旧配置
- 需要完全重启

**解决方案：**
1. 完全关闭 OpenClaw
2. 等待 10 秒
3. 重新启动 OpenClaw

### 问题 2：mcp.json 配置不生效

**可能原因：**
- mcp.json 格式错误
- 路径不正确

**解决方案：**

```powershell
# 验证 JSON 格式
try {
    $mcp = Get-Content "$env:USERPROFILE\.openclaw\settings\mcp.json" -Raw | ConvertFrom-Json
    Write-Host "✅ mcp.json 格式正确" -ForegroundColor Green
    
    # 检查路径
    $path = $mcp.mcpServers.'playwright-browser'.args[0]
    if (Test-Path $path) {
        Write-Host "✅ MCP 服务器文件存在：$path" -ForegroundColor Green
    } else {
        Write-Host "❌ MCP 服务器文件不存在：$path" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ mcp.json 格式错误：$_" -ForegroundColor Red
}
```

### 问题 3：Node.js 找不到

**可能原因：**
- Node.js 未安装
- Node.js 不在 PATH 中

**解决方案：**

```powershell
# 检查 Node.js
$nodeVersion = node --version 2>$null
if ($nodeVersion) {
    Write-Host "✅ Node.js 已安装：$nodeVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Node.js 未安装或不在 PATH 中" -ForegroundColor Red
    Write-Host "请安装 Node.js：https://nodejs.org" -ForegroundColor Yellow
}
```

---

## 📝 快速修复脚本

### 一键修复脚本

```powershell
# OpenClaw PowerShell 问题快速修复脚本

Write-Host "=== OpenClaw PowerShell 问题修复 ===" -ForegroundColor Cyan
Write-Host ""

# 1. 备份配置
Write-Host "[1/5] 备份配置..." -ForegroundColor Yellow
$backupPath = "$env:USERPROFILE\.openclaw\openclaw.json.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
Copy-Item "$env:USERPROFILE\.openclaw\openclaw.json" $backupPath
Write-Host "✅ 已备份到：$backupPath" -ForegroundColor Green
Write-Host ""

# 2. 删除 openclaw.json 中的技能配置
Write-Host "[2/5] 删除 openclaw.json 中的技能配置..." -ForegroundColor Yellow
$configPath = "$env:USERPROFILE\.openclaw\openclaw.json"
$config = Get-Content $configPath -Raw | ConvertFrom-Json
$config.skills.entries = @{}
$config | ConvertTo-Json -Depth 100 | Set-Content $configPath -Encoding UTF8
Write-Host "✅ 已删除技能配置" -ForegroundColor Green
Write-Host ""

# 3. 验证 mcp.json
Write-Host "[3/5] 验证 mcp.json 配置..." -ForegroundColor Yellow
try {
    $mcp = Get-Content "$env:USERPROFILE\.openclaw\settings\mcp.json" -Raw | ConvertFrom-Json
    Write-Host "✅ mcp.json 格式正确" -ForegroundColor Green
    
    $path = $mcp.mcpServers.'playwright-browser'.args[0]
    if (Test-Path $path) {
        Write-Host "✅ MCP 服务器文件存在" -ForegroundColor Green
    } else {
        Write-Host "❌ MCP 服务器文件不存在：$path" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ mcp.json 格式错误：$_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 4. 检查 Node.js
Write-Host "[4/5] 检查 Node.js..." -ForegroundColor Yellow
$nodeVersion = node --version 2>$null
if ($nodeVersion) {
    Write-Host "✅ Node.js 已安装：$nodeVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Node.js 未安装" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 5. 完成
Write-Host "[5/5] 修复完成！" -ForegroundColor Green
Write-Host ""
Write-Host "=== 下一步 ===" -ForegroundColor Cyan
Write-Host "1. 重启 OpenClaw" -ForegroundColor White
Write-Host "2. 测试技能是否可用" -ForegroundColor White
Write-Host ""
Write-Host "如果仍有问题，请查看：OPENCLAW_MCP_GUIDE.md" -ForegroundColor Yellow
```

**保存为 `fix-openclaw-powershell.ps1` 并运行：**

```powershell
.\fix-openclaw-powershell.ps1
```

---

## 总结

### ✅ 推荐方案

**使用 mcp.json 而不是 openclaw.json**

**原因：**
1. 避免 PowerShell/CMD 兼容性问题
2. 配置更简单
3. OpenClaw 原生支持
4. 不会破坏其他配置

**步骤：**
1. 从 openclaw.json 中删除技能配置
2. 确保 mcp.json 配置正确
3. 重启 OpenClaw

### 🎯 如果问题仍然存在

1. 查看 OpenClaw 日志
2. 检查 Node.js 是否正确安装
3. 尝试使用启动脚本（方案 3）
4. 联系 OpenClaw 支持

---

**文档创建时间：** 2026-03-01  
**状态：** ✅ 已提供完整解决方案

