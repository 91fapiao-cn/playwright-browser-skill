import { PlaywrightBrowserSkill } from '../src/index.js';

async function testInteractionFunctionality() {
  console.log('🧪 开始交互功能测试...\n');
  
  const browser = new PlaywrightBrowserSkill();
  
  try {
    console.log('1️⃣ 启动浏览器...');
    await browser.launch({ headless: true });
    console.log('✅ 浏览器已启动');
    
    // 访问测试页面
    console.log('\n2️⃣ 访问测试页面...');
    await browser.goto('https://pangxiaoyu.com');
    console.log('✅ 页面加载完成');
    
    // 测试获取页面标题
    console.log('\n3️⃣ 测试获取页面标题...');
    const title = await browser.getTitle();
    console.log('✅ 页面标题:', title.title);
    
    // 测试获取页面HTML
    console.log('\n4️⃣ 测试获取页面HTML...');
    const html = await browser.getHTML();
    console.log('✅ HTML长度:', html.html.length, '字符');
    
    // 测试获取所有链接
    console.log('\n5️⃣ 测试获取所有链接...');
    const links = await browser.getLinks();
    console.log('✅ 找到链接数量:', links.links.length);
    
    // 测试截图
    console.log('\n6️⃣ 测试页面截图...');
    await browser.screenshot({ 
      path: './test-screenshot.png',
      fullPage: true 
    });
    console.log('✅ 截图保存成功');
    
    // 测试JavaScript执行
    console.log('\n7️⃣ 测试JavaScript执行...');
    const jsResult = await browser.evaluate('document.title');
    console.log('✅ JavaScript执行结果:', jsResult.result);
    
    // 测试元素查找
    console.log('\n8️⃣ 测试元素查找...');
    const bodyText = await browser.getText('body');
    console.log('✅ 页面文本长度:', bodyText.text?.length || 0, '字符');
    
    // 测试等待操作
    console.log('\n9️⃣ 测试等待操作...');
    await browser.waitForTimeout(1000);
    console.log('✅ 等待成功');
    
    // 测试刷新
    console.log('\n🔟 测试页面刷新...');
    await browser.reload();
    await browser.waitForTimeout(1000);
    console.log('✅ 页面刷新成功');
    
    // 测试获取当前URL
    console.log('\n1️⃣1️⃣ 测试获取当前URL...');
    const currentUrl = await browser.getCurrentURL();
    console.log('✅ 当前URL:', currentUrl.url);
    
    // 清理
    console.log('\n🧹 清理测试环境...');
    await browser.close();
    console.log('✅ 清理完成');
    
    console.log('\n🎉 所有交互功能测试通过！');
    return true;
    
  } catch (error: any) {
    console.error('\n❌ 测试失败:', error.message);
    console.error(error.stack);
    
    try {
      await browser.close();
    } catch (e) {
      // 忽略清理错误
    }
    
    return false;
  }
}

// 运行测试
testInteractionFunctionality().then(success => {
  process.exit(success ? 0 : 1);
});
