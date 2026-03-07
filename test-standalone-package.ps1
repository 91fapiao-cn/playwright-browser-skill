# 测试独立压缩包部署脚本
# 模拟在全新环境中解压和部署

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "独立压缩包部署测试" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 测试目标
$testDir = "test-deployment"
$packageDir = "releases\playwright-browser-skill-windows-v2.1.0"

# 步骤 1: 检查压缩包结构
Write-Host "[1/5] 检查压缩包结构..." -ForegroundColor Yellow

$requiredFiles = @(
    "$packageDir\skill-package\skills\SKILL.md",
    "$packageDir\skill-package\settings\mcp.json",
    "$packageDir\dist\mcp-server.js",
    "$packageDir\dist\index.js",
    "$packageDir\node_modules\playwright",
    "$packageDir\package.json"
)

$allExist = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "  [√] $(Split-Path $file -Leaf)" -ForegroundColor Green
    } else {
        Write-Host "  [X] 缺失: $file" -ForegroundColor Red
        $allExist = $false
    }
}

if (-not $allExist) {
    Write-Host "[X] 压缩包结构不完整" -ForegroundColor Red
    exit 1
}

Write-Host "[√] 压缩包结构完整" -ForegroundColor Green
Write-Host ""

# 步骤 2: 检查 mcp.json 配置
Write-Host "[2/5] 检查 mcp.json 配置..." -ForegroundColor Yellow

$mcpConfigPath = "$packageDir\skill-package\settings\mcp.json"
$mcpConfig = Get-Content $mcpConfigPath -Raw | ConvertFrom-Json

$configuredPath = $mcpConfig.mcpServers."playwright-browser".args[0]
Write-Host "  配置的路径: $configuredPath" -ForegroundColor Gray

if ($configuredPath -match "^[A-Z]:\\") {
    Write-Host "  [!] 警告: 使用了绝对路径,不利于跨环境部署" -ForegroundColor Yellow
    Write-Host "  [!] 建议: 使用相对路径或在部署时动态生成" -ForegroundColor Yellow
} else {
    Write-Host "  [√] 使用相对路径" -ForegroundColor Green
}
Write-Host ""

# 步骤 3: 测试 MCP 服务器启动
Write-Host "[3/5] 测试 MCP 服务器启动..." -ForegroundColor Yellow

$mcpServerPath = "$packageDir\dist\mcp-server.js"
if (Test-Path $mcpServerPath) {
    Write-Host "  [√] MCP 服务器文件存在" -ForegroundColor Green
    
    # 尝试启动服务器(5秒后自动关闭)
    Write-Host "  [*] 尝试启动 MCP 服务器..." -ForegroundColor Gray
    
    $job = Start-Job -ScriptBlock {
        param($serverPath)
        Set-Location (Split-Path $serverPath -Parent)
        node $serverPath
    } -ArgumentList (Resolve-Path $mcpServerPath).Path
    
    Start-Sleep -Seconds 3
    
    if ($job.State -eq "Running") {
        Write-Host "  [√] MCP 服务器启动成功" -ForegroundColor Green
        Stop-Job $job
        Remove-Job $job
    } else {
        Write-Host "  [X] MCP 服务器启动失败" -ForegroundColor Red
        Receive-Job $job
        Remove-Job $job
    }
} else {
    Write-Host "  [X] MCP 服务器文件不存在" -ForegroundColor Red
}
Write-Host ""

# 步骤 4: 检查依赖完整性
Write-Host "[4/5] 检查依赖完整性..." -ForegroundColor Yellow

$criticalDeps = @(
    "$packageDir\node_modules\playwright",
    "$packageDir\node_modules\@modelcontextprotocol",
    "$packageDir\node_modules\zod"
)

$depsOk = $true
foreach ($dep in $criticalDeps) {
    $depName = Split-Path $dep -Leaf
    if (Test-Path $dep) {
        Write-Host "  [√] $depName" -ForegroundColor Green
    } else {
        Write-Host "  [X] 缺失: $depName" -ForegroundColor Red
        $depsOk = $false
    }
}

if ($depsOk) {
    Write-Host "[√] 所有关键依赖完整" -ForegroundColor Green
} else {
    Write-Host "[X] 部分依赖缺失" -ForegroundColor Red
}
Write-Host ""

# 步骤 5: 生成部署报告
Write-Host "[5/5] 生成部署报告..." -ForegroundColor Yellow

$packageSize = (Get-ChildItem $packageDir -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
$fileCount = (Get-ChildItem $packageDir -Recurse -File).Count

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "部署测试报告" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "压缩包信息:" -ForegroundColor Cyan
Write-Host "  路径: $packageDir" -ForegroundColor White
Write-Host "  大小: $([math]::Round($packageSize, 2)) MB" -ForegroundColor White
Write-Host "  文件数: $fileCount" -ForegroundColor White
Write-Host ""

Write-Host "结构检查:" -ForegroundColor Cyan
if ($allExist) {
    Write-Host "  ✅ 所有必需文件完整" -ForegroundColor Green
} else {
    Write-Host "  ❌ 部分文件缺失" -ForegroundColor Red
}
Write-Host ""

Write-Host "配置检查:" -ForegroundColor Cyan
if ($configuredPath -match "^[A-Z]:\\") {
    Write-Host "  ⚠️  mcp.json 使用绝对路径" -ForegroundColor Yellow
    Write-Host "     当前路径: $configuredPath" -ForegroundColor Gray
    Write-Host "     建议: 部署时动态生成配置" -ForegroundColor Gray
} else {
    Write-Host "  ✅ mcp.json 配置正确" -ForegroundColor Green
}
Write-Host ""

Write-Host "依赖检查:" -ForegroundColor Cyan
if ($depsOk) {
    Write-Host "  ✅ 所有依赖完整" -ForegroundColor Green
} else {
    Write-Host "  ❌ 部分依赖缺失" -ForegroundColor Red
}
Write-Host ""

Write-Host "部署建议:" -ForegroundColor Cyan
Write-Host "  1. 使用 auto-deploy-en.ps1 脚本进行部署" -ForegroundColor White
Write-Host "  2. 脚本会自动检测 OpenClaw 路径" -ForegroundColor White
Write-Host "  3. 脚本会动态生成正确的 mcp.json 配置" -ForegroundColor White
Write-Host "  4. 确保目标环境已安装 Node.js" -ForegroundColor White
Write-Host ""

Write-Host "快速部署命令:" -ForegroundColor Cyan
Write-Host "  .\auto-deploy-en.ps1 -SkipBuild" -ForegroundColor Yellow
Write-Host ""

# 问题总结
Write-Host "发现的问题:" -ForegroundColor Yellow
Write-Host "  1. mcp.json 中的路径是硬编码的绝对路径" -ForegroundColor Red
Write-Host "     - 当前: $configuredPath" -ForegroundColor Gray
Write-Host "     - 影响: 无法在其他环境直接使用" -ForegroundColor Gray
Write-Host "     - 解决: 使用部署脚本动态生成配置" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Green
Write-Host "测试完成" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
