# Playwright Browser Skill API 文档

完整的浏览器自动化 API 调用方法说明。

## 目录

- [浏览器管理](#浏览器管理)
- [页面导航](#页面导航)
- [元素交互](#元素交互)
- [内容提取](#内容提取)
- [页面操作](#页面操作)
- [Cookie 管理](#cookie-管理)
- [高级功能](#高级功能)

---

## 浏览器管理

### launch(options)

启动浏览器实例。

**参数：**
```typescript
{
  browserType?: 'chromium' | 'firefox' | 'webkit',  // 浏览器类型，默认 'chromium'
  headless?: boolean,                                // 是否无头模式，默认 true
  viewport?: {                                       // 视口大小
    width: number,                                   // 宽度，默认 1280
    height: number                                   // 高度，默认 720
  }
}
```

**返回值：**
```typescript
{
  success: boolean,
  message: string  // 例如: "chromium 浏览器已启动"
}
```

**示例：**
```typescript
await skill.launch({
  browserType: 'chromium',
  headless: false,
  viewport: { width: 1920, height: 1080 }
});
```

---

### close()

关闭浏览器并释放所有资源。

**参数：** 无

**返回值：**
```typescript
{
  success: boolean,
  message: string  // "浏览器已关闭"
}
```

**示例：**
```typescript
await skill.close();
```

---

## 页面导航

### goto(url, options)

导航到指定的 URL。

**参数：**
```typescript
url: string,                                         // 目标 URL
options?: {
  waitUntil?: 'load' | 'domcontentloaded' | 'networkidle'  // 等待条件
}
```

**返回值：**
```typescript
{
  success: boolean,
  url: string  // 当前页面 URL
}
```

**示例：**
```typescript
await skill.goto('https://example.com', { waitUntil: 'networkidle' });
```

---

### goBack()

返回到上一页。

**参数：** 无

**返回值：**
```typescript
{
  success: boolean,
  url: string  // 当前页面 URL
}
```

**示例：**
```typescript
await skill.goBack();
```

---

### goForward()

前进到下一页。

**参数：** 无

**返回值：**
```typescript
{
  success: boolean,
  url: string  // 当前页面 URL
}
```

**示例：**
```typescript
await skill.goForward();
```

---

### reload()

刷新当前页面。

**参数：** 无

**返回值：**
```typescript
{
  success: boolean,
  url: string  // 当前页面 URL
}
```

**示例：**
```typescript
await skill.reload();
```

---

### waitForNavigation(options)

等待页面导航完成。

**参数：**
```typescript
{
  timeout?: number,                                  // 超时时间（毫秒）
  waitUntil?: 'load' | 'domcontentloaded'          // 等待条件
}
```

**返回值：**
```typescript
{
  success: boolean,
  url: string  // 当前页面 URL
}
```

**示例：**
```typescript
await skill.waitForNavigation({ timeout: 5000, waitUntil: 'load' });
```

---

## 元素交互

### click(selector, options)

点击指定的元素。

**参数：**
```typescript
selector: string,                                    // CSS 选择器
options?: {
  timeout?: number                                   // 超时时间（毫秒）
}
```

**返回值：**
```typescript
{
  success: boolean,
  selector: string  // 被点击的选择器
}
```

**示例：**
```typescript
await skill.click('#submit-button', { timeout: 3000 });
await skill.click('button.primary');
await skill.click('[data-testid="login-btn"]');
```

---

### fill(selector, value)

填写表单字段（清空后输入）。

**参数：**
```typescript
selector: string,                                    // CSS 选择器
value: string                                        // 要填写的值
```

**返回值：**
```typescript
{
  success: boolean,
  selector: string,
  value: string
}
```

**示例：**
```typescript
await skill.fill('#username', 'user@example.com');
await skill.fill('input[name="password"]', 'secret123');
```

---

### type(selector, text, options)

在元素中逐字符输入文本（模拟键盘输入）。

**参数：**
```typescript
selector: string,                                    // CSS 选择器
text: string,                                        // 要输入的文本
options?: {
  delay?: number                                     // 每个字符间的延迟（毫秒）
}
```

**返回值：**
```typescript
{
  success: boolean,
  selector: string,
  text: string
}
```

**示例：**
```typescript
await skill.type('#search', 'Playwright', { delay: 100 });
```

---

### select(selector, value)

选择下拉框选项。

**参数：**
```typescript
selector: string,                                    // CSS 选择器
value: string                                        // 选项的 value 值
```

**返回值：**
```typescript
{
  success: boolean,
  selector: string,
  value: string
}
```

**示例：**
```typescript
await skill.select('#country', 'US');
await skill.select('select[name="category"]', 'technology');
```

---

### waitForSelector(selector, options)

等待元素出现在 DOM 中。

**参数：**
```typescript
selector: string,                                    // CSS 选择器
options?: {
  timeout?: number,                                  // 超时时间（毫秒）
  state?: 'attached' | 'visible'                    // 等待状态
}
```

**返回值：**
```typescript
{
  success: boolean,
  selector: string
}
```

**示例：**
```typescript
await skill.waitForSelector('.loading-spinner', { state: 'visible' });
await skill.waitForSelector('#content', { timeout: 10000 });
```

---

## 内容提取

### getText(selector)

获取元素的文本内容。

**参数：**
```typescript
selector: string                                     // CSS 选择器
```

**返回值：**
```typescript
{
  success: boolean,
  text: string | null  // 元素的文本内容
}
```

**示例：**
```typescript
const result = await skill.getText('h1.title');
console.log(result.text);
```

---

### getTitle()

获取页面标题。

**参数：** 无

**返回值：**
```typescript
{
  success: boolean,
  title: string  // 页面标题
}
```

**示例：**
```typescript
const { title } = await skill.getTitle();
```

---

### getHTML()

获取整个页面的 HTML 内容。

**参数：** 无

**返回值：**
```typescript
{
  success: boolean,
  html: string  // 完整的 HTML 内容
}
```

**示例：**
```typescript
const { html } = await skill.getHTML();
```

---

### getLinks()

获取页面中所有链接。

**参数：** 无

**返回值：**
```typescript
{
  success: boolean,
  links: Array<{
    text: string | null,  // 链接文本
    href: string          // 链接地址
  }>
}
```

**示例：**
```typescript
const { links } = await skill.getLinks();
links.forEach(link => {
  console.log(`${link.text}: ${link.href}`);
});
```

---

### getAttribute(selector, attribute)

获取元素的指定属性值。

**参数：**
```typescript
selector: string,                                    // CSS 选择器
attribute: string                                    // 属性名
```

**返回值：**
```typescript
{
  success: boolean,
  attribute: string,
  value: string | null  // 属性值
}
```

**示例：**
```typescript
const result = await skill.getAttribute('img.logo', 'src');
const result2 = await skill.getAttribute('a.link', 'href');
const result3 = await skill.getAttribute('div', 'data-id');
```

---

## 页面操作

### screenshot(options)

截取页面截图。

**参数：**
```typescript
{
  path?: string,                                     // 保存路径
  fullPage?: boolean                                 // 是否截取整页
}
```

**返回值：**
```typescript
{
  success: boolean,
  screenshot: Buffer  // 截图的二进制数据
}
```

**示例：**
```typescript
await skill.screenshot({ path: 'screenshot.png', fullPage: true });
await skill.screenshot({ path: 'viewport.png', fullPage: false });
```

---

### evaluate(script)

在页面上下文中执行 JavaScript 代码。

**参数：**
```typescript
script: string                                       // JavaScript 代码字符串
```

**返回值：**
```typescript
{
  success: boolean,
  result: any  // 脚本执行结果
}
```

**示例：**
```typescript
// 获取页面文本
const { result } = await skill.evaluate('document.body.innerText');

// 获取元素数量
const { result } = await skill.evaluate('document.querySelectorAll("a").length');

// 修改页面内容
await skill.evaluate('document.querySelector("h1").style.color = "red"');

// 获取 localStorage
const { result } = await skill.evaluate('JSON.stringify(localStorage)');
```

---

## Cookie 管理

### setCookies(cookies)

设置一个或多个 Cookie。

**参数：**
```typescript
cookies: Array<{
  name: string,                                      // Cookie 名称
  value: string,                                     // Cookie 值
  domain?: string,                                   // 域名
  path?: string                                      // 路径
}>
```

**返回值：**
```typescript
{
  success: boolean,
  message: string  // "Cookies已设置"
}
```

**示例：**
```typescript
await skill.setCookies([
  { name: 'session', value: 'abc123', domain: '.example.com', path: '/' },
  { name: 'user_id', value: '12345' }
]);
```

---

### getCookies()

获取当前页面的所有 Cookie。

**参数：** 无

**返回值：**
```typescript
{
  success: boolean,
  cookies: Array<{
    name: string,
    value: string,
    domain: string,
    path: string,
    expires: number,
    httpOnly: boolean,
    secure: boolean,
    sameSite: 'Strict' | 'Lax' | 'None'
  }>
}
```

**示例：**
```typescript
const { cookies } = await skill.getCookies();
cookies.forEach(cookie => {
  console.log(`${cookie.name}: ${cookie.value}`);
});
```

---

## 高级功能

### 完整使用流程示例

```typescript
import { PlaywrightBrowserSkill } from './index.js';

const skill = new PlaywrightBrowserSkill();

// 1. 启动浏览器
await skill.launch({ 
  browserType: 'chromium', 
  headless: false 
});

// 2. 导航到登录页面
await skill.goto('https://example.com/login');

// 3. 等待表单加载
await skill.waitForSelector('#login-form');

// 4. 填写登录信息
await skill.fill('#username', 'user@example.com');
await skill.type('#password', 'mypassword', { delay: 50 });

// 5. 点击登录按钮
await skill.click('button[type="submit"]');

// 6. 等待导航完成
await skill.waitForNavigation({ waitUntil: 'networkidle' });

// 7. 验证登录成功
const { title } = await skill.getTitle();
console.log('当前页面:', title);

// 8. 获取用户信息
const { text } = await skill.getText('.user-name');
console.log('用户名:', text);

// 9. 截图保存
await skill.screenshot({ path: 'dashboard.png' });

// 10. 获取所有 Cookie
const { cookies } = await skill.getCookies();
console.log('Cookies:', cookies);

// 11. 关闭浏览器
await skill.close();
```

---

## 选择器语法

支持标准的 CSS 选择器：

```typescript
// ID 选择器
'#element-id'

// 类选择器
'.class-name'
'.class1.class2'

// 标签选择器
'div'
'button'

// 属性选择器
'[data-testid="submit"]'
'[name="username"]'
'[type="password"]'

// 组合选择器
'div.container > button.primary'
'form input[type="text"]'

// 伪类选择器
'button:first-child'
'li:nth-child(2)'
'a:not(.disabled)'

// 文本选择器（Playwright 扩展）
'text=登录'
'text=/正则表达式/'
```

---

## 错误处理

所有方法在浏览器未启动时会抛出错误：

```typescript
try {
  await skill.click('#button');
} catch (error) {
  if (error.message === '浏览器未启动') {
    await skill.launch();
    await skill.click('#button');
  }
}
```

建议使用 try-catch 包裹所有操作：

```typescript
try {
  await skill.launch();
  await skill.goto('https://example.com');
  // ... 其他操作
} catch (error) {
  console.error('操作失败:', error);
} finally {
  await skill.close();
}
```

---

## 性能优化建议

1. **复用浏览器实例**：避免频繁启动和关闭浏览器
2. **使用 headless 模式**：生产环境使用无头模式提升性能
3. **合理设置超时**：根据网络情况调整 timeout 参数
4. **使用 waitForSelector**：确保元素加载完成再操作
5. **批量操作**：尽量减少页面导航次数

---

## 常见问题

### Q: 如何处理弹窗？
```typescript
// 在 Playwright 中，对话框需要在触发前监听
// 当前 skill 可以通过 evaluate 方法处理
await skill.evaluate('window.confirm = () => true');
```

### Q: 如何等待 AJAX 请求完成？
```typescript
await skill.waitForNavigation({ waitUntil: 'networkidle' });
```

### Q: 如何处理 iframe？
```typescript
// 使用 evaluate 在 iframe 上下文中执行
await skill.evaluate(`
  const iframe = document.querySelector('iframe');
  const doc = iframe.contentDocument;
  doc.querySelector('button').click();
`);
```

### Q: 如何模拟移动设备？
```typescript
await skill.launch({
  viewport: { width: 375, height: 667 }  // iPhone 尺寸
});
```
