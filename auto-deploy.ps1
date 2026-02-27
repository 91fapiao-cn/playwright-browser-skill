# Playwright Browser Skill - 自动部署脚本 (Windows/Mac)
# 自动检测 OpenClaw 路径并完成部署

param(
    [string]$OpenClawPath = "",
    [switch]$SkipBuild = $false
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Playwright Browser Skill - 自动部署" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 函数：检测 OpenClaw 安装路径
function Find-OpenClawPath {
    Write-Host "[*] 正在检测 OpenClaw 安装路径..." -ForegroundColor Yellow
    
    # 常见的 OpenClaw 配置路径
    $possiblePaths = @(
        "$env:USERPROFILE\.openclaw",           # Windows 默认
        "$env:USERPROFILE\.kiro",               # Kiro 默认
        "$HOME/.openclaw",                       # Mac/Linux 默认
        "$HOME/.kiro",                           # Kiro Mac/Linux
        "$env:APPDATA\openclaw",                # Windows AppData
        "$env:LOCALAPPDATA\openclaw"            # Windows LocalAppData
    )
    
    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            Write-Host "[√] 找到 OpenClaw 配置目录：$path" -ForegroundColor Green
            return $path
        }
    }
    
    # 如果都没找到，使用默认路径
    $defaultPath = if ($IsWindows -or $env:OS -match "Windows") {
        "$env:USERPROFILE\.openclaw"
    } else {
        "$HOME/.openclaw"
    }
    
    Write-Host "[!] 未找到现有配置，将使用默认路径：$defaultPath" -ForegroundColor Yellow
    return $defaultPath
}

# 函数：确保目录存在
function Ensure-Directory {
    param([string]$Path)
    
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Host "  [+] 创建目录：$Path" -ForegroundColor Gray
    }
}

# 步骤 0：检查项目目录
Write-Host "[0/5] 检查项目环境..." -ForegroundColor Yellow

if (-not (Test-Path "skill-package\skills\playwright-browser.md")) {
    Write-Host "[X] 错误：请在项目根目录运行此脚本" -ForegroundColor Red
    Write-Host "    当前目录：$(Get-Location)" -ForegroundColor Gray
    exit 1
}

$projectPath = (Get-Location).Path
Write-Host "[√] 项目目录：$projectPath" -ForegroundColor Green
Write-Host ""

# 步骤 1：构建项目
if (-not $SkipBuild) {
    Write-Host "[1/5] 构建项目..." -ForegroundColor Yellow
    
    if (-not (Test-Path "package.json")) {
        Write-Host "[X] 错误：未找到 package.json" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "  执行：npm run build" -ForegroundColor Gray
    npm run build
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[X] 构建失败" -ForegroundColor Red
        exit 1
    }
    
    if (-not (Test-Path "dist\mcp-server.js")) {
        Write-Host "[X] 错误：构建产物不存在 (dist\mcp-server.js)" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "[√] 项目构建成功" -ForegroundColor Green
} else {
    Write-Host "[1/5] 跳过构建（使用 -SkipBuild 参数）" -ForegroundColor Gray
    
    if (-not (Test-Path "dist\mcp-server.js")) {
        Write-Host "[X] 错误：dist\mcp-server.js 不存在，请先构建项目" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# 步骤 2：检测 OpenClaw 路径
Write-Host "[2/5] 检测 OpenClaw 配置路径..." -ForegroundColor Yellow

$openclawDir = if ($OpenClawPath) {
    Write-Host "  使用指定路径：$OpenClawPath" -ForegroundColor Gray
    $OpenClawPath
} else {
    Find-OpenClawPath
}

$settingsDir = Join-Path $openclawDir "settings"
$skillsDir = Join-Path $openclawDir "skills"
$skillDir = Join-Path $skillsDir "playwright-browser"

Write-Host "[√] OpenClaw 配置目录：$openclawDir" -ForegroundColor Green
Write-Host ""

# 步骤 3：创建目录结构
Write-Host "[3/5] 准备目录结构..." -ForegroundColor Yellow

Ensure-Directory $openclawDir
Ensure-Directory $settingsDir
Ensure-Directory $skillsDir
Ensure-Directory $skillDir

Write-Host "[√] 目录结构已就绪" -ForegroundColor Green
Write-Host ""

# 步骤 4：部署 Skill 文件
Write-Host "[4/5] 部署 Skill 文件..." -ForegroundColor Yellow

$sourceFile = "skill-package\skills\playwright-browser.md"
$targetFile = Join-Path $skillDir "playwright-browser.md"

try {
    Copy-Item $sourceFile $targetFile -Force
    Write-Host "[√] Skill 文件已部署" -ForegroundColor Green
    Write-Host "    源文件：$sourceFile" -ForegroundColor Gray
    Write-Host "    目标位置：$targetFile" -ForegroundColor Gray
} catch {
    Write-Host "[X] Skill 文件部署失败：$_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 步骤 5：配置 MCP
Write-Host "[5/5] 配置 MCP 服务器..." -ForegroundColor Yellow

$mcpConfigPath = Join-Path $settingsDir "mcp.json"

# 规范化路径（Windows 使用反斜杠，JSON 需要转义）
$distPath = Join-Path $projectPath "dist\mcp-server.js"
$distPathJson = $distPath -replace '\\', '\\'

# 创建 MCP 配置
$mcpConfig = @{
    mcpServers = @{
        "playwright-browser" = @{
            command = "node"
            args = @($distPath)
            env = @{}
            disabled = $false
            autoApprove = @(
                "browser_launch",
                "browser_goto",
                "browser_get_title",
                "browser_get_text",
                "browser_get_html",
                "browser_get_links",
                "browser_get_cookies",
                "browser_close"
            )
        }
    }
}

# 如果配置文件已存在，合并配置
if (Test-Path $mcpConfigPath) {
    Write-Host "  [!] 检测到现有 MCP 配置" -ForegroundColor Yellow
    
    try {
        $existingConfig = Get-Content $mcpConfigPath -Raw | ConvertFrom-Json
        
        # 备份现有配置
        $backupPath = "$mcpConfigPath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Copy-Item $mcpConfigPath $backupPath -Force
        Write-Host "  [√] 已备份到：$backupPath" -ForegroundColor Gray
        
        # 合并配置
        if (-not $existingConfig.mcpServers) {
            $existingConfig | Add-Member -MemberType NoteProperty -Name "mcpServers" -Value @{} -Force
        }
        
        $existingConfig.mcpServers | Add-Member -MemberType NoteProperty -Name "playwright-browser" -Value $mcpConfig.mcpServers."playwright-browser" -Force
        
        $existingConfig | ConvertTo-Json -Depth 10 | Set-Content $mcpConfigPath -Encoding UTF8
        Write-Host "  [√] 已合并到现有配置" -ForegroundColor Green
        
    } catch {
        Write-Host "  [!] 无法解析现有配置，将覆盖" -ForegroundColor Yellow
        $mcpConfig | ConvertTo-Json -Depth 10 | Set-Content $mcpConfigPath -Encoding UTF8
    }
} else {
    # 创建新配置
    $mcpConfig | ConvertTo-Json -Depth 10 | Set-Content $mcpConfigPath -Encoding UTF8
    Write-Host "  [√] 已创建新配置文件" -ForegroundColor Green
}

Write-Host "[√] MCP 配置完成" -ForegroundColor Green
Write-Host "    配置文件：$mcpConfigPath" -ForegroundColor Gray
Write-Host ""

# 完成
Write-Host "========================================" -ForegroundColor Green
Write-Host "部署完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "部署摘要：" -ForegroundColor Cyan
Write-Host "  OpenClaw 配置：$openclawDir" -ForegroundColor White
Write-Host "  Skill 文件：$targetFile" -ForegroundColor White
Write-Host "  MCP 配置：$mcpConfigPath" -ForegroundColor White
Write-Host "  MCP 服务器：$distPath" -ForegroundColor White
Write-Host ""

Write-Host "下一步：" -ForegroundColor Yellow
Write-Host "  1. 重启 OpenClaw/Kiro" -ForegroundColor White
Write-Host "  2. 在聊天中测试：'启动浏览器并访问 example.com'" -ForegroundColor White
Write-Host "  3. 查看 MCP 服务器状态（应显示 playwright-browser）" -ForegroundColor White
Write-Host ""

Write-Host "使用说明：" -ForegroundColor Cyan
Write-Host "  默认部署：  .\auto-deploy.ps1" -ForegroundColor Gray
Write-Host "  跳过构建：  .\auto-deploy.ps1 -SkipBuild" -ForegroundColor Gray
Write-Host "  指定路径：  .\auto-deploy.ps1 -OpenClawPath 'C:\custom\path'" -ForegroundColor Gray
Write-Host ""
