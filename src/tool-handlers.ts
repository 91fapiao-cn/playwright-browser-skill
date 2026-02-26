import { PlaywrightBrowserSkill } from './index.js';

export async function handleToolCall(browser: PlaywrightBrowserSkill, name: string, args: any) {
  switch (name) {
    // 浏览器管理
    case 'browser_launch': return await browser.launch(args);
    case 'browser_close': return await browser.close();
    case 'browser_new_page': return await browser.newPage();
    case 'browser_switch_page': return await browser.switchPage(args.index);
    case 'browser_close_page': return await browser.closePage(args.index);
    case 'browser_get_all_pages': return await browser.getAllPages();
    case 'browser_get_version': return await browser.getBrowserVersion();
    case 'browser_is_connected': return await browser.isConnected();

    // 页面导航
    case 'browser_goto': return await browser.goto(args.url, args);
    case 'browser_go_back': return await browser.goBack();
    case 'browser_go_forward': return await browser.goForward();
    case 'browser_reload': return await browser.reload();

    // 元素交互
    case 'browser_click': return await browser.click(args.selector, args);
    case 'browser_dblclick': return await browser.dblclick(args.selector);
    case 'browser_hover': return await browser.hover(args.selector);
    case 'browser_fill': return await browser.fill(args.selector, args.value);
    case 'browser_type': return await browser.type(args.selector, args.text, args);
    case 'browser_press': return await browser.press(args.selector, args.key);
    case 'browser_select': return await browser.select(args.selector, args.value);
    case 'browser_check': return await browser.check(args.selector);
    case 'browser_uncheck': return await browser.uncheck(args.selector);
    case 'browser_focus': return await browser.focus(args.selector);
    case 'browser_drag': return await browser.drag(args.sourceSelector, args.targetSelector);
    case 'browser_tap': return await browser.tap(args.selector);

    // 键盘鼠标
    case 'browser_keyboard_down': return await browser.keyboardDown(args.key);
    case 'browser_keyboard_up': return await browser.keyboardUp(args.key);
    case 'browser_mouse_move': return await browser.mouseMove(args.x, args.y, args.steps);
    case 'browser_mouse_click': return await browser.mouseClick(args.x, args.y, args);
    case 'browser_mouse_wheel': return await browser.mouseWheel(args.deltaX, args.deltaY);

    // 内容提取
    case 'browser_get_text': return await browser.getText(args.selector);
    case 'browser_get_title': return await browser.getTitle();
    case 'browser_get_html': return await browser.getHTML();
    case 'browser_get_links': return await browser.getLinks();
    case 'browser_get_attribute': return await browser.getAttribute(args.selector, args.attribute);
    case 'browser_get_input_value': return await browser.getInputValue(args.selector);
    case 'browser_is_visible': return await browser.isVisible(args.selector);
    case 'browser_is_enabled': return await browser.isEnabled(args.selector);
    case 'browser_is_checked': return await browser.isChecked(args.selector);
    case 'browser_count': return await browser.count(args.selector);
    case 'browser_get_current_url': return await browser.getCurrentURL();

    // 高级选择器
    case 'browser_get_by_role': return await browser.getByRole(args.role, args);
    case 'browser_get_by_text': return await browser.getByText(args.text, args);
    case 'browser_get_by_label': return await browser.getByLabel(args.text, args);
    case 'browser_get_by_placeholder': return await browser.getByPlaceholder(args.text, args);
    case 'browser_get_by_test_id': return await browser.getByTestId(args.testId);

    // 等待操作
    case 'browser_wait_for_selector': return await browser.waitForSelector(args.selector, args);
    case 'browser_wait_for_timeout': return await browser.waitForTimeout(args.timeout);
    case 'browser_wait_for_url': return await browser.waitForURL(args.url, args);
    case 'browser_wait_for_request': return await browser.waitForRequest(args.urlPattern, args.timeout);
    case 'browser_wait_for_response': return await browser.waitForResponse(args.urlPattern, args.timeout);

    // 截图和PDF
    case 'browser_screenshot': return await browser.screenshot(args);
    case 'browser_screenshot_element': return await browser.screenshotElement(args.selector, args);
    case 'browser_pdf': return await browser.pdf(args);

    // JavaScript执行
    case 'browser_evaluate': return await browser.evaluate(args.script, args.arg);
    case 'browser_add_script_tag': return await browser.addScriptTag(args);
    case 'browser_add_style_tag': return await browser.addStyleTag(args);

    // Cookie和存储
    case 'browser_set_cookies': return await browser.setCookies(args.cookies);
    case 'browser_get_cookies': return await browser.getCookies();
    case 'browser_clear_cookies': return await browser.clearCookies();
    case 'browser_set_local_storage': return await browser.setLocalStorage(args.key, args.value);
    case 'browser_get_local_storage': return await browser.getLocalStorage(args.key);
    case 'browser_clear_local_storage': return await browser.clearLocalStorage();
    case 'browser_storage_state': return await browser.storageState(args.path);
    case 'browser_restore_storage_state': return await browser.restoreStorageState(args.state);

    // 网络控制
    case 'browser_set_offline': return await browser.setOffline(args.offline);
    case 'browser_block_requests': return await browser.blockRequests(args.patterns);
    case 'browser_mock_response': return await browser.mockResponse(args.urlPattern, args.response);
    case 'browser_get_request_logs': return await browser.getRequestLogs(args.limit);
    case 'browser_get_response_logs': return await browser.getResponseLogs(args.limit);
    case 'browser_get_console_logs': return await browser.getConsoleLogs(args.limit);
    case 'browser_clear_logs': return await browser.clearLogs();

    // 文件操作
    case 'browser_upload_file': return await browser.uploadFile(args.selector, args.filePath);
    case 'browser_download_file': return await browser.downloadFile(args.triggerSelector);

    // Frame操作
    case 'browser_get_frames': return await browser.getFrames();

    // 视口和设备
    case 'browser_set_viewport_size': return await browser.setViewportSize(args.width, args.height);
    case 'browser_get_viewport_size': return await browser.getViewportSize();
    case 'browser_emulate_media': return await browser.emulateMedia(args);
    case 'browser_set_geolocation': return await browser.setGeolocation(args.latitude, args.longitude, args.accuracy);

    // 滚动操作
    case 'browser_scroll_to': return await browser.scrollTo(args.x, args.y);
    case 'browser_scroll_into_view': return await browser.scrollIntoView(args.selector);

    // 对话框处理
    case 'browser_handle_dialog': return await browser.handleDialog(args.action, args.promptText);

    // 性能和指标
    case 'browser_get_metrics': return await browser.getMetrics();

    // 无障碍
    case 'browser_get_accessibility_snapshot': return await browser.getAccessibilitySnapshot(args.selector);

    // 时间控制
    case 'browser_install_clock': return await browser.installClock(args.time);
    case 'browser_set_system_time': return await browser.setSystemTime(args.time);
    case 'browser_fast_forward': return await browser.fastForward(args.time);

    // 权限管理
    case 'browser_grant_permissions': return await browser.grantPermissions(args.permissions, args);
    case 'browser_clear_permissions': return await browser.clearPermissions();

    default:
      throw new Error(`未知工具: ${name}`);
  }
}
