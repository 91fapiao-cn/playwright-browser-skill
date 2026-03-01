# MCP 注册问题诊断脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "MCP 注册问题诊断" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$skillDir = "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill"
$skillMdPath = Join-Path $skillDir "SKILL.md"
$mcpJsonPath = "C:\Users\Administrator\.openclaw\settings\mcp.json"
$mcpServerPath = Join-Path $skillDir "dist\mcp-server.js"

# 1. 检查 SKILL.md
Write-Host "[1/6] 检查 SKILL.md..." -ForegroundColor Yellow
if (Test-Path $skillMdPath) {
    Write-Host "  ✅ 文件存在" -ForegroundColor Green
    
    $content = Get-Content $skillMdPath -Raw
    
    # 检查 frontmatter
    if ($content -match '^---\s*\n(.*?)\n---') {
        Write-Host "  ✅ Frontmatter 格式正确" -ForegroundColor Green
        
        # 检查必需字段
        if ($content -match 'name:\s*(\S+)') {
            $skillName = $matches[1]
            Write-Host "    name: $skillName" -ForegroundColor Gray
        } else {
            Write-Host "  ❌ 缺少 name 字段" -ForegroundColor Red
        }
        
        if ($content -match 'mcp:') {
            Write-Host "  ✅ 包含 mcp 配置" -ForegroundColor Green
            
            if ($content -match 'command:\s*(\S+)') {
                Write-Host "    command: $($matches[1])" -ForegroundColor Gray
            }
            
            if ($content -match 'dist/mcp-server\.js') {
                Write-Host "    args: dist/mcp-server.js" -ForegroundColor Gray
            }
        } else {
            Write-Host "  ❌ 缺少 mcp 配置" -ForegroundColor Red
        }
    } else {
        Write-Host "  ❌ Frontmatter 格式错误" -ForegroundColor Red
    }
} else {
    Write-Host "  ❌ 文件不存在" -ForegroundColor Red
}
Write-Host ""

# 2. 检查 MCP 服务器文件
Write-Host "[2/6] 检查 MCP 服务器文件..." -ForegroundColor Yellow
if (Test-Path $mcpServerPath) {
    Write-Host "  ✅ mcp-server.js 存在" -ForegroundColor Green
    $size = (Get-Item $mcpServerPath).Length / 1KB
    Write-Host "    大小: $([math]::Round($size, 2)) KB" -ForegroundColor Gray
} else {
    Write-Host "  ❌ mcp-server.js 不存在" -ForegroundColor Red
}
Write-Host ""

# 3. 检查 Node.js
Write-Host "[3/6] 检查 Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "  ✅ Node.js 已安装: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Node.js 未安装或不在 PATH 中" -ForegroundColor Red
}
Write-Host ""

# 4. 测试 MCP 服务器启动
Write-Host "[4/6] 测试 MCP 服务器启动..." -ForegroundColor Yellow
if (Test-Path $mcpServerPath) {
    Write-Host "  [*] 尝试启动 MCP 服务器（5秒超时）..." -ForegroundColor Gray
    
    $job = Start-Job -ScriptBlock {
        param($dir, $server)
        Set-Location $dir
        node $server
    } -ArgumentList $skillDir, "dist\mcp-server.js"
    
    Start-Sleep -Seconds 2
    
    $jobState = $job.State
    if ($jobState -eq "Running") {
        Write-Host "  ✅ MCP 服务器可以启动" -ForegroundColor Green
        Stop-Job $job
        Remove-Job $job
    } else {
        Write-Host "  ❌ MCP 服务器启动失败" -ForegroundColor Red
        $error = Receive-Job $job
        if ($error) {
            Write-Host "    错误: $error" -ForegroundColor Red
        }
        Remove-Job $job
    }
} else {
    Write-Host "  ⚠️  跳过（mcp-server.js 不存在）" -ForegroundColor Yellow
}
Write-Host ""

# 5. 检查 OpenClaw Gateway
Write-Host "[5/6] 检查 OpenClaw Gateway..." -ForegroundColor Yellow
$port = 18789
$connection = Test-NetConnection -ComputerName localhost -Port $port -WarningAction SilentlyContinue -InformationLevel Quiet

if ($connection) {
    Write-Host "  ✅ OpenClaw Gateway 正在运行（端口 $port）" -ForegroundColor Green
} else {
    Write-Host "  ❌ OpenClaw Gateway 未运行" -ForegroundColor Red
    Write-Host "    请启动 OpenClaw 应用程序" -ForegroundColor Yellow
}
Write-Host ""

# 6. 检查 mcp.json
Write-Host "[6/6] 检查 mcp.json..." -ForegroundColor Yellow
if (Test-Path $mcpJsonPath) {
    Write-Host "  ✅ mcp.json 存在" -ForegroundColor Green
    
    try {
        $mcpConfig = Get-Content $mcpJsonPath -Raw | ConvertFrom-Json
        
        if ($mcpConfig.mcpServers) {
            $serverNames = $mcpConfig.mcpServers.PSObject.Properties.Name
            Write-Host "    已配置的服务器: $($serverNames -join ', ')" -ForegroundColor Gray
            
            if ($skillName -and ($serverNames -contains $skillName)) {
                Write-Host "  ✅ 包含 $skillName 配置" -ForegroundColor Green
            } else {
                Write-Host "  ⚠️  不包含 $skillName 配置（可选）" -ForegroundColor Yellow
            }
        }
    } catch {
        Write-Host "  ❌ mcp.json 格式错误" -ForegroundColor Red
    }
} else {
    Write-Host "  ⚠️  mcp.json 不存在（可选）" -ForegroundColor Yellow
}
Write-Host ""

# 诊断结果
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "诊断结果" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "如果 OpenClaw 报告 'MCP 未注册'，可能的原因：" -ForegroundColor Yellow
Write-Host ""

Write-Host "1. OpenClaw 未重启" -ForegroundColor White
Write-Host "   解决方法：关闭并重新打开 OpenClaw" -ForegroundColor Gray
Write-Host ""

Write-Host "2. SKILL.md 格式错误" -ForegroundColor White
Write-Host "   解决方法：检查 YAML 格式，确保缩进正确" -ForegroundColor Gray
Write-Host ""

Write-Host "3. MCP 服务器启动失败" -ForegroundColor White
Write-Host "   解决方法：手动测试启动 MCP 服务器" -ForegroundColor Gray
Write-Host "   命令：cd '$skillDir'; node dist\mcp-server.js" -ForegroundColor Gray
Write-Host ""

Write-Host "4. OpenClaw 版本不支持 SKILL.md 中的 mcp 配置" -ForegroundColor White
Write-Host "   解决方法：确保使用最新版本的 OpenClaw" -ForegroundColor Gray
Write-Host ""

Write-Host "建议的排查步骤：" -ForegroundColor Cyan
Write-Host "  1. 重启 OpenClaw" -ForegroundColor White
Write-Host "  2. 查看 OpenClaw 日志（如果有）" -ForegroundColor White
Write-Host "  3. 手动启动 MCP 服务器测试" -ForegroundColor White
Write-Host "  4. 检查 OpenClaw 的 MCP 服务器列表" -ForegroundColor White
Write-Host ""
