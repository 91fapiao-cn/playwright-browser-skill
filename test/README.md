# 测试说明

## 测试套件

本项目包含完整的测试套件，验证所有功能是否正常工作。

### 测试文件

1. **basic-test.ts** - 基础功能测试
   - 浏览器启动/关闭
   - 页面导航
   - 内容提取
   - 截图
   - Cookie操作

2. **advanced-test.ts** - 高级功能测试
   - 设备模拟
   - 多页面管理
   - 性能指标
   - 网络日志
   - 高级选择器

3. **interaction-test.ts** - 交互功能测试
   - 表单填写
   - 按键操作
   - 页面导航
   - 元素交互

4. **mcp-server-test.ts** - MCP服务器测试
   - 服务器启动
   - 工具列表
   - 工具调用

5. **run-all-tests.ts** - 测试运行器
   - 运行所有测试
   - 生成测试报告

## 运行测试

### 前置条件

```bash
# 安装依赖
npm install

# 安装浏览器
npx playwright install

# 构建项目
npm run build
```

### 运行所有测试

```bash
npm test
```

### 运行单个测试

```bash
# 基础功能测试
npm run test:basic

# 高级功能测试
npm run test:advanced

# 交互功能测试
npm run test:interaction

# MCP服务器测试
npm run test:mcp
```

### 手动运行

```bash
# 构建后运行
npm run build
node test/basic-test.js
node test/advanced-test.js
node test/interaction-test.js
node test/mcp-server-test.js
```

## 测试覆盖

### 基础功能测试
- ✅ 浏览器启动
- ✅ 页面导航
- ✅ 获取标题
- ✅ 获取HTML
- ✅ 获取链接
- ✅ 截图
- ✅ JavaScript执行
- ✅ 元素查询
- ✅ Cookie操作
- ✅ 浏览器关闭

### 高级功能测试
- ✅ 移动设备模拟
- ✅ 多页面管理
- ✅ 页面切换
- ✅ 等待操作
- ✅ 视口设置
- ✅ 滚动操作
- ✅ 元素状态检查
- ✅ LocalStorage
- ✅ 网络日志
- ✅ 性能指标
- ✅ 高级选择器
- ✅ 浏览器信息

### 交互功能测试
- ✅ 元素查找
- ✅ 文本输入
- ✅ 获取输入值
- ✅ 按键操作
- ✅ 页面导航
- ✅ 截图
- ✅ 返回/前进
- ✅ 页面刷新

### MCP服务器测试
- ✅ 服务器启动
- ✅ 工具列表查询
- ✅ 工具调用
- ✅ 服务器关闭

## 测试输出

测试运行时会输出详细的日志：

```
🧪 开始基础功能测试...

1️⃣ 测试浏览器启动...
✅ 浏览器启动成功: chromium 浏览器已启动

2️⃣ 测试页面导航...
✅ 页面导航成功: https://example.com

3️⃣ 测试获取页面标题...
✅ 页面标题: Example Domain

...

🎉 所有基础功能测试通过！
```

## 测试报告

运行 `npm test` 后会生成测试总结：

```
📊 测试总结
============================================================

✅ 通过 basic-test.js (5.23s)
✅ 通过 advanced-test.js (8.45s)
✅ 通过 interaction-test.js (6.78s)

============================================================
总计: 3 个测试
✅ 通过: 3
❌ 失败: 0
⏱️  总耗时: 20.46s
============================================================

🎉 所有测试通过！
```

## 故障排查

### 测试失败

如果测试失败，检查：

1. **浏览器未安装**
   ```bash
   npx playwright install
   ```

2. **端口被占用**
   - 关闭其他浏览器实例
   - 检查是否有其他测试在运行

3. **网络问题**
   - 确保可以访问测试网站
   - 检查代理设置

4. **权限问题**
   - 确保有写入权限（截图保存）
   - 检查文件系统权限

### 调试测试

启用详细日志：

```bash
DEBUG=playwright:* npm run test:basic
```

使用非无头模式：

修改测试文件中的 `headless: true` 为 `headless: false`

## 持续集成

### GitHub Actions

```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
      - run: npm install
      - run: npx playwright install --with-deps
      - run: npm test
```

### 本地CI

```bash
# 清理环境
rm -rf node_modules dist

# 重新安装
npm install
npx playwright install

# 运行测试
npm test
```

## 性能基准

典型测试耗时：

- 基础功能测试: ~5秒
- 高级功能测试: ~8秒
- 交互功能测试: ~7秒
- MCP服务器测试: ~2秒

总计: ~22秒

## 注意事项

1. 测试需要网络连接（访问 example.com 和 google.com）
2. 首次运行需要下载浏览器（~300MB）
3. 测试会生成截图文件（test-*.png）
4. 建议在无头模式下运行以提高速度
5. MCP服务器测试是基础验证，完整测试需要在 OpenClaw 中进行
