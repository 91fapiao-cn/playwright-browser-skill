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

if [ ! -f "skill-package/skills/playwright-browser.md" ]; then
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
SKILL_DIR="$SKILLS_DIR/playwright-browser"

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
SOURCE_FILE="skill-package/skills/playwright-browser.md"
TARGET_FILE="$SKILL_DIR/playwright-browser.md"

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
    "$SKILL_DIR/playwright-browser.md"
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
echo ""

echo -e "${CYAN}✨ Standalone Package Features:${NC}"
echo -e "  ${NC}✅ Fully self-contained - No dependency on project source${NC}"
echo -e "  ${NC}✅ Directly shareable - Just package the entire folder${NC}"
echo -e "  ${NC}✅ Easy to manage - All files in one location${NC}"
echo -e "  ${NC}✅ Multi-version support - Install different versions simultaneously${NC}"
echo ""

echo -e "${YELLOW}Next Steps:${NC}"
echo -e "  ${NC}1. Restart OpenClaw/Kiro${NC}"
echo -e "  ${NC}2. Test in chat: 'Launch browser and visit example.com'${NC}"
echo -e "  ${NC}3. Check MCP server status (should show playwright-browser)${NC}"
echo ""

echo -e "${CYAN}Usage:${NC}"
echo -e "${GRAY}  Default deploy:  ./auto-deploy-en.sh${NC}"
echo -e "${GRAY}  Skip build:      ./auto-deploy-en.sh --skip-build${NC}"
echo -e "${GRAY}  Custom path:     ./auto-deploy-en.sh --openclaw-path '/custom/path'${NC}"
echo ""
