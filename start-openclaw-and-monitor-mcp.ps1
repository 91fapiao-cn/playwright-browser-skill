# OpenClaw 启动并监控 MCP 服务器脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "OpenClaw 启动并监控 MCP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. 检查配置文件
Write-Host "[1/5] 检查配置文件..." -ForegroundColor Yellow
$mcpConfigPath = "C:\Users\Administrator\.openclaw\settings\mcp.json"
$openclawConfigPath = "C:\Users\Administrator\.openclaw\openclaw.json"

if (Test-Path $mcpConfigPath) {
    Write-Host "  [√] mcp.json 存在" -ForegroundColor Green
    $mcpConfig = Get-Content $mcpConfigPath -Raw | ConvertFrom-Json
    $pbConfig = $mcpConfig.mcpServers.'playwright-browser'
    Write-Host "      - disabled: $($pbConfig.disabled)" -ForegroundColor Gray
    Write-Host "      - command: $($pbConfig.command)" -ForegroundColor Gray
} else {
    Write-Host "  [X] mcp.json 不存在" -ForegroundColor Red
}

if (Test-Path $openclawConfigPath) {
    Write-Host "  [√] openclaw.json 存在" -ForegroundColor Green
    $openclawConfig = Get-Content $openclawConfigPath -Raw | ConvertFrom-Json
    if ($openclawConfig.skills.entries.'playwright-browser-skill') {
        Write-Host "      - playwright-browser-skill: enabled=$($openclawConfig.skills.entries.'playwright-browser-skill'.enabled)" -ForegroundColor Gray
    } else {
        Write-Host "      - playwright-browser-skill: 未配置" -ForegroundColor Yellow
    }
} else {
    Write-Host "  [X] openclaw.json 不存在" -ForegroundColor Red
}
Write-Host ""

# 2. 停止现有的 OpenClaw 进程
Write-Host "[2/5] 停止现有的 OpenClaw 进程..." -ForegroundColor Yellow
$existingProcs = Get-Process | Where-Object {$_.ProcessName -like "*openclaw*" -or $_.ProcessName -like "*claw*"}
if ($existingProcs) {
    foreach ($proc in $existingProcs) {
        Write-Host "  停止: $($proc.ProcessName) (PID: $($proc.Id))" -ForegroundColor Gray
        Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    }
    Start-Sleep -Seconds 3
    Write-Host "  [√] 已停止" -ForegroundColor Green
} else {
    Write-Host "  [!] 没有运行中的 OpenClaw 进程" -ForegroundColor Gray
}
Write-Host ""

# 3. 启动 OpenClaw Gateway
Write-Host "[3/5] 启动 OpenClaw Gateway..." -ForegroundColor Yellow
Write-Host "  正在启动..." -ForegroundColor Gray

try {
    # 尝试启动 OpenClaw Gateway
    Start-Process -FilePath "openclaw" -ArgumentList "gateway" -WindowStyle Hidden -ErrorAction Stop
    Start-Sleep -Seconds 5
    Write-Host "  [√] Gateway 启动命令已执行" -ForegroundColor Green
} catch {
    Write-Host "  [!] 无法通过 CLI 启动，请手动启动 OpenClaw" -ForegroundColor Yellow
    Write-Host "  按任意键继续监控..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
Write-Host ""

# 4. 等待 Gateway 启动
Write-Host "[4/5] 等待 Gateway 完全启动..." -ForegroundColor Yellow
$maxWait = 30
$waited = 0
$gatewayStarted = $false

while ($waited -lt $maxWait) {
    $openclawProcs = Get-Process | Where-Object {$_.ProcessName -like "*openclaw*" -or $_.ProcessName -like "*claw*"}
    if ($openclawProcs) {
        $gatewayStarted = $true
        Write-Host "  [√] Gateway 已启动" -ForegroundColor Green
        break
    }
    Start-Sleep -Seconds 1
    $waited++
    if ($waited % 5 -eq 0) {
        Write-Host "  等待中... ($waited 秒)" -ForegroundColor Gray
    }
}

if (-not $gatewayStarted) {
    Write-Host "  [X] Gateway 未启动，请手动启动 OpenClaw" -ForegroundColor Red
    Write-Host "  按任意键继续监控..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
Write-Host ""

# 5. 监控 MCP 服务器启动
Write-Host "[5/5] 监控 MCP 服务器启动（60秒）..." -ForegroundColor Yellow
Write-Host "  监控中..." -ForegroundColor Gray
Write-Host ""

$startTime = Get-Date
$mcpStarted = $false
$monitorDuration = 60

for ($i = 0; $i -lt $monitorDuration; $i++) {
    Start-Sleep -Seconds 1
    
    # 检查 MCP 服务器进程
    $nodeProcs = Get-Process node -ErrorAction SilentlyContinue
    
    foreach ($proc in $nodeProcs) {
        try {
            $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($proc.Id)").CommandLine
            
            if ($cmdLine -like "*mcp-server.js*") {
                $mcpStarted = $true
                $elapsed = ((Get-Date) - $startTime).TotalSeconds
                
                Write-Host ""
                Write-Host "  [√] MCP 服务器已启动！" -ForegroundColor Green
                Write-Host "      - PID: $($proc.Id)" -ForegroundColor Gray
                Write-Host "      - 启动时间: $([math]::Round($elapsed, 1)) 秒后" -ForegroundColor Gray
                Write-Host "      - 命令行: $cmdLine" -ForegroundColor Gray
                Write-Host ""
                break
            }
        } catch {
            # 忽略错误
        }
    }
    
    if ($mcpStarted) {
        break
    }
    
    # 每10秒显示进度
    if ($i % 10 -eq 0 -and $i -gt 0) {
        Write-Host "  已监控 $i 秒..." -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "监控结果" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($mcpStarted) {
    Write-Host "[√] MCP 服务器成功自动启动！" -ForegroundColor Green
    Write-Host ""
    Write-Host "下一步：在 OpenClaw 对话中测试功能" -ForegroundColor Cyan
    Write-Host "  输入：请列出所有可用的 MCP 工具" -ForegroundColor Gray
    Write-Host "  或者：使用浏览器打开 https://example.com" -ForegroundColor Gray
} else {
    Write-Host "[X] MCP 服务器未自动启动" -ForegroundColor Red
    Write-Host ""
    Write-Host "可能的原因：" -ForegroundColor Yellow
    Write-Host "  1. OpenClaw 版本不支持自动启动 MCP" -ForegroundColor Gray
    Write-Host "  2. 配置文件未被正确读取" -ForegroundColor Gray
    Write-Host "  3. MCP 功能需要手动启用" -ForegroundColor Gray
    Write-Host ""
    Write-Host "建议的解决方案：" -ForegroundColor Yellow
    Write-Host "  1. 在 OpenClaw 开发者工具（F12）中查看错误日志" -ForegroundColor Gray
    Write-Host "  2. 手动启动 MCP 服务器进行测试" -ForegroundColor Gray
    Write-Host "  3. 直接在对话中测试功能（可能已经工作）" -ForegroundColor Gray
}

Write-Host ""
Write-Host "当前进程状态：" -ForegroundColor Cyan
Write-Host ""
Write-Host "OpenClaw 进程：" -ForegroundColor Yellow
$openclawProcs = Get-Process | Where-Object {$_.ProcessName -like "*openclaw*" -or $_.ProcessName -like "*claw*"}
if ($openclawProcs) {
    $openclawProcs | Format-Table ProcessName, Id, StartTime -AutoSize
} else {
    Write-Host "  无" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Node.js 进程：" -ForegroundColor Yellow
$nodeProcs = Get-Process node -ErrorAction SilentlyContinue
if ($nodeProcs) {
    foreach ($proc in $nodeProcs) {
        $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($proc.Id)").CommandLine
        if ($cmdLine -like "*mcp-server*") {
            Write-Host "  [MCP] PID: $($proc.Id)" -ForegroundColor Green
        } elseif ($cmdLine -like "*openclaw*") {
            Write-Host "  [OpenClaw] PID: $($proc.Id)" -ForegroundColor Cyan
        } else {
            Write-Host "  [其他] PID: $($proc.Id)" -ForegroundColor Gray
        }
    }
} else {
    Write-Host "  无" -ForegroundColor Gray
}

Write-Host ""
Write-Host "完成时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ""
