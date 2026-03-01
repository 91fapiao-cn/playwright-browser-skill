# 检查 OpenClaw Gateway 和 MCP 服务器状态

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "OpenClaw Gateway & MCP 状态检查" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. 检查 Gateway 端口
Write-Host "[1/3] 检查 OpenClaw Gateway (端口 18789)..." -ForegroundColor Yellow
$portCheck = netstat -ano | findstr ":18789"
if ($portCheck) {
    Write-Host "  [√] Gateway 正在运行" -ForegroundColor Green
    Write-Host "      端口 18789 已监听" -ForegroundColor Gray
    
    # 提取 PID（避免覆盖 $PID 变量）
    $lines = $portCheck -split "`n"
    foreach ($line in $lines) {
        if ($line -match "LISTENING") {
            $parts = $line -split '\s+' | Where-Object { $_ -ne '' }
            $processPid = $parts[-1]
            Write-Host "      进程 PID: $processPid" -ForegroundColor Gray
            break
        }
    }
} else {
    Write-Host "  [X] Gateway 未运行" -ForegroundColor Red
    Write-Host "      端口 18789 未监听" -ForegroundColor Gray
    Write-Host ""
    Write-Host "请先启动 OpenClaw Gateway：" -ForegroundColor Yellow
    Write-Host "  方法 1: 运行 'openclaw gateway'" -ForegroundColor Gray
    Write-Host "  方法 2: 运行 'openclaw tui'" -ForegroundColor Gray
    Write-Host "  方法 3: 手动启动 OpenClaw 应用程序" -ForegroundColor Gray
    exit 1
}
Write-Host ""

# 2. 检查 MCP 服务器进程
Write-Host "[2/3] 检查 MCP 服务器进程..." -ForegroundColor Yellow
$mcpFound = $false
$nodeProcs = Get-Process node -ErrorAction SilentlyContinue

if ($nodeProcs) {
    foreach ($proc in $nodeProcs) {
        try {
            $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($proc.Id)").CommandLine
            
            if ($cmdLine -like "*mcp-server.js*") {
                $mcpFound = $true
                Write-Host "  [√] MCP 服务器正在运行" -ForegroundColor Green
                Write-Host "      PID: $($proc.Id)" -ForegroundColor Gray
                Write-Host "      启动时间: $($proc.StartTime)" -ForegroundColor Gray
                Write-Host "      命令行: $cmdLine" -ForegroundColor Gray
                break
            }
        } catch {
            # 忽略错误
        }
    }
}

if (-not $mcpFound) {
    Write-Host "  [X] MCP 服务器未运行" -ForegroundColor Red
}
Write-Host ""

# 3. 检查配置文件
Write-Host "[3/3] 检查配置文件..." -ForegroundColor Yellow
$mcpConfigPath = "C:\Users\Administrator\.openclaw\settings\mcp.json"
$openclawConfigPath = "C:\Users\Administrator\.openclaw\openclaw.json"

# 检查 mcp.json
if (Test-Path $mcpConfigPath) {
    $mcpConfig = Get-Content $mcpConfigPath -Raw | ConvertFrom-Json
    $pbConfig = $mcpConfig.mcpServers.'playwright-browser'
    
    Write-Host "  mcp.json:" -ForegroundColor Gray
    Write-Host "    - disabled: $($pbConfig.disabled)" -ForegroundColor Gray
    Write-Host "    - command: $($pbConfig.command)" -ForegroundColor Gray
    Write-Host "    - args[0]: $($pbConfig.args[0])" -ForegroundColor Gray
    
    # 验证文件存在
    $mcpServerPath = $pbConfig.args[0]
    if (Test-Path $mcpServerPath) {
        Write-Host "    - 文件存在: ✓" -ForegroundColor Green
    } else {
        Write-Host "    - 文件存在: ✗ (路径错误)" -ForegroundColor Red
    }
} else {
    Write-Host "  [X] mcp.json 不存在" -ForegroundColor Red
}

# 检查 openclaw.json
if (Test-Path $openclawConfigPath) {
    $openclawConfig = Get-Content $openclawConfigPath -Raw | ConvertFrom-Json
    
    Write-Host "  openclaw.json:" -ForegroundColor Gray
    if ($openclawConfig.skills.entries.'playwright-browser-skill') {
        $enabled = $openclawConfig.skills.entries.'playwright-browser-skill'.enabled
        Write-Host "    - playwright-browser-skill.enabled: $enabled" -ForegroundColor Gray
    } else {
        Write-Host "    - playwright-browser-skill: 未配置" -ForegroundColor Yellow
    }
} else {
    Write-Host "  [X] openclaw.json 不存在" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "总结" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($mcpFound) {
    Write-Host "[√] 一切正常！MCP 服务器正在运行" -ForegroundColor Green
    Write-Host ""
    Write-Host "下一步：在 OpenClaw 对话中测试功能" -ForegroundColor Cyan
    Write-Host "  输入：请列出所有可用的 MCP 工具" -ForegroundColor Gray
    Write-Host "  或者：使用浏览器打开 https://example.com" -ForegroundColor Gray
} else {
    Write-Host "[!] Gateway 运行中，但 MCP 服务器未启动" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "可能的原因：" -ForegroundColor Yellow
    Write-Host "  1. OpenClaw 不会自动启动 MCP 服务器" -ForegroundColor Gray
    Write-Host "  2. 配置文件在 Gateway 启动后才修改" -ForegroundColor Gray
    Write-Host "  3. 需要重启 Gateway 才能加载新配置" -ForegroundColor Gray
    Write-Host ""
    Write-Host "建议的解决方案：" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "方案 A：重启 Gateway（推荐）" -ForegroundColor Yellow
    Write-Host "  1. 停止 Gateway：" -ForegroundColor Gray
    Write-Host "     Get-Process | Where-Object {`$_.ProcessName -like '*openclaw*'} | Stop-Process -Force" -ForegroundColor Gray
    Write-Host "  2. 等待 5 秒" -ForegroundColor Gray
    Write-Host "  3. 重新启动：openclaw gateway" -ForegroundColor Gray
    Write-Host "  4. 等待 15 秒后再次运行此脚本检查" -ForegroundColor Gray
    Write-Host ""
    Write-Host "方案 B：手动启动 MCP 服务器（测试用）" -ForegroundColor Yellow
    Write-Host "  运行：.\test-mcp-manual-start.ps1" -ForegroundColor Gray
    Write-Host "  注意：这只是临时测试，不是永久解决方案" -ForegroundColor Gray
    Write-Host ""
    Write-Host "方案 C：直接测试功能" -ForegroundColor Yellow
    Write-Host "  在 OpenClaw 对话中直接尝试使用浏览器功能" -ForegroundColor Gray
    Write-Host "  如果能用，说明 MCP 已经通过其他方式加载" -ForegroundColor Gray
}

Write-Host ""
Write-Host "检查时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ""
