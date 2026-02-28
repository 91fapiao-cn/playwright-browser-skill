# ============================================
# Playwright Browser Skill - Windows 发行版打包脚本
# ============================================

param(
    [string]$Version = "2.1.0"
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Playwright Browser Skill" -ForegroundColor Cyan
Write-Host "  Windows 发行版打包工具" -ForegroundColor Cyan
Write-Host "  版本: $Version" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. 检查环境
Write-Host "[1/7] 检查构建环境..." -ForegroundColor Yellow

if (-not (Test-Path "package.json")) {
    Write-Host "错误: 请在项目根目录运行此脚本" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "dist")) {
    Write-Host "提示: dist 目录不存在，将自动构建项目" -ForegroundColor Yellow
    npm run build
    if ($LASTEXITCODE -ne 0) {
        Write-Host "错误: 项目构建失败" -ForegroundColor Red
        exit 1
    }
}

# 2. 创建发行版目录
$ReleaseName = "playwright-browser-skill-windows-v$Version"
$ReleaseDir = "releases\$ReleaseName"

Write-Host "[2/7] 创建发行版目录: $ReleaseDir" -ForegroundColor Yellow

if (Test-Path "releases") {
    Remove-Item "releases" -Recurse -Force
}
New-Item -ItemType Directory -Path $ReleaseDir -Force | Out-Null

# 3. 复制核心文件
Write-Host "[3/7] 复制核心文件..." -ForegroundColor Yellow

# 复制 dist 目录
Copy-Item "dist" -Destination "$ReleaseDir\dist" -Recurse

# 复制 node_modules
Write-Host "    - 复制 node_modules (这可能需要几分钟)..." -ForegroundColor Gray
Copy-Item "node_modules" -Destination "$ReleaseDir\node_modules" -Recurse

# 复制 skill 文件
New-Item -ItemType Directory -Path "$ReleaseDir\skill-package\skills" -Force | Out-Null
Copy-Item "skill-package\skills\playwright-browser.md" -Destination "$ReleaseDir\skill-package\skills\"

# 复制配置示例
New-Item -ItemType Directory -Path "$ReleaseDir\skill-package\settings" -Force | Out-Null
Copy-Item "skill-package\settings\mcp.json" -Destination "$ReleaseDir\skill-package\settings\"

# 4. 复制文档
Write-Host "[4/7] 复制文档文件..." -ForegroundColor Yellow

$Docs = @(
    "README.md",
    "README_EN.md",
    "LICENSE",
    "WINDOWS_GUIDE.md",
    "QUICK_START_WINDOWS.md",
    "CONFIGURATION_GUIDE.md",
    "AUTO_DEPLOY_README.md",
    "AUTO_DEPLOY_README_EN.md"
)

foreach ($doc in $Docs) {
    if (Test-Path $doc) {
        Copy-Item $doc -Destination $ReleaseDir
    }
}

# 5. 复制部署脚本
Write-Host "[5/7] 复制部署脚本..." -ForegroundColor Yellow

$Scripts = @(
    "auto-deploy.ps1",
    "auto-deploy-en.ps1",
    "auto-deploy.cmd",
    "auto-deploy-en.cmd"
)

foreach ($script in $Scripts) {
    if (Test-Path $script) {
        Copy-Item $script -Destination $ReleaseDir
    }
}

# 6. 创建简化的 package.json
Write-Host "[6/7] 创建发行版配置文件..." -ForegroundColor Yellow

$PackageJson = @{
    name = "playwright-browser-skill"
    version = $Version
    description = "A powerful browser automation skill for OpenClaw"
    main = "dist/index.js"
    type = "module"
    author = "91fapiao <91fapiao@gmail.com>"
    license = "MIT"
    engines = @{
        node = ">=18.0.0"
    }
} | ConvertTo-Json -Depth 10

$PackageJson | Out-File -FilePath "$ReleaseDir\package.json" -Encoding UTF8

# 7. 创建安装说明
Write-Host "[7/7] 创建安装说明..." -ForegroundColor Yellow

$InstallGuide = @"
# Playwright Browser Skill for OpenClaw - Windows 版本
版本: $Version

## 快速安装

### 方法一：自动部署（推荐）

1. 解压此文件到任意目录
2. 在此目录打开 PowerShell
3. 运行部署脚本：

``````powershell
.\auto-deploy.ps1
``````

或使用英文版本：

``````powershell
.\auto-deploy-en.ps1
``````

### 方法二：手动部署

1. 复制整个文件夹到：
   ``````
   C:\Users\你的用户名\.openclaw\skills\playwright-browser\
   ``````

2. 编辑配置文件：
   ``````
   C:\Users\你的用户名\.openclaw\settings\mcp.json
   ``````

3. 添加以下配置：
   ``````json
   {
     "mcpServers": {
       "playwright-browser": {
         "command": "node",
         "args": ["C:\\Users\\你的用户名\\.openclaw\\skills\\playwright-browser\\dist\\mcp-server.js"],
         "disabled": false
       }
     }
   }
   ``````

4. 重启 OpenClaw

## 使用说明

部署完成后，在 OpenClaw 对话中输入：

``````
请使用 Playwright Browser Skill 技能来访问互联网和控制浏览器
``````

然后就可以使用浏览器相关功能了！

## 包含内容

- ✅ 编译后的代码 (dist/)
- ✅ 完整依赖包 (node_modules/)
- ✅ 技能文档 (skill-package/)
- ✅ 自动部署脚本
- ✅ 完整文档

## 系统要求

- Windows 10/11
- Node.js 18 或更高版本

## 支持

- 📧 Email: 91fapiao@gmail.com
- 🐛 Issues: https://github.com/91fapiao-cn/playwright-browser-skill/issues
- 📚 文档: 查看 README.md

---
**Made with ❤️ for OpenClaw Community**
"@

$InstallGuide | Out-File -FilePath "$ReleaseDir\INSTALL.md" -Encoding UTF8

# 8. 压缩发行版
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  打包完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "发行版位置: $ReleaseDir" -ForegroundColor Cyan
Write-Host ""

# 计算大小
$Size = (Get-ChildItem $ReleaseDir -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
Write-Host "包大小: $([math]::Round($Size, 2)) MB" -ForegroundColor Cyan
Write-Host ""

# 询问是否创建 ZIP
$CreateZip = Read-Host "是否创建 ZIP 压缩包？(y/n)"
if ($CreateZip -eq "y" -or $CreateZip -eq "Y") {
    Write-Host ""
    Write-Host "正在创建 ZIP 压缩包..." -ForegroundColor Yellow
    
    $ZipPath = "releases\$ReleaseName.zip"
    Compress-Archive -Path $ReleaseDir -DestinationPath $ZipPath -Force
    
    $ZipSize = (Get-Item $ZipPath).Length / 1MB
    Write-Host ""
    Write-Host "ZIP 文件已创建: $ZipPath" -ForegroundColor Green
    Write-Host "ZIP 大小: $([math]::Round($ZipSize, 2)) MB" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  可以发布了！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
