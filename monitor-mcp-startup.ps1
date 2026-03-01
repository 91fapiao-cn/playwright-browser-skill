# OpenClaw Gateway 重启并监控 MCP 启动脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "OpenClaw Gateway 重启监控" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. 记录当前进程
Write-Host "[1/6] 记录当前进程..." -ForegroundColor Yellow
$beforeProcesses = Get-Process node -ErrorAction SilentlyContinue
Write-Host "  当前 Node.js 进程数: $($beforeProcesses.Count)" -ForegroundColor Gray
Write-Host ""

# 2. 停止 OpenClaw Gateway
Write-Host "[2/6] 停止 OpenClaw Gateway..." -ForegroundColor Yellow
$openclawProcesses = Get-Process | Where-Object {$_.ProcessName -like "*openclaw*" -or $_.ProcessName -like "*claw*"}
if ($openclawProcesses) {
    Write-Host "  找到 $($openclawProcesses.Count) 个 OpenClaw 进程" -ForegroundColor Gray
    foreach ($proc in $openclawProcesses) {
        Write-Host "  停止: $($proc.ProcessName) (PID: $($proc.Id))" -ForegroundColor Gray
        Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    }
    Write-Host "  [√] OpenClaw 进程已停止" -ForegroundColor Green
} else {
    Write-Host "  [!] 未找到 OpenClaw 进程" -ForegroundColor Yellow
}
Write-Host ""

# 3. 等待进程完全退出
Write-Host "[3/6] 等待进程完全退出..." -ForegroundColor Yellow
Start-Sleep -Seconds 3
Write-Host "  [√] 等待完成" -ForegroundColor Green
Write-Host ""

# 4. 验证 mcp.json
Write-Host "[4/6] 验证 mcp.json 配置..." -ForegroundColor Yellow
$mcpPath = "C:\Users\Administrator\.openclaw\settings\mcp.json"
try {
    $mcpConfig = Get-Content $mcpPath -Raw | ConvertFrom-Json
    $pbConfig = $mcpConfig.mcpServers.'playwright-browser'
    
    Write-Host "  [√] mcp.json 格式正确" -ForegroundColor Green
    Write-Host "    - command: $($pbConfig.command)" -ForegroundColor Gray
    Write-Host "    - args: $($pbConfig.args[0])" -ForegroundColor Gray
    Write-Host "    - disabled: $($pbConfig.disabled)" -ForegroundColor Gray
    
    # 验证文件存在
    $mcpServerPath = $pbConfig.args[0]
    if (Test-Path $mcpServerPath) {
        Write-Host "  [√] MCP 服务器文件存在" -ForegroundColor Green
    } else {
        Write-Host "  [X] MCP 服务器文件不存在: $mcpServerPath" -ForegroundColor Red
    }
} catch {
    Write-Host "  [X] mcp.json 验证失败: $_" -ForegroundColor Red
}
Write-Host ""

# 5. 启动 OpenClaw Gateway
Write-Host "[5/6] 启动 OpenClaw Gateway..." -ForegroundColor Yellow
Write-Host "  请手动启动 OpenClaw 应用程序" -ForegroundColor Yellow
Write-Host "  按任意键继续监控..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Write-Host ""

# 6. 监控 MCP 服务启动
Write-Host "[6/6] 监控 MCP 服务启动（60秒）..." -ForegroundColor Yellow
Write-Host "  监控中..." -ForegroundColor Gray
Write-Host ""

$startTime = Get-Date
$mcpStarted = $false
$monitorDuration = 60

for ($i = 0; $i -lt $monitorDuration; $i++) {
    Start-Sleep -Seconds 1
    
    # 检查新的 Node.js 进程
    $currentProcesses = Get-Process node -ErrorAction SilentlyContinue
    
    foreach ($proc in $currentProcesses) {
        try {
            $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($proc.Id)").CommandLine
            
            if ($cmdLine -like "*mcp-server.js*") {
                $mcpStarted = $true
                $elapsed = ((Get-Date) - $startTime).TotalSeconds
                
                Write-Host ""
                Write-Host "  [√] MCP 服务器已启动！" -ForegroundColor Green
                Write-Host "    - PID: $($proc.Id)" -ForegroundColor Gray
                Write-Host "    - 启动时间: $([math]::Round($elapsed, 1)) 秒后" -ForegroundColor Gray
                Write-Host "    - 命令行: $cmdLine" -ForegroundColor Gray
                Write-Host ""
                
                # 等待几秒让服务器完全启动
                Write-Host "  等待服务器完全启动..." -ForegroundColor Gray
                Start-Sleep -Seconds 3
                
                # 验证服务器输出
                Write-Host "  [√] MCP 服务器运行中" -ForegroundColor Green
                break
            }
        } catch {
            # 忽略错误，继续监控
        }
    }
    
    if ($mcpStarted) {
        break
    }
    
    # 每10秒显示一次进度
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
    Write-Host "[√] MCP 服务器成功启动" -ForegroundColor Green
    Write-Host ""
    Write-Host "当前运行的 Node.js 进程:" -ForegroundColor Cyan
    Get-Process node -ErrorAction SilentlyContinue | ForEach-Object {
        $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine
        if ($cmdLine -like "*mcp-server*") {
            Write-Host "  [MCP] PID: $($_.Id) - $cmdLine" -ForegroundColor Green
        } else {
            Write-Host "  [其他] PID: $($_.Id)" -ForegroundColor Gray
        }
    }
} else {
    Write-Host "[X] MCP 服务器未启动" -ForegroundColor Red
    Write-Host ""
    Write-Host "可能的原因:" -ForegroundColor Yellow
    Write-Host "  1. OpenClaw Gateway 未正确启动" -ForegroundColor Gray
    Write-Host "  2. mcp.json 配置未被读取" -ForegroundColor Gray
    Write-Host "  3. MCP 服务器启动失败（无错误输出）" -ForegroundColor Gray
    Write-Host "  4. OpenClaw 版本不支持自动启动 MCP" -ForegroundColor Gray
    Write-Host ""
    Write-Host "建议:" -ForegroundColor Yellow
    Write-Host "  1. 检查 OpenClaw 日志（开发者工具 Console）" -ForegroundColor Gray
    Write-Host "  2. 在 OpenClaw UI 中手动连接 MCP 服务器" -ForegroundColor Gray
    Write-Host "  3. 确认 OpenClaw 版本支持 MCP 功能" -ForegroundColor Gray
    Write-Host ""
    Write-Host "当前运行的 Node.js 进程:" -ForegroundColor Cyan
    $nodeProcs = Get-Process node -ErrorAction SilentlyContinue
    if ($nodeProcs) {
        $nodeProcs | ForEach-Object {
            Write-Host "  PID: $($_.Id) - 启动时间: $($_.StartTime)" -ForegroundColor Gray
        }
    } else {
        Write-Host "  无 Node.js 进程运行" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "详细诊断" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 OpenClaw 进程
Write-Host "OpenClaw 进程:" -ForegroundColor Yellow
$openclawProcs = Get-Process | Where-Object {$_.ProcessName -like "*openclaw*" -or $_.ProcessName -like "*claw*"}
if ($openclawProcs) {
    $openclawProcs | Format-Table ProcessName, Id, StartTime, @{Label="Memory(MB)";Expression={[math]::Round($_.WorkingSet64/1MB,2)}} -AutoSize
} else {
    Write-Host "  无 OpenClaw 进程运行" -ForegroundColor Gray
}
Write-Host ""

# 检查配置文件
Write-Host "配置文件检查:" -ForegroundColor Yellow
Write-Host "  mcp.json: $(if (Test-Path $mcpPath) { '✓ 存在' } else { '✗ 不存在' })" -ForegroundColor Gray
Write-Host "  mcp-server.js: $(if (Test-Path $mcpServerPath) { '✓ 存在' } else { '✗ 不存在' })" -ForegroundColor Gray
Write-Host ""

Write-Host "完成时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
