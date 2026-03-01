# OpenClaw MCP 工具调用完整参考

## 📋 概述

本文档详细说明如何在 OpenClaw 中调用 Playwright Browser Skill 的 101 个 MCP 工具。

### 重要说明

1. **MCP 技能已注册** - 当技能状态显示 "Ready"（已注册成功）时，说明 MCP 服务器已正确配置
2. **自然语言调用** - OpenClaw 通过 AI 理解你的自然语言需求，自动选择合适的 MCP 工具
3. **无需记忆工具名** - 你不需要记住具体的工具名称，直接描述你的需求即可
4. **MCP 协议通信** - OpenClaw 通过 MCP 协议与技能通信，使用 `tools/list` 和 `tools/call` 方法

---

## 🎯 如何在 OpenClaw 中使用

### 方式 1：自然语言描述（推荐）

直接用自然语言告诉 OpenClaw 你的需求，AI 会自动选择合适的工具。

**示例对话：**

```
你：帮我访问 example.com 并获取页面标题
OpenClaw：会自动调用 browser_launch → browser_goto → browser_get_title → browser_close

你：打开百度搜索 'OpenClaw'
OpenClaw：会自动调用相应的工具完成搜索操作

你：访问 github.com 并截图
OpenClaw：会自动调用 browser_launch → browser_goto → browser_screenshot → browser_close
```

### 方式 2：明确指定工具（高级用户）

如果你熟悉工具名称，可以明确指定要使用的工具。

**示例：**

```
你：使用 browser_launch 启动 Chrome 浏览器，headless 模式关闭
你：调用 browser_goto 访问 https://example.com
你：执行 browser_get_title 获取页面标题
```

---

## 📚 完整工具列表（101个）

### 1. 浏览器管理（8个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_launch` | 启动浏览器 | 开始任何浏览器操作前必须调用 |
| `browser_close` | 关闭浏览器 | 完成操作后释放资源 |
| `browser_new_page` | 创建新页面 | 需要打开多个标签页时 |
| `browser_switch_page` | 切换页面 | 在多个标签页间切换 |
| `browser_close_page` | 关闭页面 | 关闭指定标签页 |
| `browser_get_all_pages` | 获取所有页面 | 查看当前打开的所有标签页 |
| `browser_get_version` | 获取浏览器版本 | 调试或兼容性检查 |
| `browser_is_connected` | 检查连接状态 | 确认浏览器是否正常运行 |

**自然语言示例：**
- "启动浏览器"
- "打开一个新标签页"
- "关闭浏览器"
- "切换到第二个标签页"

---

### 2. 页面导航（4个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_goto` | 访问URL | 打开任何网页 |
| `browser_go_back` | 返回上一页 | 浏览器后退 |
| `browser_go_forward` | 前进下一页 | 浏览器前进 |
| `browser_reload` | 刷新页面 | 重新加载当前页面 |

**自然语言示例：**
- "访问 example.com"
- "打开 https://www.baidu.com"
- "返回上一页"
- "刷新页面"

---

### 3. 元素交互（12个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_click` | 点击元素 | 点击按钮、链接等 |
| `browser_dblclick` | 双击元素 | 需要双击操作时 |
| `browser_hover` | 鼠标悬停 | 触发悬停效果 |
| `browser_fill` | 填写表单 | 快速填写输入框 |
| `browser_type` | 逐字符输入 | 模拟真实键盘输入 |
| `browser_press` | 按键 | 按下特定按键（Enter、Tab等） |
| `browser_select` | 选择下拉框 | 选择下拉菜单选项 |
| `browser_check` | 勾选复选框 | 勾选checkbox |
| `browser_uncheck` | 取消勾选 | 取消勾选checkbox |
| `browser_focus` | 聚焦元素 | 将焦点移到元素上 |
| `browser_drag` | 拖拽元素 | 拖放操作 |
| `browser_tap` | 触摸点击 | 移动端触摸操作 |

**自然语言示例：**
- "点击提交按钮"
- "在搜索框输入 'OpenClaw'"
- "勾选同意条款的复选框"
- "选择国家下拉框中的 '中国'"
- "按下回车键"

---

### 4. 键盘鼠标操作（8个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_keyboard_down` | 按下按键 | 组合键操作（如Ctrl+C） |
| `browser_keyboard_up` | 释放按键 | 组合键操作 |
| `browser_mouse_move` | 移动鼠标 | 精确控制鼠标位置 |
| `browser_mouse_click` | 点击坐标 | 点击特定坐标 |
| `browser_mouse_down` | 按下鼠标 | 拖拽操作的开始 |
| `browser_mouse_up` | 释放鼠标 | 拖拽操作的结束 |
| `browser_mouse_wheel` | 鼠标滚轮 | 滚动页面 |
| `browser_keyboard_insert_text` | 插入文本 | 直接设置输入框值 |

**自然语言示例：**
- "按下 Shift 键"
- "移动鼠标到坐标 (100, 200)"
- "向下滚动 500 像素"
- "按住 Ctrl 键并点击链接"

---

### 5. 内容提取（11个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_get_text` | 获取元素文本 | 提取文本内容 |
| `browser_get_title` | 获取页面标题 | 获取网页标题 |
| `browser_get_html` | 获取HTML | 获取页面源代码 |
| `browser_get_links` | 获取所有链接 | 提取页面所有链接 |
| `browser_get_attribute` | 获取元素属性 | 获取href、src等属性 |
| `browser_get_input_value` | 获取输入框值 | 读取表单输入值 |
| `browser_is_visible` | 检查可见性 | 判断元素是否可见 |
| `browser_is_enabled` | 检查启用状态 | 判断元素是否可用 |
| `browser_is_checked` | 检查选中状态 | 判断复选框是否选中 |
| `browser_count` | 统计元素数量 | 计算匹配元素个数 |
| `browser_get_current_url` | 获取当前URL | 获取当前页面地址 |

**自然语言示例：**
- "获取页面标题"
- "提取所有链接"
- "获取这个按钮的文本"
- "检查这个元素是否可见"
- "统计页面上有多少个图片"

---

### 6. 高级选择器（7个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_get_by_role` | 通过角色查找 | 使用ARIA角色定位 |
| `browser_get_by_text` | 通过文本查找 | 根据文本内容定位 |
| `browser_get_by_label` | 通过标签查找 | 根据表单标签定位 |
| `browser_get_by_placeholder` | 通过占位符查找 | 根据placeholder定位 |
| `browser_get_by_test_id` | 通过测试ID查找 | 使用data-testid定位 |
| `browser_get_by_alt_text` | 通过alt文本查找 | 根据图片alt属性定位 |
| `browser_get_by_title` | 通过title查找 | 根据title属性定位 |

**自然语言示例：**
- "找到文本为 '登录' 的按钮"
- "找到标签为 '用户名' 的输入框"
- "找到占位符为 '请输入邮箱' 的输入框"

---

### 7. 等待操作（7个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_wait_for_selector` | 等待元素出现 | 等待动态加载的元素 |
| `browser_wait_for_timeout` | 等待指定时间 | 固定时间等待 |
| `browser_wait_for_url` | 等待URL匹配 | 等待页面跳转 |
| `browser_wait_for_request` | 等待网络请求 | 等待API请求发出 |
| `browser_wait_for_response` | 等待网络响应 | 等待API响应返回 |
| `browser_wait_for_function` | 等待函数返回true | 自定义等待条件 |
| `browser_wait_for_load_state` | 等待加载状态 | 等待页面加载完成 |

**自然语言示例：**
- "等待加载完成"
- "等待登录按钮出现"
- "等待3秒"
- "等待页面跳转到首页"

---

### 8. 截图和PDF（3个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_screenshot` | 截取页面截图 | 保存页面截图 |
| `browser_screenshot_element` | 截取元素截图 | 截取特定元素 |
| `browser_pdf` | 生成PDF | 将页面保存为PDF |

**自然语言示例：**
- "截取整个页面的截图"
- "截取这个图表的截图"
- "将页面保存为PDF"

---

### 9. JavaScript执行（3个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_evaluate` | 执行JavaScript | 在页面上下文执行代码 |
| `browser_add_script_tag` | 添加脚本标签 | 注入外部脚本 |
| `browser_add_style_tag` | 添加样式标签 | 注入自定义样式 |

**自然语言示例：**
- "执行JavaScript代码获取所有h2标签"
- "注入jQuery库"
- "添加自定义CSS样式"

---

### 10. Cookie和存储（8个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_set_cookies` | 设置Cookie | 设置登录状态等 |
| `browser_get_cookies` | 获取Cookie | 读取Cookie信息 |
| `browser_clear_cookies` | 清除Cookie | 清空所有Cookie |
| `browser_set_local_storage` | 设置LocalStorage | 设置本地存储 |
| `browser_get_local_storage` | 获取LocalStorage | 读取本地存储 |
| `browser_clear_local_storage` | 清除LocalStorage | 清空本地存储 |
| `browser_storage_state` | 保存存储状态 | 保存登录状态 |
| `browser_restore_storage_state` | 恢复存储状态 | 恢复登录状态 |

**自然语言示例：**
- "设置登录Cookie"
- "获取所有Cookie"
- "清除浏览器缓存"
- "保存当前登录状态"

---

### 11. 网络控制（7个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_set_offline` | 设置离线模式 | 测试离线功能 |
| `browser_block_requests` | 拦截请求 | 阻止广告、图片等 |
| `browser_mock_response` | 模拟响应 | 模拟API响应 |
| `browser_get_request_logs` | 获取请求日志 | 查看网络请求 |
| `browser_get_response_logs` | 获取响应日志 | 查看网络响应 |
| `browser_get_console_logs` | 获取控制台日志 | 查看console输出 |
| `browser_clear_logs` | 清除日志 | 清空所有日志 |

**自然语言示例：**
- "拦截所有图片请求"
- "模拟API返回错误"
- "查看网络请求日志"
- "获取控制台错误信息"

---

### 12. 文件操作（2个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_upload_file` | 上传文件 | 文件上传操作 |
| `browser_download_file` | 下载文件 | 触发文件下载 |

**自然语言示例：**
- "上传文件到这个表单"
- "点击下载按钮并保存文件"

---

### 13. 视口和设备（6个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_set_viewport_size` | 设置视口大小 | 调整窗口尺寸 |
| `browser_get_viewport_size` | 获取视口大小 | 查看当前窗口尺寸 |
| `browser_emulate_media` | 模拟媒体类型 | 测试深色模式等 |
| `browser_set_geolocation` | 设置地理位置 | 模拟GPS位置 |
| `browser_clear_geolocation` | 清除地理位置 | 清除位置设置 |
| `browser_touchscreen_tap` | 触摸屏点击 | 移动端触摸操作 |

**自然语言示例：**
- "设置窗口大小为 1920x1080"
- "模拟iPhone 13设备"
- "设置地理位置为北京"
- "切换到深色模式"

---

### 14. 滚动操作（2个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_scroll_to` | 滚动到坐标 | 滚动到特定位置 |
| `browser_scroll_into_view` | 滚动元素到可见 | 将元素滚动到视野内 |

**自然语言示例：**
- "滚动到页面底部"
- "将这个元素滚动到可见区域"

---

### 15. 性能指标（3个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_get_metrics` | 获取性能指标 | 性能监控 |
| `browser_get_coverage` | 开始代码覆盖率 | 测试代码覆盖 |
| `browser_stop_coverage` | 停止代码覆盖率 | 结束覆盖率收集 |

**自然语言示例：**
- "获取页面加载性能数据"
- "开始收集代码覆盖率"

---

### 16. 无障碍功能（1个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_get_accessibility_snapshot` | 获取无障碍快照 | 无障碍测试 |

**自然语言示例：**
- "获取页面的无障碍树结构"

---

### 17. 时间控制（5个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_install_clock` | 安装时钟控制 | 测试时间相关功能 |
| `browser_set_system_time` | 设置系统时间 | 模拟特定时间 |
| `browser_fast_forward` | 快进时间 | 跳过等待时间 |
| `browser_pause_clock` | 暂停时钟 | 冻结时间 |
| `browser_resume_clock` | 恢复时钟 | 恢复时间流动 |

**自然语言示例：**
- "将系统时间设置为2024年1月1日"
- "快进1小时"
- "暂停时间"

---

### 18. 权限管理（2个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_grant_permissions` | 授予权限 | 授予地理位置、通知等权限 |
| `browser_clear_permissions` | 清除权限 | 清除所有权限 |

**自然语言示例：**
- "授予地理位置权限"
- "授予摄像头和麦克风权限"
- "清除所有权限"

---

### 19. 对话框处理（1个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_handle_dialog` | 处理对话框 | 处理alert、confirm、prompt |

**自然语言示例：**
- "点击确定按钮"
- "在弹窗中输入文本"
- "取消对话框"

---

### 20. Frame操作（1个工具）

| 工具名称 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `browser_get_frames` | 获取所有frame | 处理iframe |

**自然语言示例：**
- "获取页面中的所有iframe"

---

## 🔥 常见使用场景完整示例

### 场景 1：网页内容提取

**用户需求：** "帮我访问 example.com 并提取页面标题和所有链接"

**OpenClaw 自动执行的工具序列：**
```
1. browser_launch({ "headless": false })
2. browser_goto({ "url": "https://example.com", "waitUntil": "networkidle" })
3. browser_get_title()
4. browser_get_links()
5. browser_close()
```

**你只需说：** "访问 example.com 并提取标题和链接"

---

### 场景 2：表单自动填写

**用户需求：** "帮我在登录页面填写用户名和密码"

**OpenClaw 自动执行的工具序列：**
```
1. browser_launch()
2. browser_goto({ "url": "https://example.com/login" })
3. browser_wait_for_selector({ "selector": "#username" })
4. browser_fill({ "selector": "#username", "value": "user@example.com" })
5. browser_fill({ "selector": "#password", "value": "password123" })
6. browser_click({ "selector": "button[type='submit']" })
7. browser_wait_for_url({ "url": "**/dashboard" })
8. browser_close()
```

**你只需说：** "在登录页面填写用户名 user@example.com 和密码 password123 并登录"

---

### 场景 3：网页截图

**用户需求：** "截取 github.com 首页的完整截图"

**OpenClaw 自动执行的工具序列：**
```
1. browser_launch({ "headless": false })
2. browser_goto({ "url": "https://github.com" })
3. browser_wait_for_load_state({ "state": "networkidle" })
4. browser_screenshot({ "path": "github-homepage.png", "fullPage": true })
5. browser_close()
```

**你只需说：** "截取 github.com 首页的完整截图"

---

### 场景 4：数据抓取

**用户需求：** "从 Hacker News 提取前10条新闻标题"

**OpenClaw 自动执行的工具序列：**
```
1. browser_launch()
2. browser_goto({ "url": "https://news.ycombinator.com" })
3. browser_wait_for_selector({ "selector": ".itemlist" })
4. browser_evaluate({ 
     "script": "Array.from(document.querySelectorAll('.titleline > a')).slice(0, 10).map(a => ({ title: a.textContent, url: a.href }))"
   })
5. browser_close()
```

**你只需说：** "从 Hacker News 提取前10条新闻标题"

---

### 场景 5：移动设备模拟

**用户需求：** "用 iPhone 13 访问网站并截图"

**OpenClaw 自动执行的工具序列：**
```
1. browser_launch({ "deviceName": "iPhone 13", "headless": false })
2. browser_goto({ "url": "https://example.com" })
3. browser_wait_for_load_state({ "state": "networkidle" })
4. browser_screenshot({ "path": "mobile-view.png" })
5. browser_close()
```

**你只需说：** "用 iPhone 13 模拟访问 example.com 并截图"

---

## 💡 使用技巧

### 1. 自然语言优先
- ✅ 推荐："帮我访问百度并搜索 'OpenClaw'"
- ❌ 不推荐："调用 browser_launch 然后 browser_goto 然后..."

### 2. 描述清晰具体
- ✅ 推荐："在用户名输入框填写 admin@example.com"
- ❌ 不推荐："填写表单"

### 3. 一次描述完整任务
- ✅ 推荐："访问 example.com，点击登录按钮，填写用户名和密码，然后提交"
- ❌ 不推荐：分多次说"访问网站"、"点击按钮"、"填写表单"...

### 4. 让 AI 处理细节
- ✅ 推荐："提取页面所有产品信息"
- ❌ 不推荐："使用 browser_evaluate 执行 document.querySelectorAll..."

---

## 🔍 调试和故障排除

### 问题 1：MCP 技能未注册

**症状：** OpenClaw 显示 "MCP 未注册"

**解决方案：**
1. 检查 `mcp.json` 配置是否正确
2. 确认 MCP 服务器路径正确
3. 重启 OpenClaw Gateway
4. 查看 MCP 服务器日志

### 问题 2：工具调用失败

**症状：** 工具执行返回错误

**解决方案：**
1. 确认浏览器已启动（先调用 `browser_launch`）
2. 检查选择器是否正确
3. 增加等待时间（使用 `browser_wait_for_selector`）
4. 查看控制台日志（使用 `browser_get_console_logs`）

### 问题 3：元素找不到

**症状：** 提示元素不存在

**解决方案：**
1. 使用 `browser_wait_for_selector` 等待元素加载
2. 检查选择器语法是否正确
3. 使用 `browser_screenshot` 查看页面状态
4. 尝试使用高级选择器（`browser_get_by_text` 等）

---

## 📖 参考资料

- **SKILL.md** - 完整的工具文档和参数说明
- **tools-registry.ts** - 工具定义源代码
- **Playwright 官方文档** - https://playwright.dev
- **MCP 协议文档** - Model Context Protocol 规范

---

## 📊 工具统计

- **总工具数：** 101个
- **浏览器管理：** 8个
- **页面导航：** 4个
- **元素交互：** 12个
- **键盘鼠标：** 8个
- **内容提取：** 11个
- **高级选择器：** 7个
- **等待操作：** 7个
- **截图PDF：** 3个
- **JavaScript：** 3个
- **Cookie存储：** 8个
- **网络控制：** 7个
- **文件操作：** 2个
- **视口设备：** 6个
- **滚动操作：** 2个
- **性能指标：** 3个
- **无障碍：** 1个
- **时间控制：** 5个
- **权限管理：** 2个
- **对话框：** 1个
- **Frame：** 1个

---

## ✅ 快速开始检查清单

- [ ] MCP 服务器已启动（端口 18789 监听）
- [ ] OpenClaw Gateway 正在运行
- [ ] 技能状态显示 "Ready"（已注册）
- [ ] `mcp.json` 配置正确
- [ ] 可以用自然语言描述需求

**一切就绪！开始使用吧！**

---

**版本：** 2.1.0  
**更新日期：** 2024-03-01  
**适用于：** OpenClaw + Playwright Browser Skill
