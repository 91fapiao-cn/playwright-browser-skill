# MCP 服务器诊断脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "MCP 服务器诊断工具" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. 检查 Node.js
Write-Host "[1/8] 检查 Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "  [√] Node.js 版本: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "  [X] Node.js 未安装或不在 PATH 中" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 2. 检查目录结构
Write-Host "[2/8] 检查目录结构..." -ForegroundColor Yellow
$skillDir = "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill"
$mcpServer = "$skillDir\dist\mcp-server.js"
$skillMd = "$skillDir\SKILL.md"

if (Test-Path $skillDir) {
    Write-Host "  [√] Skill 目录存在" -ForegroundColor Green
} else {
    Write-Host "  [X] Skill 目录不存在: $skillDir" -ForegroundColor Red
    exit 1
}

if (Test-Path $mcpServer) {
    Write-Host "  [√] MCP 服务器文件存在" -ForegroundColor Green
} else {
    Write-Host "  [X] MCP 服务器文件不存在: $mcpServer" -ForegroundColor Red
    exit 1
}

if (Test-Path $skillMd) {
    Write-Host "  [√] SKILL.md 文件存在" -ForegroundColor Green
} else {
    Write-Host "  [X] SKILL.md 文件不存在: $skillMd" -ForegroundColor Red
}
Write-Host ""

# 3. 检查 mcp.json 配置
Write-Host "[3/8] 检查 mcp.json 配置..." -ForegroundColor Yellow
$mcpConfigPath = "C:\Users\Administrator\.openclaw\settings\mcp.json"

if (Test-Path $mcpConfigPath) {
    Write-Host "  [√] mcp.json 文件存在" -ForegroundColor Green
    
    try {
        $mcpConfig = Get-Content $mcpConfigPath -Raw | ConvertFrom-Json
        
        if ($mcpConfig.mcpServers.'playwright-browser') {
            Write-Host "  [√] playwright-browser 配置存在" -ForegroundColor Green
            
            $config = $mcpConfig.mcpServers.'playwright-browser'
            Write-Host "    - command: $($config.command)" -ForegroundColor Gray
            Write-Host "    - args: $($config.args)" -ForegroundColor Gray
            Write-Host "    - disabled: $($config.disabled)" -ForegroundColor Gray
            
            if ($config.disabled -eq $true) {
                Write-Host "  [!] 警告: MCP 服务器被禁用 (disabled = true)" -ForegroundColor Yellow
            }
        } else {
            Write-Host "  [X] playwright-browser 配置不存在" -ForegroundColor Red
        }
    } catch {
        Write-Host "  [X] mcp.json 格式错误: $_" -ForegroundColor Red
    }
} else {
    Write-Host "  [X] mcp.json 文件不存在: $mcpConfigPath" -ForegroundColor Red
}
Write-Host ""

# 4. 测试 MCP 服务器启动
Write-Host "[4/8] 测试 MCP 服务器启动..." -ForegroundColor Yellow
Write-Host "  启动 MCP 服务器（3秒后自动停止）..." -ForegroundColor Gray

$job = Start-Job -ScriptBlock {
    param($mcpServer)
    node $mcpServer 2>&1
} -ArgumentList $mcpServer

Start-Sleep -Seconds 3
$output = Receive-Job $job
Stop-Job $job
Remove-Job $job

if ($output -match "已启动" -or $output -match "started") {
    Write-Host "  [√] MCP 服务器可以正常启动" -ForegroundColor Green
    Write-Host "    输出: $($output | Select-Object -First 2)" -ForegroundColor Gray
} else {
    Write-Host "  [X] MCP 服务器启动失败" -ForegroundColor Red
    Write-Host "    输出: $output" -ForegroundColor Gray
}
Write-Host ""

# 5. 检查依赖
Write-Host "[5/8] 检查依赖..." -ForegroundColor Yellow
$nodeModules = "$skillDir\node_modules"
$playwright = "$nodeModules\playwright"
$mcpSdk = "$nodeModules\@modelcontextprotocol\sdk"

if (Test-Path $playwright) {
    Write-Host "  [√] Playwright 已安装" -ForegroundColor Green
} else {
    Write-Host "  [X] Playwright 未安装" -ForegroundColor Red
}

if (Test-Path $mcpSdk) {
    Write-Host "  [√] MCP SDK 已安装" -ForegroundColor Green
} else {
    Write-Host "  [X] MCP SDK 未安装" -ForegroundColor Red
}
Write-Host ""

# 6. 检查 OpenClaw 配置
Write-Host "[6/8] 检查 OpenClaw 配置..." -ForegroundColor Yellow
$openclawConfig = "C:\Users\Administrator\.openclaw\openclaw.json"

if (Test-Path $openclawConfig) {
    Write-Host "  [√] openclaw.json 文件存在" -ForegroundColor Green
    
    try {
        $config = Get-Content $openclawConfig -Raw | ConvertFrom-Json
        
        if ($config.skills) {
            Write-Host "  [√] skills 配置存在" -ForegroundColor Green
            
            if ($config.skills.entries) {
                $skillCount = ($config.skills.entries | Get-Member -MemberType NoteProperty).Count
                Write-Host "    - 已注册 skills: $skillCount" -ForegroundColor Gray
                
                if ($config.skills.entries.'playwright-browser' -or $config.skills.entries.'playwright-browser-skill') {
                    Write-Host "  [√] playwright-browser skill 已注册" -ForegroundColor Green
                } else {
                    Write-Host "  [!] playwright-browser skill 未在 openclaw.json 中注册" -ForegroundColor Yellow
                    Write-Host "    这可能是正常的，OpenClaw 可能自动发现 skills" -ForegroundColor Gray
                }
            }
        }
    } catch {
        Write-Host "  [!] 无法解析 openclaw.json: $_" -ForegroundColor Yellow
    }
} else {
    Write-Host "  [X] openclaw.json 文件不存在" -ForegroundColor Red
}
Write-Host ""

# 7. 检查文件权限
Write-Host "[7/8] 检查文件权限..." -ForegroundColor Yellow
try {
    $acl = Get-Acl $mcpServer
    Write-Host "  [√] 可以读取文件权限" -ForegroundColor Green
} catch {
    Write-Host "  [X] 无法读取文件权限: $_" -ForegroundColor Red
}
Write-Host ""

# 8. 生成诊断报告
Write-Host "[8/8] 生成诊断报告..." -ForegroundColor Yellow

$report = @"
# MCP 服务器诊断报告

生成时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## 环境信息
- Node.js 版本: $nodeVersion
- 操作系统: $($PSVersionTable.OS)
- PowerShell 版本: $($PSVersionTable.PSVersion)

## 文件检查
- Skill 目录: $(if (Test-Path $skillDir) { "✓ 存在" } else { "✗ 不存在" })
- MCP 服务器: $(if (Test-Path $mcpServer) { "✓ 存在" } else { "✗ 不存在" })
- SKILL.md: $(if (Test-Path $skillMd) { "✓ 存在" } else { "✗ 不存在" })
- mcp.json: $(if (Test-Path $mcpConfigPath) { "✓ 存在" } else { "✗ 不存在" })

## 配置检查
- MCP 配置路径: $mcpConfigPath
- MCP 服务器路径: $mcpServer
- disabled 状态: $($mcpConfig.mcpServers.'playwright-browser'.disabled)

## MCP 服务器测试
输出:
$output

## 建议

$(if ($mcpConfig.mcpServers.'playwright-browser'.disabled -eq $true) {
    "⚠️ MCP 服务器被禁用，请在 mcp.json 中设置 disabled: false"
} elseif (-not (Test-Path $mcpServer)) {
    "⚠️ MCP 服务器文件不存在，请重新部署"
} elseif ($output -notmatch "已启动") {
    "⚠️ MCP 服务器无法启动，请检查错误输出"
} else {
    "✓ 配置看起来正确，如果 OpenClaw 仍无法加载，请：
1. 完全关闭 OpenClaw（包括后台进程）
2. 重新启动 OpenClaw
3. 检查 OpenClaw 的开发者工具 Console 中的错误信息
4. 尝试在 OpenClaw 的 MCP Server 视图中手动重新连接"
})

## 下一步

如果问题仍然存在，请：
1. 打开 OpenClaw 开发者工具（Help > Toggle Developer Tools）
2. 查看 Console 标签页
3. 搜索 "playwright" 或 "mcp" 相关错误
4. 将错误信息提供给技术支持
"@

$report | Out-File "mcp-diagnostic-report.txt" -Encoding UTF8
Write-Host "  [√] 诊断报告已保存到: mcp-diagnostic-report.txt" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Green
Write-Host "诊断完成" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "总结:" -ForegroundColor Cyan
if ($output -match "已启动") {
    Write-Host "  ✓ MCP 服务器配置正确且可以启动" -ForegroundColor Green
    Write-Host "  ✓ 如果 OpenClaw 仍无法加载，请完全重启 OpenClaw" -ForegroundColor Green
    Write-Host "  ✓ 或在 OpenClaw 的 MCP Server 视图中手动重新连接" -ForegroundColor Green
} else {
    Write-Host "  ✗ 发现问题，请查看上面的详细信息" -ForegroundColor Red
}
Write-Host ""
Write-Host "详细报告: mcp-diagnostic-report.txt" -ForegroundColor Gray
