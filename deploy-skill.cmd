@echo off
REM Playwright Browser Skill 一键部署脚本

echo ========================================
echo Playwright Browser Skill - 部署脚本
echo ========================================
echo.

REM 检查是否在项目目录
if not exist ".kiro\skills\playwright-browser.md" (
    echo [X] 错误：请在项目根目录运行此脚本
    echo     当前目录：%CD%
    exit /b 1
)

echo [1/3] 检查 OpenClaw 配置目录...

REM 创建必要的目录
if not exist "%USERPROFILE%\.openclaw" mkdir "%USERPROFILE%\.openclaw"
if not exist "%USERPROFILE%\.openclaw\settings" mkdir "%USERPROFILE%\.openclaw\settings"
if not exist "%USERPROFILE%\.openclaw\skills" mkdir "%USERPROFILE%\.openclaw\skills"
if not exist "%USERPROFILE%\.openclaw\skills\playwright-browser" mkdir "%USERPROFILE%\.openclaw\skills\playwright-browser"

echo [√] 目录结构已准备就绪
echo.

echo [2/3] 部署 Skill 文件...

copy ".kiro\skills\playwright-browser.md" "%USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md" >nul

if exist "%USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md" (
    echo [√] Skill 文件已复制
    echo     目标位置：%USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md
) else (
    echo [X] Skill 文件复制失败
    exit /b 1
)

echo.

echo [3/3] 检查 MCP 配置...

if exist "%USERPROFILE%\.openclaw\settings\mcp.json" (
    echo [!] MCP 配置文件已存在
    echo     位置：%USERPROFILE%\.openclaw\settings\mcp.json
    echo.
    echo 请手动添加以下配置到 mcp.json：
) else (
    echo [!] MCP 配置文件不存在，需要创建
    echo.
    echo 请创建文件：%USERPROFILE%\.openclaw\settings\mcp.json
    echo 并添加以下内容：
)

echo.
echo {
echo   "mcpServers": {
echo     "playwright-browser": {
echo       "command": "node",
echo       "args": ["%CD:\=\\%\\dist\\mcp-server.js"],
echo       "disabled": false,
echo       "autoApprove": ["browser_launch", "browser_goto", "browser_close"]
echo     }
echo   }
echo }
echo.

echo ========================================
echo [√] Skill 部署完成！
echo ========================================
echo.

echo 下一步：
echo 1. 确保项目已构建（npm run build）
echo 2. 配置 MCP（见上面的配置示例）
echo 3. 重启 OpenClaw
echo 4. 在 OpenClaw 中测试：启动浏览器，访问 example.com
echo.

echo Skill 文件位置：
echo   %USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md
echo.

echo MCP 配置位置：
echo   %USERPROFILE%\.openclaw\settings\mcp.json
echo.

pause
