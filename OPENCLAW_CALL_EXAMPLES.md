# OpenClaw MCP 工具调用实例

## 📌 重要说明

OpenClaw 调用 MCP 工具有 **两种方式**：

1. **自然语言方式**（推荐，最简单）- AI 自动理解并调用工具
2. **直接指定工具**（高级用户）- 明确告诉 OpenClaw 使用哪个工具

---

## 🎯 方式 1：自然语言调用（推荐）

### 示例：browser_click

#### ❌ 不要这样说：
```
"调用 browser_click 工具，参数 selector 是 button.submit"
```

#### ✅ 应该这样说：
```
"点击提交按钮"
"点击页面上的登录按钮"
"点击 class 为 submit 的按钮"
"点击 id 为 login-btn 的元素"
```

**OpenClaw 会自动：**
1. 理解你要点击按钮
2. 选择 `browser_click` 工具
3. 构造参数 `{ "selector": "button.submit" }` 或 `{ "selector": "#login-btn" }`
4. 通过 MCP 协议调用工具

---

## 🔧 方式 2：明确指定工具（高级）

如果你想明确控制工具调用，可以这样说：

### browser_click 示例

```
你：使用 browser_click 点击选择器为 "button.submit" 的元素
```

或者更详细：

```
你：调用 browser_click 工具，参数如下：
- selector: "button.submit"
- button: "left"
- clickCount: 1
```

---

## 📚 常用工具的调用示例

### 1. browser_launch（启动浏览器）

#### 自然语言方式：
```
"启动浏览器"
"打开 Chrome 浏览器"
"启动浏览器，不要无头模式"
"启动浏览器并模拟 iPhone 13"
```

#### 明确指定方式：
```
"使用 browser_launch 启动浏览器，参数：
- browserType: chromium
- headless: false
- viewport: { width: 1920, height: 1080 }"
```

---

### 2. browser_goto（访问网页）

#### 自然语言方式：
```
"访问 example.com"
"打开 https://www.baidu.com"
"导航到 github.com"
```

#### 明确指定方式：
```
"使用 browser_goto 访问 https://example.com，等待网络空闲"
```

或：
```
"调用 browser_goto，参数：
- url: https://example.com
- waitUntil: networkidle
- timeout: 30000"
```

---

### 3. browser_click（点击元素）

#### 自然语言方式：
```
"点击提交按钮"
"点击 id 为 submit-btn 的按钮"
"右键点击菜单项"
"双击这个元素"
```

#### 明确指定方式：
```
"使用 browser_click 点击选择器 'button.submit'"
```

或：
```
"调用 browser_click，参数：
- selector: button.submit
- button: left
- clickCount: 1
- timeout: 5000"
```

---

### 4. browser_fill（填写表单）

#### 自然语言方式：
```
"在用户名输入框填写 admin@example.com"
"在密码框输入 password123"
"在搜索框填写 OpenClaw"
```

#### 明确指定方式：
```
"使用 browser_fill 在选择器 '#username' 填写 'admin@example.com'"
```

或：
```
"调用 browser_fill，参数：
- selector: #username
- value: admin@example.com"
```

---

### 5. browser_get_text（获取文本）

#### 自然语言方式：
```
"获取页面标题的文本"
"提取 h1 标签的内容"
"读取这个元素的文本"
```

#### 明确指定方式：
```
"使用 browser_get_text 获取选择器 'h1.title' 的文本"
```

或：
```
"调用 browser_get_text，参数：
- selector: h1.title"
```

---

### 6. browser_screenshot（截图）

#### 自然语言方式：
```
"截取整个页面的截图"
"截图并保存为 screenshot.png"
"截取全页截图"
```

#### 明确指定方式：
```
"使用 browser_screenshot 截取全页截图，保存为 screenshot.png"
```

或：
```
"调用 browser_screenshot，参数：
- path: screenshot.png
- fullPage: true
- type: png"
```

---

### 7. browser_wait_for_selector（等待元素）

#### 自然语言方式：
```
"等待加载完成"
"等待登录按钮出现"
"等待 class 为 content 的元素可见"
```

#### 明确指定方式：
```
"使用 browser_wait_for_selector 等待选择器 '.content' 可见"
```

或：
```
"调用 browser_wait_for_selector，参数：
- selector: .content
- timeout: 10000
- state: visible"
```

---

### 8. browser_evaluate（执行 JavaScript）

#### 自然语言方式：
```
"执行 JavaScript 获取所有 h2 标签"
"运行脚本统计页面上的图片数量"
```

#### 明确指定方式：
```
"使用 browser_evaluate 执行脚本：document.querySelectorAll('h2').length"
```

或：
```
"调用 browser_evaluate，参数：
- script: document.querySelectorAll('h2').length"
```

---

## 🔥 完整任务示例

### 示例 1：登录网站（自然语言）

```
你：帮我登录 example.com，用户名是 admin@example.com，密码是 password123

OpenClaw 会自动执行：
1. browser_launch()
2. browser_goto({ url: "https://example.com/login" })
3. browser_wait_for_selector({ selector: "#username" })
4. browser_fill({ selector: "#username", value: "admin@example.com" })
5. browser_fill({ selector: "#password", value: "password123" })
6. browser_click({ selector: "button[type='submit']" })
7. browser_wait_for_url({ url: "**/dashboard" })
8. browser_close()
```

### 示例 2：登录网站（明确指定）

```
你：执行以下步骤：
1. 使用 browser_launch 启动浏览器
2. 使用 browser_goto 访问 https://example.com/login
3. 使用 browser_fill 在 #username 填写 admin@example.com
4. 使用 browser_fill 在 #password 填写 password123
5. 使用 browser_click 点击 button[type='submit']
6. 使用 browser_close 关闭浏览器

OpenClaw 会按顺序执行这些工具
```

---

## 💡 实际对话示例

### 对话 1：简单网页访问

```
你：访问 example.com 并获取页面标题

OpenClaw：好的，我来帮你访问 example.com 并获取标题。
[自动调用 browser_launch]
[自动调用 browser_goto]
[自动调用 browser_get_title]
[自动调用 browser_close]

OpenClaw：页面标题是："Example Domain"
```

### 对话 2：表单填写

```
你：在百度搜索 'OpenClaw'

OpenClaw：好的，我来帮你在百度搜索。
[自动调用 browser_launch]
[自动调用 browser_goto({ url: "https://www.baidu.com" })]
[自动调用 browser_fill({ selector: "#kw", value: "OpenClaw" })]
[自动调用 browser_click({ selector: "#su" })]
[自动调用 browser_wait_for_selector({ selector: ".result" })]

OpenClaw：搜索完成，找到了相关结果。
```

### 对话 3：数据提取

```
你：从 news.ycombinator.com 提取前5条新闻标题

OpenClaw：好的，我来提取 Hacker News 的新闻标题。
[自动调用 browser_launch]
[自动调用 browser_goto({ url: "https://news.ycombinator.com" })]
[自动调用 browser_wait_for_selector({ selector: ".itemlist" })]
[自动调用 browser_evaluate({ script: "..." })]
[自动调用 browser_close]

OpenClaw：提取到的新闻标题：
1. ...
2. ...
3. ...
```

---

## 🎨 选择器语法参考

在使用 `browser_click`、`browser_fill` 等需要选择器的工具时，可以使用以下语法：

### CSS 选择器

```css
/* ID 选择器 */
#element-id
示例："点击 id 为 submit-btn 的按钮"

/* Class 选择器 */
.class-name
示例："点击 class 为 submit 的按钮"

/* 标签选择器 */
button
示例："点击第一个 button 元素"

/* 属性选择器 */
[type="submit"]
示例："点击 type 为 submit 的按钮"

/* 组合选择器 */
form button.submit
示例："点击表单中 class 为 submit 的按钮"
```

### 自然语言描述（推荐）

OpenClaw 的 AI 可以理解自然语言描述，自动转换为正确的选择器：

```
"点击提交按钮" → 自动识别为 button[type="submit"] 或 .submit-btn
"在用户名输入框填写" → 自动识别为 #username 或 input[name="username"]
"点击登录链接" → 自动识别为 a 标签包含 "登录" 文本
```

---

## 🔍 如何知道 OpenClaw 调用了哪些工具？

### 方法 1：查看 OpenClaw 响应

OpenClaw 通常会告诉你它执行了什么操作：

```
OpenClaw：我已经启动浏览器并访问了 example.com...
```

### 方法 2：查看 MCP 服务器日志

MCP 服务器会记录所有工具调用：

```powershell
# 查看 MCP 服务器输出
Get-Process -Name node | Where-Object { $_.MainWindowTitle -like "*MCP*" }
```

### 方法 3：使用调试模式

在 OpenClaw 中启用调试模式，可以看到详细的工具调用信息。

---

## ⚠️ 常见错误和解决方案

### 错误 1：工具调用失败

```
错误信息：browser_click 失败，元素未找到

原因：
- 浏览器未启动
- 选择器错误
- 元素未加载完成

解决方案：
1. 确保先调用 browser_launch
2. 使用 browser_wait_for_selector 等待元素
3. 检查选择器是否正确
```

### 错误 2：参数错误

```
错误信息：参数 selector 是必需的

原因：
- 缺少必需参数

解决方案：
- 使用自然语言方式，让 AI 自动填充参数
- 或明确指定所有必需参数
```

### 错误 3：浏览器未启动

```
错误信息：浏览器未连接

原因：
- 未调用 browser_launch

解决方案：
- 任何操作前先说"启动浏览器"
```

---

## 📊 工具调用优先级建议

### 推荐顺序：

1. **自然语言描述**（最简单）
   ```
   "访问网站并点击按钮"
   ```

2. **半自然语言**（稍微具体）
   ```
   "访问 example.com 并点击 class 为 submit 的按钮"
   ```

3. **明确工具名**（更精确）
   ```
   "使用 browser_click 点击 button.submit"
   ```

4. **完整参数指定**（最精确）
   ```
   "调用 browser_click，参数 selector: button.submit, timeout: 5000"
   ```

### 建议：

- 🥇 **日常使用**：使用自然语言（方式 1）
- 🥈 **需要精确控制**：使用半自然语言（方式 2）
- 🥉 **调试或特殊需求**：明确指定工具和参数（方式 3-4）

---

## 🎓 学习路径

### 初学者：
1. 从简单的自然语言开始："访问网站"、"点击按钮"
2. 观察 OpenClaw 如何理解和执行
3. 逐步学习更具体的描述

### 进阶用户：
1. 学习 CSS 选择器语法
2. 了解各个工具的参数
3. 尝试明确指定工具名称

### 高级用户：
1. 阅读 `tools-registry.ts` 了解所有工具
2. 查看 `SKILL.md` 了解详细参数
3. 编写复杂的自动化脚本

---

## ✅ 快速参考卡片

### browser_click
```
自然语言："点击提交按钮"
明确指定："使用 browser_click 点击 button.submit"
参数：selector (必需), button, clickCount, timeout
```

### browser_fill
```
自然语言："在用户名框填写 admin"
明确指定："使用 browser_fill 在 #username 填写 admin"
参数：selector (必需), value (必需)
```

### browser_goto
```
自然语言："访问 example.com"
明确指定："使用 browser_goto 访问 https://example.com"
参数：url (必需), waitUntil, timeout
```

### browser_screenshot
```
自然语言："截取整页截图"
明确指定："使用 browser_screenshot 截图，fullPage: true"
参数：path, fullPage, type, quality
```

---

**记住：OpenClaw 的强大之处在于理解自然语言，所以大多数情况下，你只需要用人类的方式描述你的需求即可！**

---

**版本：** 2.1.0  
**更新日期：** 2024-03-01  
**适用于：** OpenClaw + Playwright Browser Skill
