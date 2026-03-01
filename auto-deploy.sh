#!/bin/bash
# Playwright Browser Skill - 自动部署脚本 (Mac/Linux)
# 自动检测 OpenClaw 路径并完成部署

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# 参数
OPENCLAW_PATH=""
SKIP_BUILD=false

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --openclaw-path)
            OPENCLAW_PATH="$2"
            shift 2
            ;;
        --skip-build)
            SKIP_BUILD=true
            shift
            ;;
        -h|--help)
            echo "用法: $0 [选项]"
            echo ""
            echo "选项:"
            echo "  --openclaw-path PATH   指定 OpenClaw 配置路径"
            echo "  --skip-build           跳过项目构建"
            echo "  -h, --help             显示帮助信息"
            exit 0
            ;;
        *)
            echo -e "${RED}[X] 未知参数: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}Playwright Browser Skill - 自动部署${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# 函数：检测 OpenClaw 安装路径
find_openclaw_path() {
    echo -e "${YELLOW}[*] 正在检测 OpenClaw 安装路径...${NC}"
    
    # OpenClaw 配置路径
    local possible_paths=(
        "$HOME/.openclaw"
        "$HOME/Library/Application Support/openclaw"
    )
    
    for path in "${possible_paths[@]}"; do
        if [ -d "$path" ]; then
            echo -e "${GREEN}[√] 找到 OpenClaw 配置目录：$path${NC}"
            echo "$path"
            return 0
        fi
    done
    
    # 如果都没找到，使用默认路径
    local default_path="$HOME/.openclaw"
    echo -e "${YELLOW}[!] 未找到现有配置，将使用默认路径：$default_path${NC}"
    echo "$default_path"
}

# 函数：确保目录存在
ensure_directory() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo -e "${GRAY}  [+] 创建目录：$dir${NC}"
    fi
}

# 步骤 0：检查项目目录
echo -e "${YELLOW}[0/5] 检查项目环境...${NC}"

if [ ! -f "skill-package/skills/SKILL.md" ]; then
    echo -e "${RED}[X] 错误：请在项目根目录运行此脚本${NC}"
    echo -e "${GRAY}    当前目录：$(pwd)${NC}"
    exit 1
fi

PROJECT_PATH="$(pwd)"
echo -e "${GREEN}[√] 项目目录：$PROJECT_PATH${NC}"
echo ""

# 步骤 1：构建项目
if [ "$SKIP_BUILD" = false ]; then
    echo -e "${YELLOW}[1/5] 构建项目...${NC}"
    
    if [ ! -f "package.json" ]; then
        echo -e "${RED}[X] 错误：未找到 package.json${NC}"
        exit 1
    fi
    
    echo -e "${GRAY}  执行：npm run build${NC}"
    npm run build
    
    if [ ! -f "dist/mcp-server.js" ]; then
        echo -e "${RED}[X] 错误：构建产物不存在 (dist/mcp-server.js)${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}[√] 项目构建成功${NC}"
else
    echo -e "${GRAY}[1/5] 跳过构建（使用 --skip-build 参数）${NC}"
    
    if [ ! -f "dist/mcp-server.js" ]; then
        echo -e "${RED}[X] 错误：dist/mcp-server.js 不存在，请先构建项目${NC}"
        exit 1
    fi
fi
echo ""

# 步骤 2：检测 OpenClaw 路径
echo -e "${YELLOW}[2/5] 检测 OpenClaw 配置路径...${NC}"

if [ -n "$OPENCLAW_PATH" ]; then
    echo -e "${GRAY}  使用指定路径：$OPENCLAW_PATH${NC}"
    OPENCLAW_DIR="$OPENCLAW_PATH"
else
    OPENCLAW_DIR=$(find_openclaw_path)
fi

SETTINGS_DIR="$OPENCLAW_DIR/settings"
SKILLS_DIR="$OPENCLAW_DIR/skills"
SKILL_DIR="$SKILLS_DIR/playwright-browser-skill"

echo -e "${GREEN}[√] OpenClaw 配置目录：$OPENCLAW_DIR${NC}"
echo ""

# 步骤 3：创建目录结构
echo -e "${YELLOW}[3/5] 准备目录结构...${NC}"

ensure_directory "$OPENCLAW_DIR"
ensure_directory "$SETTINGS_DIR"
ensure_directory "$SKILLS_DIR"
ensure_directory "$SKILL_DIR"

echo -e "${GREEN}[√] 目录结构已就绪${NC}"
echo ""

# Step 4: Deploy standalone skill package
echo -e "${YELLOW}[4/7] 部署独立技能包...${NC}"

# 4.1 Copy Skill documentation
SOURCE_FILE="skill-package/skills/SKILL.md"
TARGET_FILE="$SKILL_DIR/SKILL.md"

cp "$SOURCE_FILE" "$TARGET_FILE"
echo -e "${GREEN}  [√] Skill 文档已部署${NC}"

# 4.2 Copy dist folder (compiled code)
echo -e "${GRAY}  [*] 复制编译后的代码...${NC}"
DIST_SOURCE="dist"
DIST_TARGET="$SKILL_DIR/dist"

if [ -d "$DIST_TARGET" ]; then
    rm -rf "$DIST_TARGET"
fi
cp -r "$DIST_SOURCE" "$DIST_TARGET"
echo -e "${GREEN}  [√] 编译代码已部署 (dist/)${NC}"

# 4.3 Copy necessary node_modules dependencies
echo -e "${GRAY}  [*] 复制运行时依赖...${NC}"
NODE_MODULES_TARGET="$SKILL_DIR/node_modules"

if [ -d "$NODE_MODULES_TARGET" ]; then
    rm -rf "$NODE_MODULES_TARGET"
fi

echo -e "${GRAY}    [*] 复制所有依赖（这可能需要一些时间）...${NC}"
cp -r "node_modules" "$NODE_MODULES_TARGET"

echo -e "${GREEN}  [√] 运行时依赖已部署${NC}"

# 4.4 复制 package.json
echo -e "${GRAY}  [*] 复制 package.json...${NC}"
if [ -f "package.json" ]; then
    cp "package.json" "$SKILL_DIR/package.json"
    echo -e "${GREEN}  [√] package.json 已部署${NC}"
else
    echo -e "${YELLOW}  [!] package.json 不存在（不影响功能）${NC}"
fi

echo -e "${GREEN}[√] 独立技能包部署完成${NC}"
echo ""

# 步骤 5：配置 MCP
echo -e "${YELLOW}[5/7] 配置 MCP 服务器...${NC}"

MCP_CONFIG_PATH="$SETTINGS_DIR/mcp.json"
DIST_PATH="$SKILL_DIR/dist/mcp-server.js"

# 创建 MCP 配置
MCP_CONFIG=$(cat <<EOF
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["$DIST_PATH"],
      "env": {},
      "disabled": false,
      "autoApprove": [
        "browser_launch",
        "browser_goto",
        "browser_get_title",
        "browser_get_text",
        "browser_get_html",
        "browser_get_links",
        "browser_get_cookies",
        "browser_close"
      ]
    }
  }
}
EOF
)

# 如果配置文件已存在，合并配置
if [ -f "$MCP_CONFIG_PATH" ]; then
    echo -e "${YELLOW}  [!] 检测到现有 MCP 配置${NC}"
    
    # 备份现有配置
    BACKUP_PATH="$MCP_CONFIG_PATH.backup.$(date +%Y%m%d-%H%M%S)"
    cp "$MCP_CONFIG_PATH" "$BACKUP_PATH"
    echo -e "${GRAY}  [√] 已备份到：$BACKUP_PATH${NC}"
    
    # 使用 jq 合并配置（如果可用）
    if command -v jq &> /dev/null; then
        TEMP_CONFIG=$(mktemp)
        echo "$MCP_CONFIG" > "$TEMP_CONFIG"
        
        jq -s '.[0] * .[1]' "$MCP_CONFIG_PATH" "$TEMP_CONFIG" > "$MCP_CONFIG_PATH.tmp"
        mv "$MCP_CONFIG_PATH.tmp" "$MCP_CONFIG_PATH"
        rm "$TEMP_CONFIG"
        
        echo -e "${GREEN}  [√] 已合并到现有配置${NC}"
    else
        echo -e "${YELLOW}  [!] 未安装 jq，将覆盖现有配置${NC}"
        echo "$MCP_CONFIG" > "$MCP_CONFIG_PATH"
    fi
else
    # 创建新配置
    echo "$MCP_CONFIG" > "$MCP_CONFIG_PATH"
    echo -e "${GREEN}  [√] 已创建新配置文件${NC}"
fi

echo -e "${GREEN}[√] MCP 配置完成${NC}"
echo ""

# 步骤 6：验证部署
echo -e "${YELLOW}[6/7] 验证部署...${NC}"

required_files=(
    "$SKILL_DIR/SKILL.md"
    "$SKILL_DIR/dist/mcp-server.js"
    "$SKILL_DIR/dist/index.js"
    "$SKILL_DIR/node_modules/playwright"
)

all_ok=true
for file in "${required_files[@]}"; do
    if [ -e "$file" ]; then
        echo -e "${GRAY}  [√] $(basename $file)${NC}"
    else
        echo -e "${RED}  [X] 缺失：$file${NC}"
        all_ok=false
    fi
done

if [ "$all_ok" = true ]; then
    echo -e "${GREEN}[√] 所有文件验证通过${NC}"
else
    echo -e "${RED}[X] 部署验证失败${NC}"
    exit 1
fi
echo ""

# 步骤 7：统计信息
echo -e "${YELLOW}[7/9] 统计信息...${NC}"
echo -e "${GRAY}  工具总数：101 个${NC}"
echo -e "${GRAY}  覆盖率：88%${NC}"
echo ""

# 步骤 8：启动 MCP 服务器
echo -e "${YELLOW}[8/9] 启动 MCP 服务器...${NC}"

# 检查 MCP 服务器是否已在运行
MCP_RUNNING=false
if pgrep -f "node.*mcp-server.js" > /dev/null; then
    MCP_PID=$(pgrep -f "node.*mcp-server.js")
    echo -e "${YELLOW}  [!] MCP 服务器已在运行 (PID: $MCP_PID)${NC}"
    MCP_RUNNING=true
fi

if [ "$MCP_RUNNING" = false ]; then
    echo -e "${GRAY}  [*] 正在启动 MCP 服务器...${NC}"
    
    # 创建启动脚本
    STARTUP_SCRIPT="$SKILL_DIR/start-mcp-server.sh"
    cat > "$STARTUP_SCRIPT" << 'SCRIPT_EOF'
#!/bin/bash
echo "Playwright Browser MCP Server"
echo "按 Ctrl+C 停止服务器"
echo "此终端可以最小化，但请勿关闭"
echo ""
cd "$(dirname "$0")"
node dist/mcp-server.js
SCRIPT_EOF
    
    chmod +x "$STARTUP_SCRIPT"
    echo -e "${GRAY}  [√] 已创建启动脚本：$STARTUP_SCRIPT${NC}"
    
    # 启动 MCP 服务器
    if command -v osascript &> /dev/null; then
        # macOS：使用 osascript 在新的最小化终端中打开
        osascript -e "tell application \"Terminal\" to do script \"$STARTUP_SCRIPT\"" -e "tell application \"Terminal\" to set miniaturized of window 1 to true" &> /dev/null &
    else
        # Linux：使用 nohup 在后台启动
        nohup "$STARTUP_SCRIPT" > "$SKILL_DIR/mcp-server.log" 2>&1 &
    fi
    
    # 等待服务器启动
    sleep 3
    
    # 验证启动
    if pgrep -f "node.*mcp-server.js" > /dev/null; then
        MCP_PID=$(pgrep -f "node.*mcp-server.js")
        echo -e "${GREEN}  [√] MCP 服务器启动成功 (PID: $MCP_PID)${NC}"
    else
        echo -e "${YELLOW}  [!] MCP 服务器可能还在启动中...${NC}"
    fi
else
    echo -e "${GREEN}  [√] MCP 服务器已在运行${NC}"
fi
echo ""

# 步骤 9：配置自动启动
echo -e "${YELLOW}[9/9] 配置自动启动...${NC}"

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS：创建 LaunchAgent
    PLIST_PATH="$HOME/Library/LaunchAgents/com.playwright-browser-mcp.plist"
    
    cat > "$PLIST_PATH" << PLIST_EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.playwright-browser-mcp</string>
    <key>ProgramArguments</key>
    <array>
        <string>$STARTUP_SCRIPT</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>StandardOutPath</key>
    <string>$SKILL_DIR/mcp-server.log</string>
    <key>StandardErrorPath</key>
    <string>$SKILL_DIR/mcp-server-error.log</string>
</dict>
</plist>
PLIST_EOF
    
    echo -e "${GREEN}  [√] 自动启动已配置（LaunchAgent）${NC}"
    echo -e "${GRAY}      Plist：$PLIST_PATH${NC}"
    echo -e "${GRAY}      触发器：用户登录时${NC}"
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux：创建 systemd 用户服务
    SYSTEMD_DIR="$HOME/.config/systemd/user"
    mkdir -p "$SYSTEMD_DIR"
    
    SERVICE_PATH="$SYSTEMD_DIR/playwright-browser-mcp.service"
    
    cat > "$SERVICE_PATH" << SERVICE_EOF
[Unit]
Description=Playwright Browser MCP Server
After=network.target

[Service]
Type=simple
ExecStart=$STARTUP_SCRIPT
Restart=on-failure
StandardOutput=append:$SKILL_DIR/mcp-server.log
StandardError=append:$SKILL_DIR/mcp-server-error.log

[Install]
WantedBy=default.target
SERVICE_EOF
    
    # 启用服务
    systemctl --user enable playwright-browser-mcp.service &> /dev/null || true
    
    echo -e "${GREEN}  [√] 自动启动已配置（systemd）${NC}"
    echo -e "${GRAY}      服务：$SERVICE_PATH${NC}"
    echo -e "${GRAY}      触发器：用户登录时${NC}"
    echo -e "${GRAY}      启用：systemctl --user enable playwright-browser-mcp.service${NC}"
fi
echo ""

# 完成
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}部署完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

echo -e "${CYAN}部署摘要：${NC}"
echo -e "  ${NC}OpenClaw 配置：$OPENCLAW_DIR${NC}"
echo -e "  ${NC}独立技能包：$SKILL_DIR${NC}"
echo -e "  ${NC}Skill 文档：$TARGET_FILE${NC}"
echo -e "  ${NC}MCP 配置：$MCP_CONFIG_PATH${NC}"
echo -e "  ${NC}MCP 服务器：$DIST_PATH${NC}"
echo -e "  ${NC}启动脚本：$STARTUP_SCRIPT${NC}"
echo ""

echo -e "${CYAN}✨ 独立包特性：${NC}"
echo -e "  ${NC}✅ 完全自包含 - 不依赖项目源代码${NC}"
echo -e "  ${NC}✅ 可直接分享 - 打包整个文件夹即可${NC}"
echo -e "  ${NC}✅ 易于管理 - 所有文件在一个位置${NC}"
echo -e "  ${NC}✅ 支持多版本 - 可同时安装不同版本${NC}"
echo -e "  ${NC}✅ 开机自启动 - MCP 服务器自动启动${NC}"
echo ""

echo -e "${CYAN}🚀 MCP 服务器状态：${NC}"
if pgrep -f "node.*mcp-server.js" > /dev/null; then
    MCP_PID=$(pgrep -f "node.*mcp-server.js")
    echo -e "  ${GREEN}✅ MCP 服务器正在运行 (PID: $MCP_PID)${NC}"
else
    echo -e "  ${YELLOW}⚠️  MCP 服务器未运行${NC}"
fi
echo ""

echo -e "${YELLOW}下一步：${NC}"
echo -e "  ${NC}1. 重启 OpenClaw（或它会自动检测 MCP 服务器）${NC}"
echo -e "  ${NC}2. 在对话中告诉 OpenClaw：${NC}"
echo -e "  ${CYAN}   '请使用 Playwright Browser Skill 技能来访问互联网和控制浏览器'${NC}"
echo -e "  ${NC}3. 测试：'使用 Playwright Browser Skill 启动浏览器并访问 example.com'${NC}"
echo ""

echo -e "${CYAN}管理命令：${NC}"
echo -e "${GRAY}  启动 MCP：  $STARTUP_SCRIPT${NC}"
echo -e "${GRAY}  停止 MCP：  pkill -f 'node.*mcp-server.js'${NC}"
echo -e "${GRAY}  检查状态：  pgrep -f 'node.*mcp-server.js'${NC}"
echo ""

echo -e "${CYAN}使用说明：${NC}"
echo -e "${GRAY}  默认部署：  ./auto-deploy.sh${NC}"
echo -e "${GRAY}  跳过构建：  ./auto-deploy.sh --skip-build${NC}"
echo -e "${GRAY}  指定路径：  ./auto-deploy.sh --openclaw-path '/custom/path'${NC}"
echo ""
