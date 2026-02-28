#!/bin/bash

# ============================================
# Playwright Browser Skill - Mac/Linux 发行版打包脚本
# ============================================

VERSION="${1:-2.1.0}"

echo "========================================"
echo "  Playwright Browser Skill"
echo "  Mac/Linux 发行版打包工具"
echo "  版本: $VERSION"
echo "========================================"
echo ""

# 1. 检查环境
echo "[1/7] 检查构建环境..."

if [ ! -f "package.json" ]; then
    echo "错误: 请在项目根目录运行此脚本"
    exit 1
fi

if [ ! -d "dist" ]; then
    echo "提示: dist 目录不存在，将自动构建项目"
    npm run build
    if [ $? -ne 0 ]; then
        echo "错误: 项目构建失败"
        exit 1
    fi
fi

# 2. 创建发行版目录
RELEASE_NAME="playwright-browser-skill-macos-linux-v$VERSION"
RELEASE_DIR="releases/$RELEASE_NAME"

echo "[2/7] 创建发行版目录: $RELEASE_DIR"

rm -rf releases
mkdir -p "$RELEASE_DIR"

# 3. 复制核心文件
echo "[3/7] 复制核心文件..."

# 复制 dist 目录
cp -r dist "$RELEASE_DIR/"

# 复制 node_modules
echo "    - 复制 node_modules (这可能需要几分钟)..."
cp -r node_modules "$RELEASE_DIR/"

# 复制 skill 文件
mkdir -p "$RELEASE_DIR/skill-package/skills"
cp skill-package/skills/playwright-browser.md "$RELEASE_DIR/skill-package/skills/"

# 复制配置示例
mkdir -p "$RELEASE_DIR/skill-package/settings"
cp skill-package/settings/mcp.json "$RELEASE_DIR/skill-package/settings/"

# 4. 复制文档
echo "[4/7] 复制文档文件..."

DOCS=(
    "README.md"
    "README_EN.md"
    "LICENSE"
    "MAC_LINUX_GUIDE.md"
    "CONFIGURATION_GUIDE.md"
    "AUTO_DEPLOY_README.md"
    "AUTO_DEPLOY_README_EN.md"
)

for doc in "${DOCS[@]}"; do
    if [ -f "$doc" ]; then
        cp "$doc" "$RELEASE_DIR/"
    fi
done

# 5. 复制部署脚本
echo "[5/7] 复制部署脚本..."

SCRIPTS=(
    "auto-deploy.sh"
    "auto-deploy-en.sh"
)

for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        cp "$script" "$RELEASE_DIR/"
        chmod +x "$RELEASE_DIR/$script"
    fi
done

# 6. 创建简化的 package.json
echo "[6/7] 创建发行版配置文件..."

cat > "$RELEASE_DIR/package.json" << EOF
{
  "name": "playwright-browser-skill",
  "version": "$VERSION",
  "description": "A powerful browser automation skill for OpenClaw",
  "main": "dist/index.js",
  "type": "module",
  "author": "91fapiao <91fapiao@gmail.com>",
  "license": "MIT",
  "engines": {
    "node": ">=18.0.0"
  }
}
EOF

# 7. 创建安装说明
echo "[7/7] 创建安装说明..."

cat > "$RELEASE_DIR/INSTALL.md" << 'EOF'
# Playwright Browser Skill for OpenClaw - Mac/Linux 版本
版本: $VERSION

## 快速安装

### 方法一：自动部署（推荐）

1. 解压此文件到任意目录
2. 在此目录打开终端
3. 添加执行权限并运行部署脚本：

```bash
chmod +x auto-deploy.sh
./auto-deploy.sh
```

或使用英文版本：

```bash
chmod +x auto-deploy-en.sh
./auto-deploy-en.sh
```

### 方法二：手动部署

1. 复制整个文件夹到：
   ```
   ~/.openclaw/skills/playwright-browser/
   ```

2. 编辑配置文件：
   ```
   ~/.openclaw/settings/mcp.json
   ```

3. 添加以下配置：
   ```json
   {
     "mcpServers": {
       "playwright-browser": {
         "command": "node",
         "args": ["/Users/你的用户名/.openclaw/skills/playwright-browser/dist/mcp-server.js"],
         "disabled": false
       }
     }
   }
   ```

4. 重启 OpenClaw

## 使用说明

部署完成后，在 OpenClaw 对话中输入：

```
请使用 Playwright Browser Skill 技能来访问互联网和控制浏览器
```

然后就可以使用浏览器相关功能了！

## 包含内容

- ✅ 编译后的代码 (dist/)
- ✅ 完整依赖包 (node_modules/)
- ✅ 技能文档 (skill-package/)
- ✅ 自动部署脚本
- ✅ 完整文档

## 系统要求

- macOS 10.15+ 或 Linux
- Node.js 18 或更高版本

## 支持

- 📧 Email: 91fapiao@gmail.com
- 🐛 Issues: https://github.com/91fapiao-cn/playwright-browser-skill/issues
- 📚 文档: 查看 README.md

---
**Made with ❤️ for OpenClaw Community**
EOF

# 替换版本号
sed -i.bak "s/\$VERSION/$VERSION/g" "$RELEASE_DIR/INSTALL.md"
rm -f "$RELEASE_DIR/INSTALL.md.bak"

# 8. 完成
echo ""
echo "========================================"
echo "  打包完成！"
echo "========================================"
echo ""
echo "发行版位置: $RELEASE_DIR"
echo ""

# 计算大小
SIZE=$(du -sh "$RELEASE_DIR" | cut -f1)
echo "包大小: $SIZE"
echo ""

# 询问是否创建 tar.gz
read -p "是否创建 tar.gz 压缩包？(y/n) " CREATE_TAR

if [ "$CREATE_TAR" = "y" ] || [ "$CREATE_TAR" = "Y" ]; then
    echo ""
    echo "正在创建 tar.gz 压缩包..."
    
    cd releases
    tar -czf "$RELEASE_NAME.tar.gz" "$RELEASE_NAME"
    cd ..
    
    TAR_SIZE=$(du -sh "releases/$RELEASE_NAME.tar.gz" | cut -f1)
    echo ""
    echo "tar.gz 文件已创建: releases/$RELEASE_NAME.tar.gz"
    echo "压缩包大小: $TAR_SIZE"
fi

echo ""
echo "========================================"
echo "  可以发布了！"
echo "========================================"
