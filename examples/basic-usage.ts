import { PlaywrightBrowserSkill } from '../src/index.js';

async function main() {
  const browser = new PlaywrightBrowserSkill();

  try {
    // 启动浏览器
    console.log('启动浏览器...');
    await browser.launch({ 
      browserType: 'chromium', 
      headless: false 
    });

    // 访问网页
    console.log('访问网页...');
    await browser.goto('https://example.com');

    // 获取标题
    const { title } = await browser.getTitle();
    console.log('页面标题:', title);

    // 获取所有链接
    const { links } = await browser.getLinks();
    console.log('页面链接数量:', links.length);

    // 截图
    await browser.screenshot({ 
      path: 'example-screenshot.png', 
      fullPage: true 
    });
    console.log('截图已保存');

    // 执行JavaScript
    const { result } = await browser.evaluate('document.body.innerText');
    console.log('页面文本长度:', (result as string).length);

  } catch (error) {
    console.error('错误:', error);
  } finally {
    // 关闭浏览器
    await browser.close();
    console.log('浏览器已关闭');
  }
}

main();
