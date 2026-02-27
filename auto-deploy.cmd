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

if not exist ".kiro\skills\playwright-browser.md" (
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
    REM 检测常见路径
    if exist "%USERPROFILE%\.openclaw" (
        set "OPENCLAW_DIR=%USERPROFILE%\.openclaw"
        echo [√] 找到 OpenClaw 配置目录：!OPENCLAW_DIR!
    ) else if exist "%USERPROFILE%\.kiro" (
        set "OPENCLAW_DIR=%USERPROFILE%\.kiro"
        echo [√] 找到 Kiro 配置目录：!OPENCLAW_DIR!
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
set "SKILL_DIR=%SKILLS_DIR%\playwright-browser"

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

REM 步骤 4：部署 Skill 文件
echo [4/5] 部署 Skill 文件...

set "SOURCE_FILE=.kiro\skills\playwright-browser.md"
set "TARGET_FILE=%SKILL_DIR%\playwright-browser.md"

copy /Y "%SOURCE_FILE%" "%TARGET_FILE%" >nul

if exist "%TARGET_FILE%" (
    echo [√] Skill 文件已部署
    echo     源文件：%SOURCE_FILE%
    echo     目标位置：%TARGET_FILE%
) else (
    echo [X] Skill 文件部署失败
    exit /b 1
)
echo.

REM 步骤 5：配置 MCP
echo [5/5] 配置 MCP 服务器...

set "MCP_CONFIG_PATH=%SETTINGS_DIR%\mcp.json"
set "DIST_PATH=%PROJECT_PATH%\dist\mcp-server.js"

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
echo     配置文件：%MCP_CONFIG_PATH%
echo.

REM 完成
echo ========================================
echo 部署完成！
echo ========================================
echo.

echo 部署摘要：
echo   OpenClaw 配置：%OPENCLAW_DIR%
echo   Skill 文件：%TARGET_FILE%
echo   MCP 配置：%MCP_CONFIG_PATH%
echo   MCP 服务器：%DIST_PATH%
echo.

echo 下一步：
echo   1. 重启 OpenClaw/Kiro
echo   2. 在聊天中测试：'启动浏览器并访问 example.com'
echo   3. 查看 MCP 服务器状态（应显示 playwright-browser）
echo.

echo 使用说明：
echo   默认部署：  auto-deploy.cmd
echo   跳过构建：  auto-deploy.cmd --skip-build
echo   指定路径：  auto-deploy.cmd --openclaw-path "C:\custom\path"
echo.

pause
