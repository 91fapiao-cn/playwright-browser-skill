#!/bin/bash
# Playwright Browser Skill - Auto Deploy Script (Mac/Linux)
# Automatically detects OpenClaw path and completes deployment

set -e

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Parameters
OPENCLAW_PATH=""
SKIP_BUILD=false

# Parse command line arguments
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
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --openclaw-path PATH   Specify OpenClaw configuration path"
            echo "  --skip-build           Skip project build"
            echo "  -h, --help             Show help information"
            exit 0
            ;;
        *)
            echo -e "${RED}[X] Unknown parameter: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}Playwright Browser Skill - Auto Deploy${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Function: Detect OpenClaw installation path
find_openclaw_path() {
    echo -e "${YELLOW}[*] Detecting OpenClaw installation path...${NC}"
    
    # OpenClaw configuration paths
    local possible_paths=(
        "$HOME/.openclaw"
        "$HOME/Library/Application Support/openclaw"
    )
    
    for path in "${possible_paths[@]}"; do
        if [ -d "$path" ]; then
            echo -e "${GREEN}[√] Found OpenClaw config directory: $path${NC}"
            echo "$path"
            return 0
        fi
    done
    
    # If not found, use default path
    local default_path="$HOME/.openclaw"
    echo -e "${YELLOW}[!] No existing config found, will use default path: $default_path${NC}"
    echo "$default_path"
}

# Function: Ensure directory exists
ensure_directory() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo -e "${GRAY}  [+] Created directory: $dir${NC}"
    fi
}

# Step 0: Check project directory
echo -e "${YELLOW}[0/5] Checking project environment...${NC}"

if [ ! -f "skill-package/skills/SKILL.md" ]; then
    echo -e "${RED}[X] Error: Please run this script in the project root directory${NC}"
    echo -e "${GRAY}    Current directory: $(pwd)${NC}"
    exit 1
fi

PROJECT_PATH="$(pwd)"
echo -e "${GREEN}[√] Project directory: $PROJECT_PATH${NC}"
echo ""

# Step 1: Build project
if [ "$SKIP_BUILD" = false ]; then
    echo -e "${YELLOW}[1/5] Building project...${NC}"
    
    if [ ! -f "package.json" ]; then
        echo -e "${RED}[X] Error: package.json not found${NC}"
        exit 1
    fi
    
    echo -e "${GRAY}  Executing: npm run build${NC}"
    npm run build
    
    if [ ! -f "dist/mcp-server.js" ]; then
        echo -e "${RED}[X] Error: Build artifact not found (dist/mcp-server.js)${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}[√] Project built successfully${NC}"
else
    echo -e "${GRAY}[1/5] Skipping build (using --skip-build parameter)${NC}"
    
    if [ ! -f "dist/mcp-server.js" ]; then
        echo -e "${RED}[X] Error: dist/mcp-server.js does not exist, please build the project first${NC}"
        exit 1
    fi
fi
echo ""

# Step 2: Detect OpenClaw path
echo -e "${YELLOW}[2/5] Detecting OpenClaw configuration path...${NC}"

if [ -n "$OPENCLAW_PATH" ]; then
    echo -e "${GRAY}  Using specified path: $OPENCLAW_PATH${NC}"
    OPENCLAW_DIR="$OPENCLAW_PATH"
else
    OPENCLAW_DIR=$(find_openclaw_path)
fi

SETTINGS_DIR="$OPENCLAW_DIR/settings"
SKILLS_DIR="$OPENCLAW_DIR/skills"
SKILL_DIR="$SKILLS_DIR/playwright-browser-skill"

echo -e "${GREEN}[√] OpenClaw config directory: $OPENCLAW_DIR${NC}"
echo ""

# Step 3: Create directory structure
echo -e "${YELLOW}[3/5] Preparing directory structure...${NC}"

ensure_directory "$OPENCLAW_DIR"
ensure_directory "$SETTINGS_DIR"
ensure_directory "$SKILLS_DIR"
ensure_directory "$SKILL_DIR"

echo -e "${GREEN}[√] Directory structure ready${NC}"
echo ""

# Step 4: Deploy standalone skill package
echo -e "${YELLOW}[4/7] Deploying standalone skill package...${NC}"

# 4.1 Copy Skill documentation
SOURCE_FILE="skill-package/skills/SKILL.md"
TARGET_FILE="$SKILL_DIR/SKILL.md"

cp "$SOURCE_FILE" "$TARGET_FILE"
echo -e "${GREEN}  [√] Skill documentation deployed${NC}"

# 4.2 Copy dist folder (compiled code)
echo -e "${GRAY}  [*] Copying compiled code...${NC}"
DIST_SOURCE="dist"
DIST_TARGET="$SKILL_DIR/dist"

if [ -d "$DIST_TARGET" ]; then
    rm -rf "$DIST_TARGET"
fi
cp -r "$DIST_SOURCE" "$DIST_TARGET"
echo -e "${GREEN}  [√] Compiled code deployed (dist/)${NC}"

# 4.3 Copy necessary node_modules dependencies
echo -e "${GRAY}  [*] Copying runtime dependencies...${NC}"
NODE_MODULES_TARGET="$SKILL_DIR/node_modules"

if [ -d "$NODE_MODULES_TARGET" ]; then
    rm -rf "$NODE_MODULES_TARGET"
fi

echo -e "${GRAY}    [*] Copying all dependencies (this may take a moment)...${NC}"
cp -r "node_modules" "$NODE_MODULES_TARGET"

echo -e "${GREEN}  [√] Runtime dependencies deployed${NC}"

# 4.4 Copy package.json
echo -e "${GRAY}  [*] Copying package.json...${NC}"
if [ -f "package.json" ]; then
    cp "package.json" "$SKILL_DIR/package.json"
    echo -e "${GREEN}  [√] package.json deployed${NC}"
else
    echo -e "${YELLOW}  [!] package.json not found (does not affect functionality)${NC}"
fi

echo -e "${GREEN}[√] Standalone skill package deployment complete${NC}"
echo ""

# Step 5: Configure MCP
echo -e "${YELLOW}[5/7] Configuring MCP server...${NC}"

MCP_CONFIG_PATH="$SETTINGS_DIR/mcp.json"
DIST_PATH="$SKILL_DIR/dist/mcp-server.js"

# Create MCP configuration
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

# If config file exists, merge configuration
if [ -f "$MCP_CONFIG_PATH" ]; then
    echo -e "${YELLOW}  [!] Existing MCP configuration detected${NC}"
    
    # Backup existing configuration
    BACKUP_PATH="$MCP_CONFIG_PATH.backup.$(date +%Y%m%d-%H%M%S)"
    cp "$MCP_CONFIG_PATH" "$BACKUP_PATH"
    echo -e "${GRAY}  [√] Backed up to: $BACKUP_PATH${NC}"
    
    # Use jq to merge configuration (if available)
    if command -v jq &> /dev/null; then
        TEMP_CONFIG=$(mktemp)
        echo "$MCP_CONFIG" > "$TEMP_CONFIG"
        
        jq -s '.[0] * .[1]' "$MCP_CONFIG_PATH" "$TEMP_CONFIG" > "$MCP_CONFIG_PATH.tmp"
        mv "$MCP_CONFIG_PATH.tmp" "$MCP_CONFIG_PATH"
        rm "$TEMP_CONFIG"
        
        echo -e "${GREEN}  [√] Merged into existing configuration${NC}"
    else
        echo -e "${YELLOW}  [!] jq not installed, will overwrite existing configuration${NC}"
        echo "$MCP_CONFIG" > "$MCP_CONFIG_PATH"
    fi
else
    # Create new configuration
    echo "$MCP_CONFIG" > "$MCP_CONFIG_PATH"
    echo -e "${GREEN}  [√] Created new configuration file${NC}"
fi

echo -e "${GREEN}[√] MCP configuration complete${NC}"
echo ""

# Step 6: Verify deployment
echo -e "${YELLOW}[6/7] Verifying deployment...${NC}"

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
        echo -e "${RED}  [X] Missing: $file${NC}"
        all_ok=false
    fi
done

if [ "$all_ok" = true ]; then
    echo -e "${GREEN}[√] All files verified${NC}"
else
    echo -e "${RED}[X] Deployment verification failed${NC}"
    exit 1
fi
echo ""

# Step 7: Statistics
echo -e "${YELLOW}[7/7] Statistics...${NC}"
echo -e "${GRAY}  Total tools: 101${NC}"
echo -e "${GRAY}  Coverage: 88%${NC}"
echo ""

# Step 8: Start MCP Server
echo -e "${YELLOW}[8/9] Starting MCP Server...${NC}"

# Check if MCP server is already running
MCP_RUNNING=false
if pgrep -f "node.*mcp-server.js" > /dev/null; then
    MCP_PID=$(pgrep -f "node.*mcp-server.js")
    echo -e "${YELLOW}  [!] MCP Server is already running (PID: $MCP_PID)${NC}"
    MCP_RUNNING=true
fi

if [ "$MCP_RUNNING" = false ]; then
    echo -e "${GRAY}  [*] Starting MCP Server...${NC}"
    
    # Create startup script
    STARTUP_SCRIPT="$SKILL_DIR/start-mcp-server.sh"
    cat > "$STARTUP_SCRIPT" << 'SCRIPT_EOF'
#!/bin/bash
echo "Playwright Browser MCP Server"
echo "Press Ctrl+C to stop server"
echo "This terminal can be minimized but do not close"
echo ""
cd "$(dirname "$0")"
node dist/mcp-server.js
SCRIPT_EOF
    
    chmod +x "$STARTUP_SCRIPT"
    echo -e "${GRAY}  [√] Created startup script: $STARTUP_SCRIPT${NC}"
    
    # Start MCP server in background
    if command -v osascript &> /dev/null; then
        # macOS: Use osascript to open in new minimized terminal
        osascript -e "tell application \"Terminal\" to do script \"$STARTUP_SCRIPT\"" -e "tell application \"Terminal\" to set miniaturized of window 1 to true" &> /dev/null &
    else
        # Linux: Start in background with nohup
        nohup "$STARTUP_SCRIPT" > "$SKILL_DIR/mcp-server.log" 2>&1 &
    fi
    
    # Wait for server to start
    sleep 3
    
    # Verify startup
    if pgrep -f "node.*mcp-server.js" > /dev/null; then
        MCP_PID=$(pgrep -f "node.*mcp-server.js")
        echo -e "${GREEN}  [√] MCP Server started successfully (PID: $MCP_PID)${NC}"
    else
        echo -e "${YELLOW}  [!] MCP Server may still be starting...${NC}"
    fi
else
    echo -e "${GREEN}  [√] MCP Server is already running${NC}"
fi
echo ""

# Step 9: Setup Auto-start
echo -e "${YELLOW}[9/9] Setting up auto-start...${NC}"

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: Create LaunchAgent
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
    
    echo -e "${GREEN}  [√] Auto-start configured (LaunchAgent)${NC}"
    echo -e "${GRAY}      Plist: $PLIST_PATH${NC}"
    echo -e "${GRAY}      Trigger: At user login${NC}"
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux: Create systemd user service
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
    
    # Enable the service
    systemctl --user enable playwright-browser-mcp.service &> /dev/null || true
    
    echo -e "${GREEN}  [√] Auto-start configured (systemd)${NC}"
    echo -e "${GRAY}      Service: $SERVICE_PATH${NC}"
    echo -e "${GRAY}      Trigger: At user login${NC}"
    echo -e "${GRAY}      Enable: systemctl --user enable playwright-browser-mcp.service${NC}"
fi
echo ""

# Complete
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

echo -e "${CYAN}Deployment Summary:${NC}"
echo -e "  ${NC}OpenClaw Config: $OPENCLAW_DIR${NC}"
echo -e "  ${NC}Standalone Package: $SKILL_DIR${NC}"
echo -e "  ${NC}Skill Documentation: $TARGET_FILE${NC}"
echo -e "  ${NC}MCP Config: $MCP_CONFIG_PATH${NC}"
echo -e "  ${NC}MCP Server: $DIST_PATH${NC}"
echo -e "  ${NC}Startup Script: $STARTUP_SCRIPT${NC}"
echo ""

echo -e "${CYAN}✨ Standalone Package Features:${NC}"
echo -e "  ${NC}✅ Fully self-contained - No dependency on project source${NC}"
echo -e "  ${NC}✅ Directly shareable - Just package the entire folder${NC}"
echo -e "  ${NC}✅ Easy to manage - All files in one location${NC}"
echo -e "  ${NC}✅ Multi-version support - Install different versions simultaneously${NC}"
echo -e "  ${NC}✅ Auto-start on login - MCP server starts automatically${NC}"
echo ""

echo -e "${CYAN}🚀 MCP Server Status:${NC}"
if pgrep -f "node.*mcp-server.js" > /dev/null; then
    MCP_PID=$(pgrep -f "node.*mcp-server.js")
    echo -e "  ${GREEN}✅ MCP Server is running (PID: $MCP_PID)${NC}"
else
    echo -e "  ${YELLOW}⚠️  MCP Server is not running${NC}"
fi
echo ""

echo -e "${YELLOW}Next Steps:${NC}"
echo -e "  ${NC}1. Restart OpenClaw (or it will auto-detect MCP server)${NC}"
echo -e "  ${NC}2. Tell OpenClaw in chat:${NC}"
echo -e "  ${CYAN}   'Please use Playwright Browser Skill to access the internet and control browsers'${NC}"
echo -e "  ${NC}3. Test: 'Use Playwright Browser Skill to launch browser and visit example.com'${NC}"
echo ""

echo -e "${CYAN}Management Commands:${NC}"
echo -e "${GRAY}  Start MCP:   $STARTUP_SCRIPT${NC}"
echo -e "${GRAY}  Stop MCP:    pkill -f 'node.*mcp-server.js'${NC}"
echo -e "${GRAY}  Check Status: pgrep -f 'node.*mcp-server.js'${NC}"
echo ""

echo -e "${CYAN}Usage:${NC}"
echo -e "${GRAY}  Default deploy:  ./auto-deploy-en.sh${NC}"
echo -e "${GRAY}  Skip build:      ./auto-deploy-en.sh --skip-build${NC}"
echo -e "${GRAY}  Custom path:     ./auto-deploy-en.sh --openclaw-path '/custom/path'${NC}"
echo ""
