# 一键启动 OpenClaw Gateway 和 MCP 服务器（自动模式，无需交互）

param(
    [switch]$Restart = $false
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "启动 OpenClaw + MCP 服务器（自动模式）" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. 检查并处理现有 Gateway
Write-Host "[1/3] 检查 Gateway 状态..." -ForegroundColor Yellow
$portCheck = netstat -ano | findstr ":18789"
if ($portCheck) {
    if ($Restart) {
        Write-Host "  [!] Gateway 已在运行，正在重启..." -ForegroundColor Yellow
        Get-Process | Where-Object {$_.ProcessName -like '*openclaw*' -or $_.ProcessName -like '*claw*'} | Stop-Process -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 5
    } else {
        Write-Host "  [√] Gateway 已在运行，跳过启动" -ForegroundColor Green
        Write-Host "      （使用 -Restart 参数强制重启）" -ForegroundColor Gray
    }
} else {
    Write-Host "  [!] Gateway 未运行" -ForegroundColor Gray
}
Write-Host ""

# 2. 启动 Gateway（如果需要）
Write-Host "[2/3] 启动 Gateway..." -ForegroundColor Yellow
$portCheck = netstat -ano | findstr ":18789"
if (-not $portCheck) {
    Write-Host "  正在启动..." -ForegroundColor Gray
    Start-Process -FilePath "openclaw" -ArgumentList "gateway" -WindowStyle Hidden
    
    # 等待 Gateway 启动
    $maxWait = 30
    $waited = 0
    $started = $false
    
    while ($waited -lt $maxWait) {
        Start-Sleep -Seconds 1
        $waited++
        
        $portCheck = netstat -ano | findstr ":18789"
        if ($portCheck) {
            $started = $true
            Write-Host "  [√] Gateway 已启动（用时 $waited 秒）" -ForegroundColor Green
            break
        }
        
        if ($waited % 5 -eq 0) {
            Write-Host "  等待中... ($waited 秒)" -ForegroundColor Gray
        }
    }
    
    if (-not $started) {
        Write-Host "  [X] Gateway 启动超时" -ForegroundColor Red
        Write-Host "  请手动启动：openclaw gateway" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "  [√] Gateway 已在运行" -ForegroundColor Green
}
Write-Host ""

# 3. 启动 MCP 服务器
Write-Host "[3/3] 启动 MCP 服务器..." -ForegroundColor Yellow

# 检查是否已运行
$mcpRunning = $false
Get-Process node -ErrorAction SilentlyContinue | ForEach-Object {
    $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine
    if ($cmdLine -like "*mcp-server.js*") {
        $mcpRunning = $true
        Write-Host "  [√] MCP 服务器已在运行 (PID: $($_.Id))" -ForegroundColor Green
    }
}

if (-not $mcpRunning) {
    $mcpServerPath = "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill"
    
    if (Test-Path "$mcpServerPath\dist\mcp-server.js") {
        Write-Host "  正在启动..." -ForegroundColor Gray
        
        # 在新窗口中启动 MCP 服务器（最小化）
        $startCmd = "cd '$mcpServerPath'; `$host.UI.RawUI.WindowTitle = 'Playwright Browser MCP Server'; Write-Host 'Playwright Browser MCP Server' -ForegroundColor Cyan; Write-Host '按 Ctrl+C 停止服务器' -ForegroundColor Yellow; Write-Host '此窗口可以最小化，但请勿关闭' -ForegroundColor Yellow; Write-Host ''; node dist\mcp-server.js"
        Start-Process PowerShell -ArgumentList "-ExecutionPolicy Bypass -NoExit -Command `"$startCmd`"" -WindowStyle Minimized
        
        # 等待 MCP 服务器启动
        Start-Sleep -Seconds 3
        
        # 验证启动
        $mcpStarted = $false
        Get-Process node -ErrorAction SilentlyContinue | ForEach-Object {
            $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine
            if ($cmdLine -like "*mcp-server.js*") {
                $mcpStarted = $true
                Write-Host "  [√] MCP 服务器已启动 (PID: $($_.Id))" -ForegroundColor Green
            }
        }
        
        if (-not $mcpStarted) {
            Write-Host "  [!] MCP 服务器可能还在启动中..." -ForegroundColor Yellow
            Write-Host "      等待 3 秒后再次检查..." -ForegroundColor Gray
            Start-Sleep -Seconds 3
            
            Get-Process node -ErrorAction SilentlyContinue | ForEach-Object {
                $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine
                if ($cmdLine -like "*mcp-server.js*") {
                    Write-Host "  [√] MCP 服务器已启动 (PID: $($_.Id))" -ForegroundColor Green
                }
            }
        }
    } else {
        Write-Host "  [X] MCP 服务器文件不存在" -ForegroundColor Red
        Write-Host "      路径: $mcpServerPath\dist\mcp-server.js" -ForegroundColor Gray
        exit 1
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "启动完成" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 最终状态检查
Write-Host "最终状态：" -ForegroundColor Cyan
Write-Host ""

# Gateway 状态
$portCheck = netstat -ano | findstr ":18789"
if ($portCheck) {
    Write-Host "  [√] Gateway: 运行中（端口 18789）" -ForegroundColor Green
} else {
    Write-Host "  [X] Gateway: 未运行" -ForegroundColor Red
}

# MCP 服务器状态
$mcpFound = $false
Get-Process node -ErrorAction SilentlyContinue | ForEach-Object {
    $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine
    if ($cmdLine -like "*mcp-server.js*") {
        $mcpFound = $true
        Write-Host "  [√] MCP 服务器: 运行中（PID: $($_.Id)）" -ForegroundColor Green
    }
}
if (-not $mcpFound) {
    Write-Host "  [X] MCP 服务器: 未运行" -ForegroundColor Red
}

Write-Host ""
Write-Host "下一步：" -ForegroundColor Cyan
Write-Host "  1. 打开 OpenClaw TUI：openclaw tui" -ForegroundColor Gray
Write-Host "  2. 或在 OpenClaw 对话中测试：" -ForegroundColor Gray
Write-Host "     '请列出所有可用的 MCP 工具'" -ForegroundColor Gray
Write-Host "     '使用浏览器打开 https://example.com'" -ForegroundColor Gray
Write-Host ""
Write-Host "管理命令：" -ForegroundColor Cyan
Write-Host "  - 检查状态：.\check-gateway-and-mcp.ps1" -ForegroundColor Gray
Write-Host "  - 停止服务：.\stop-openclaw-and-mcp.ps1" -ForegroundColor Gray
Write-Host "  - 强制重启：.\start-openclaw-with-mcp-auto.ps1 -Restart" -ForegroundColor Gray
Write-Host ""
Write-Host "注意：MCP 服务器窗口已最小化，请勿关闭" -ForegroundColor Yellow
Write-Host ""
