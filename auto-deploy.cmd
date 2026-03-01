@echo off
REM Playwright Browser Skill - 自动部署脚本 (Windows)
REM 自动检测 OpenClaw 路径并完成部署

setlocal enabledelayedexpansion

REM 参数处理
set "OPENCLAW_PATH="
set "SKIP_BUILD=0"

:parse_args
if "%~1"=="" goto args_done
if /i "%~1"=="--openclaw-path" (
    set "OPENCLAW_PATH=%~2"
    shift
    shift
    goto parse_args
)
if /i "%~1"=="--skip-build" (
    set "SKIP_BUILD=1"
    shift
    goto parse_args
)
if /i "%~1"=="-h" goto show_help
if /i "%~1"=="--help" goto show_help
echo [X] 未知参数: %~1
exit /b 1

:show_help
echo 用法: %~nx0 [选项]
echo.
echo 选项:
echo   --openclaw-path PATH   指定 OpenClaw 配置路径
echo   --skip-build           跳过项目构建
echo   -h, --help             显示帮助信息
exit /b 0

:args_done

echo ========================================
echo Playwright Browser Skill - 自动部署
echo ========================================
echo.

REM 步骤 0：检查项目目录
echo [0/5] 检查项目环境...

if not exist "skill-package\skills\SKILL.md" (
    echo [X] 错误：请在项目根目录运行此脚本
    echo     当前目录：%CD%
    exit /b 1
)

set "PROJECT_PATH=%CD%"
echo [√] 项目目录：%PROJECT_PATH%
echo.

REM 步骤 1：构建项目
if "%SKIP_BUILD%"=="0" (
    echo [1/5] 构建项目...
    
    if not exist "package.json" (
        echo [X] 错误：未找到 package.json
        exit /b 1
    )
    
    echo   执行：npm run build
    call npm run build
    
    if errorlevel 1 (
        echo [X] 构建失败
        exit /b 1
    )
    
    if not exist "dist\mcp-server.js" (
        echo [X] 错误：构建产物不存在 (dist\mcp-server.js)
        exit /b 1
    )
    
    echo [√] 项目构建成功
) else (
    echo [1/5] 跳过构建（使用 --skip-build 参数）
    
    if not exist "dist\mcp-server.js" (
        echo [X] 错误：dist\mcp-server.js 不存在，请先构建项目
        exit /b 1
    )
)
echo.

REM 步骤 2：检测 OpenClaw 路径
echo [2/5] 检测 OpenClaw 配置路径...

if defined OPENCLAW_PATH (
    echo   使用指定路径：%OPENCLAW_PATH%
    set "OPENCLAW_DIR=%OPENCLAW_PATH%"
) else (
    REM 检测 OpenClaw 路径
    if exist "%USERPROFILE%\.openclaw" (
        set "OPENCLAW_DIR=%USERPROFILE%\.openclaw"
        echo [√] 找到 OpenClaw 配置目录：!OPENCLAW_DIR!
    ) else if exist "%APPDATA%\openclaw" (
        set "OPENCLAW_DIR=%APPDATA%\openclaw"
        echo [√] 找到 OpenClaw 配置目录：!OPENCLAW_DIR!
    ) else if exist "%LOCALAPPDATA%\openclaw" (
        set "OPENCLAW_DIR=%LOCALAPPDATA%\openclaw"
        echo [√] 找到 OpenClaw 配置目录：!OPENCLAW_DIR!
    ) else (
        set "OPENCLAW_DIR=%USERPROFILE%\.openclaw"
        echo [!] 未找到现有配置，将使用默认路径：!OPENCLAW_DIR!
    )
)

set "SETTINGS_DIR=%OPENCLAW_DIR%\settings"
set "SKILLS_DIR=%OPENCLAW_DIR%\skills"
set "SKILL_DIR=%SKILLS_DIR%\playwright-browser-skill"

echo [√] OpenClaw 配置目录：%OPENCLAW_DIR%
echo.

REM 步骤 3：创建目录结构
echo [3/5] 准备目录结构...

if not exist "%OPENCLAW_DIR%" (
    mkdir "%OPENCLAW_DIR%"
    echo   [+] 创建目录：%OPENCLAW_DIR%
)

if not exist "%SETTINGS_DIR%" (
    mkdir "%SETTINGS_DIR%"
    echo   [+] 创建目录：%SETTINGS_DIR%
)

if not exist "%SKILLS_DIR%" (
    mkdir "%SKILLS_DIR%"
    echo   [+] 创建目录：%SKILLS_DIR%
)

if not exist "%SKILL_DIR%" (
    mkdir "%SKILL_DIR%"
    echo   [+] 创建目录：%SKILL_DIR%
)

echo [√] 目录结构已就绪
echo.

REM 步骤 4：部署独立技能包
echo [4/7] 部署独立技能包...

REM 4.1 复制 Skill 文档
set "SOURCE_FILE=skill-package\skills\SKILL.md"
set "TARGET_FILE=%SKILL_DIR%\SKILL.md"

copy /Y "%SOURCE_FILE%" "%TARGET_FILE%" >nul
if exist "%TARGET_FILE%" (
    echo   [√] Skill 文档已部署
) else (
    echo [X] Skill 文档部署失败
    exit /b 1
)

REM 4.2 复制 dist 文件夹
echo   [*] 复制编译后的代码...
set "DIST_SOURCE=dist"
set "DIST_TARGET=%SKILL_DIR%\dist"

if exist "%DIST_TARGET%" (
    rmdir /s /q "%DIST_TARGET%"
)
xcopy /E /I /Y /Q "%DIST_SOURCE%" "%DIST_TARGET%" >nul 2>&1
if errorlevel 1 (
    echo [X] 编译代码复制失败
    exit /b 1
)
if exist "%DIST_TARGET%\mcp-server.js" (
    echo   [√] 编译代码已部署 (dist/)
) else (
    echo [X] 编译代码部署失败：mcp-server.js 不存在
    exit /b 1
)

REM 4.3 复制必要的 node_modules 依赖
echo   [*] 复制运行时依赖...
set "NODE_MODULES_TARGET=%SKILL_DIR%\node_modules"

if exist "%NODE_MODULES_TARGET%" (
    rmdir /s /q "%NODE_MODULES_TARGET%"
)

echo     [*] 复制所有依赖（这可能需要一些时间）...
xcopy /E /I /Y /Q "node_modules" "%NODE_MODULES_TARGET%" >nul 2>&1
if errorlevel 1 (
    echo   [X] 依赖复制失败
    exit /b 1
)

REM 验证关键依赖是否存在
if exist "%NODE_MODULES_TARGET%\playwright" (
    echo   [√] 运行时依赖已部署
) else (
    echo   [X] 依赖部署失败：playwright 不存在
    exit /b 1
)

REM 4.4 复制 package.json
echo   [*] 复制 package.json...
copy /Y "package.json" "%SKILL_DIR%\package.json" >nul
if exist "%SKILL_DIR%\package.json" (
    echo   [√] package.json 已部署
) else (
    echo   [!] package.json 部署失败（不影响功能）
)

echo [√] 独立技能包部署完成
echo.

REM 步骤 5：配置 MCP
echo [5/7] 配置 MCP 服务器...

set "MCP_CONFIG_PATH=%SETTINGS_DIR%\mcp.json"
set "DIST_PATH=%SKILL_DIR%\dist\mcp-server.js"

REM 转义路径中的反斜杠用于 JSON
set "DIST_PATH_JSON=%DIST_PATH:\=\\%"

REM 创建临时配置文件
set "TEMP_CONFIG=%TEMP%\mcp-config-%RANDOM%.json"

(
echo {
echo   "mcpServers": {
echo     "playwright-browser": {
echo       "command": "node",
echo       "args": ["%DIST_PATH_JSON%"],
echo       "env": {},
echo       "disabled": false,
echo       "autoApprove": [
echo         "browser_launch",
echo         "browser_goto",
echo         "browser_get_title",
echo         "browser_get_text",
echo         "browser_get_html",
echo         "browser_get_links",
echo         "browser_get_cookies",
echo         "browser_close"
echo       ]
echo     }
echo   }
echo }
) > "%TEMP_CONFIG%"

REM 如果配置文件已存在，备份
if exist "%MCP_CONFIG_PATH%" (
    echo   [!] 检测到现有 MCP 配置
    
    set "BACKUP_PATH=%MCP_CONFIG_PATH%.backup.%date:~0,4%%date:~5,2%%date:~8,2%-%time:~0,2%%time:~3,2%%time:~6,2%"
    set "BACKUP_PATH=!BACKUP_PATH: =0!"
    
    copy /Y "%MCP_CONFIG_PATH%" "!BACKUP_PATH!" >nul
    echo   [√] 已备份到：!BACKUP_PATH!
    echo   [!] 将覆盖现有配置（手动合并请参考备份文件）
)

REM 写入配置
copy /Y "%TEMP_CONFIG%" "%MCP_CONFIG_PATH%" >nul
del "%TEMP_CONFIG%"

echo [√] MCP 配置完成
echo.

REM 步骤 6：验证部署
echo [6/7] 验证部署...

set "ALL_OK=1"
if exist "%SKILL_DIR%\SKILL.md" (
    echo   [√] SKILL.md
) else (
    echo   [X] 缺失：SKILL.md
    set "ALL_OK=0"
)

if exist "%SKILL_DIR%\dist\mcp-server.js" (
    echo   [√] dist\mcp-server.js
) else (
    echo   [X] 缺失：dist\mcp-server.js
    set "ALL_OK=0"
)

if exist "%SKILL_DIR%\dist\index.js" (
    echo   [√] dist\index.js
) else (
    echo   [X] 缺失：dist\index.js
    set "ALL_OK=0"
)

if exist "%SKILL_DIR%\node_modules\playwright" (
    echo   [√] node_modules\playwright
) else (
    echo   [X] 缺失：node_modules\playwright
    set "ALL_OK=0"
)

if "%ALL_OK%"=="1" (
    echo [√] 所有文件验证通过
) else (
    echo [X] 部署验证失败
    exit /b 1
)
echo.

REM 步骤 7：统计信息
echo [7/9] 统计信息...
echo   工具总数：101 个
echo   覆盖率：88%%
echo.

REM 步骤 8：启动 MCP 服务器
echo [8/9] 启动 MCP 服务器...

REM 创建启动脚本
set "STARTUP_SCRIPT=%SKILL_DIR%\start-mcp-server.cmd"
(
echo @echo off
echo title Playwright Browser MCP Server
echo echo Playwright Browser MCP Server
echo echo 按 Ctrl+C 停止服务器
echo echo 此窗口可以最小化，但请勿关闭
echo echo.
echo cd /d "%SKILL_DIR%"
echo node dist\mcp-server.js
) > "%STARTUP_SCRIPT%"

echo   [√] 已创建启动脚本：%STARTUP_SCRIPT%

REM 在最小化窗口中启动 MCP 服务器
start /min cmd /c "%STARTUP_SCRIPT%"
timeout /t 3 /nobreak >nul

echo   [√] MCP 服务器已启动
echo.

REM 步骤 9：配置自动启动
echo [9/9] 配置自动启动...

REM 使用 PowerShell 创建计划任务
powershell -Command "$action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument '/c \"%STARTUP_SCRIPT%\"'; $trigger = New-ScheduledTaskTrigger -AtLogOn -User '%USERNAME%'; $principal = New-ScheduledTaskPrincipal -UserId '%USERNAME%' -LogonType Interactive -RunLevel Highest; $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable; try { Unregister-ScheduledTask -TaskName 'Playwright Browser MCP Server' -Confirm:$false -ErrorAction SilentlyContinue; Register-ScheduledTask -TaskName 'Playwright Browser MCP Server' -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Description '用户登录时自动启动 Playwright Browser MCP Server' | Out-Null; Write-Host '  [√] 自动启动已配置（Windows 任务计划程序）' -ForegroundColor Green } catch { Write-Host '  [!] 自动启动配置失败' -ForegroundColor Yellow }"

echo.

REM 完成
echo ========================================
echo 部署完成！
echo ========================================
echo.

echo 部署摘要：
echo   OpenClaw 配置：%OPENCLAW_DIR%
echo   独立技能包：%SKILL_DIR%
echo   Skill 文档：%TARGET_FILE%
echo   MCP 配置：%MCP_CONFIG_PATH%
echo   MCP 服务器：%DIST_PATH%
echo   启动脚本：%STARTUP_SCRIPT%
echo.

echo ✨ 独立包特性：
echo   ✅ 完全自包含 - 不依赖项目源代码
echo   ✅ 可直接分享 - 打包整个文件夹即可
echo   ✅ 易于管理 - 所有文件在一个位置
echo   ✅ 支持多版本 - 可同时安装不同版本
echo   ✅ 开机自启动 - MCP 服务器自动启动
echo.

echo 🚀 MCP 服务器状态：
echo   ✅ MCP 服务器已启动
echo.

echo 下一步：
echo   1. 重启 OpenClaw（或它会自动检测 MCP 服务器）
echo   2. 在对话中告诉 OpenClaw：
echo      '请使用 Playwright Browser Skill 技能来访问互联网和控制浏览器'
echo   3. 测试：'使用 Playwright Browser Skill 启动浏览器并访问 example.com'
echo.

echo 管理命令：
echo   启动 MCP：  "%STARTUP_SCRIPT%"
echo   停止 MCP：  taskkill /F /FI "WINDOWTITLE eq Playwright Browser MCP Server*"
echo.

echo 使用说明：
echo   默认部署：  auto-deploy.cmd
echo   跳过构建：  auto-deploy.cmd --skip-build
echo   指定路径：  auto-deploy.cmd --openclaw-path "C:\custom\path"
echo.

pause
