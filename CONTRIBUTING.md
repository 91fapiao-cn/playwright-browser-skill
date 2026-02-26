# 贡献指南

感谢你考虑为 Playwright Browser Skill 做出贡献！

## 如何贡献

### 报告 Bug

如果你发现了 bug，请创建一个 Issue 并包含：

1. 问题的详细描述
2. 重现步骤
3. 预期行为
4. 实际行为
5. 环境信息（操作系统、Node.js 版本等）
6. 相关的错误日志或截图

### 提出新功能

如果你有新功能的想法：

1. 先检查是否已有相关的 Issue
2. 创建一个新的 Issue 描述你的想法
3. 说明为什么这个功能有用
4. 如果可能，提供使用示例

### 提交代码

1. Fork 这个仓库
2. 创建你的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建一个 Pull Request

### 代码规范

- 使用 TypeScript
- 遵循现有的代码风格
- 添加适当的注释
- 更新相关文档
- 确保所有测试通过

### 提交信息规范

使用清晰的提交信息：

- `feat: 添加新功能`
- `fix: 修复 bug`
- `docs: 更新文档`
- `style: 代码格式调整`
- `refactor: 代码重构`
- `test: 添加测试`
- `chore: 构建/工具链更新`

### 测试

在提交 PR 之前，请确保：

```bash
# 运行所有测试
npm test

# 构建项目
npm run build
```

## 开发环境设置

```bash
# 克隆你的 fork
git clone https://github.com/your-username/playwright-browser-skill.git

# 安装依赖
npm install

# 安装浏览器
npm run install-browsers

# 开发模式
npm run dev
```

## 文档贡献

文档同样重要！如果你发现文档有误或可以改进：

1. 编辑相关的 Markdown 文件
2. 确保格式正确
3. 提交 PR

## 问题和讨论

- 使用 GitHub Issues 报告 bug 和提出功能请求
- 使用 GitHub Discussions 进行一般性讨论

## 行为准则

- 尊重所有贡献者
- 保持友好和专业
- 接受建设性的批评
- 关注对项目最有利的事情

## 许可证

通过贡献，你同意你的贡献将在 MIT 许可证下发布。

---

再次感谢你的贡献！🎉
