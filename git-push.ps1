# Git 推送辅助脚本
# 用于首次推送到 GitHub

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Git 推送辅助脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否已配置 Git 用户信息
$userName = git config user.name
$userEmail = git config user.email

if (-not $userName -or -not $userEmail) {
    Write-Host "[!] 需要配置 Git 用户信息" -ForegroundColor Yellow
    Write-Host ""
    
    $name = Read-Host "请输入你的名字"
    $email = Read-Host "请输入你的邮箱"
    
    git config --global user.name "$name"
    git config --global user.email "$email"
    
    Write-Host "[√] Git 用户信息已配置" -ForegroundColor Green
    Write-Host "    用户名: $name" -ForegroundColor Gray
    Write-Host "    邮箱: $email" -ForegroundColor Gray
} else {
    Write-Host "[√] Git 用户信息已配置" -ForegroundColor Green
    Write-Host "    用户名: $userName" -ForegroundColor Gray
    Write-Host "    邮箱: $userEmail" -ForegroundColor Gray
}

Write-Host ""

# 检查是否有未提交的更改
$status = git status --porcelain
if ($status) {
    Write-Host "[1/4] 提交更改..." -ForegroundColor Cyan
    
    git add .
    git commit -m "feat: 初始提交 - Playwright Browser Skill v2.0.0

- 完整的88个浏览器自动化工具
- 支持Chromium、Firefox、WebKit
- 完整的中文文档和使用示例
- Windows平台完全支持
- MCP协议集成
- 自动化部署脚本
- 完整的测试套件"
    
    Write-Host "[√] 更改已提交" -ForegroundColor Green
} else {
    Write-Host "[√] 没有需要提交的更改" -ForegroundColor Green
}

Write-Host ""

# 检查是否已配置远程仓库
$remote = git remote get-url origin 2>$null
if (-not $remote) {
    Write-Host "[2/4] 配置远程仓库..." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "请先在 GitHub 上创建仓库：" -ForegroundColor Yellow
    Write-Host "1. 访问 https://github.com/new" -ForegroundColor Gray
    Write-Host "2. 仓库名称: playwright-browser-skill" -ForegroundColor Gray
    Write-Host "3. 不要勾选 'Initialize this repository with a README'" -ForegroundColor Gray
    Write-Host ""
    
    $username = Read-Host "请输入你的 GitHub 用户名"
    $repoUrl = "https://github.com/$username/playwright-browser-skill.git"
    
    Write-Host ""
    Write-Host "将使用以下仓库地址：" -ForegroundColor Gray
    Write-Host "  $repoUrl" -ForegroundColor Gray
    Write-Host ""
    
    $confirm = Read-Host "确认无误？(y/n)"
    if ($confirm -eq 'y' -or $confirm -eq 'Y') {
        git remote add origin $repoUrl
        Write-Host "[√] 远程仓库已配置" -ForegroundColor Green
    } else {
        Write-Host "[!] 已取消" -ForegroundColor Yellow
        exit
    }
} else {
    Write-Host "[√] 远程仓库已配置: $remote" -ForegroundColor Green
}

Write-Host ""

# 推送到 GitHub
Write-Host "[3/4] 推送到 GitHub..." -ForegroundColor Cyan
Write-Host ""
Write-Host "即将推送到远程仓库..." -ForegroundColor Yellow
Write-Host "如果是首次推送，可能需要输入 GitHub 凭据" -ForegroundColor Gray
Write-Host ""

$push = Read-Host "继续推送？(y/n)"
if ($push -eq 'y' -or $push -eq 'Y') {
    # 尝试推送
    git branch -M main
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[√] 推送成功！" -ForegroundColor Green
    } else {
        Write-Host "[!] 推送失败" -ForegroundColor Red
        Write-Host ""
        Write-Host "可能的原因：" -ForegroundColor Yellow
        Write-Host "1. 远程仓库不存在" -ForegroundColor Gray
        Write-Host "2. 认证失败（需要 Personal Access Token）" -ForegroundColor Gray
        Write-Host "3. 网络问题" -ForegroundColor Gray
        Write-Host ""
        Write-Host "请查看 GIT_SETUP.md 获取详细帮助" -ForegroundColor Cyan
        exit 1
    }
} else {
    Write-Host "[!] 已取消推送" -ForegroundColor Yellow
    exit
}

Write-Host ""

# 完成
Write-Host "[4/4] 完成！" -ForegroundColor Cyan
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "推送完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "下一步：" -ForegroundColor Cyan
Write-Host "1. 访问你的 GitHub 仓库验证文件" -ForegroundColor Gray
Write-Host "2. 添加仓库描述和 topics" -ForegroundColor Gray
Write-Host "3. 更新 README.md 中的链接" -ForegroundColor Gray
Write-Host ""
Write-Host "仓库地址：" -ForegroundColor Cyan
$remote = git remote get-url origin
Write-Host "  $($remote -replace '\.git$', '')" -ForegroundColor Gray
Write-Host ""
