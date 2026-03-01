# 停止 OpenClaw Gateway 和 MCP 服务器

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "停止 OpenClaw + MCP 服务器" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. 停止 MCP 服务器
Write-Host "[1/2] 停止 MCP 服务器..." -ForegroundColor Yellow
$mcpStopped = 0
Get-Process node -ErrorAction SilentlyContinue | ForEach-Object {
    $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine
    if ($cmdLine -like "*mcp-server.js*") {
        Write-Host "  停止 MCP 服务器 (PID: $($_.Id))" -ForegroundColor Gray
        Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
        $mcpStopped++
    }
}

if ($mcpStopped -gt 0) {
    Write-Host "  [√] 已停止 $mcpStopped 个 MCP 服务器进程" -ForegroundColor Green
} else {
    Write-Host "  [!] 没有运行中的 MCP 服务器" -ForegroundColor Gray
}
Write-Host ""

# 2. 停止 Gateway
Write-Host "[2/2] 停止 Gateway..." -ForegroundColor Yellow
$gatewayStopped = 0
Get-Process | Where-Object {$_.ProcessName -like '*openclaw*' -or $_.ProcessName -like '*claw*'} | ForEach-Object {
    Write-Host "  停止 $($_.ProcessName) (PID: $($_.Id))" -ForegroundColor Gray
    Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
    $gatewayStopped++
}

if ($gatewayStopped -gt 0) {
    Write-Host "  [√] 已停止 $gatewayStopped 个 Gateway 进程" -ForegroundColor Green
} else {
    Write-Host "  [!] 没有运行中的 Gateway" -ForegroundColor Gray
}
Write-Host ""

# 等待进程完全退出
Write-Host "等待进程完全退出..." -ForegroundColor Yellow
Start-Sleep -Seconds 3
Write-Host "  [√] 完成" -ForegroundColor Green
Write-Host ""

# 验证
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "验证状态" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 Gateway
$portCheck = netstat -ano | findstr ":18789"
if ($portCheck) {
    Write-Host "  [!] Gateway 仍在运行（端口 18789）" -ForegroundColor Yellow
} else {
    Write-Host "  [√] Gateway 已停止" -ForegroundColor Green
}

# 检查 MCP 服务器
$mcpFound = $false
Get-Process node -ErrorAction SilentlyContinue | ForEach-Object {
    $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine
    if ($cmdLine -like "*mcp-server.js*") {
        $mcpFound = $true
        Write-Host "  [!] MCP 服务器仍在运行 (PID: $($_.Id))" -ForegroundColor Yellow
    }
}
if (-not $mcpFound) {
    Write-Host "  [√] MCP 服务器已停止" -ForegroundColor Green
}

Write-Host ""
Write-Host "完成时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ""
