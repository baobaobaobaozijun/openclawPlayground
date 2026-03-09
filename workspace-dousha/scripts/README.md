# 豆沙工作台 - 脚本和工具

## 📁 目录结构

```
workspace-dousha/
├── scripts/          # PowerShell 和 Bash 脚本
│   ├── README.md
│   └── ...
└── guides/           # 使用指南和文档
    ├── README.md
    └── ...
```

---

## 🛠️ Scripts - 自动化脚本

### PowerShell 脚本

#### 1. 前端环境初始化
```powershell
.\scripts\init-frontend.ps1
```
功能：
- 安装 Node.js LTS
- 安装 Vue CLI
- 安装项目依赖
- 配置开发环境

#### 2. 构建和部署
```powershell
.\scripts\build-deploy.ps1
```
功能：
- 生产环境构建
- CDN 资源上传
- Docker 镜像构建
- 自动部署

#### 3. UI 测试
```powershell
.\scripts\ui-test.ps1
```
功能：
- 运行 E2E 测试
- 视觉回归测试
- 性能测试

---

## 📚 Guides - 使用指南

### 快速入门
- [Vue 3 开发环境搭建](./guides/vue3-setup.md)
- [TypeScript 入门](./guides/typescript-intro.md)
- [组件开发流程](./guides/component-development.md)

### 最佳实践
- [Composition API 最佳实践](./guides/composition-api-best-practices.md)
- [UI/UX设计原则](./guides/ui-ux-design.md)
- [性能优化技巧](./guides/frontend-performance.md)

### 故障排查
- [常见问题 FAQ](./guides/faq.md)
- [调试技巧](./guides/debugging-tips.md)
- [浏览器兼容性](./guides/browser-compatibility.md)

---

## 🎨 设计资源

### Figma 模板
- UI Kit 链接
- 组件库文档
- 设计规范

### 图标和素材
- SVG 图标集
- 字体资源
- 颜色方案

---

## 📝 贡献指南

### 添加新脚本

1. 在 `scripts/` 目录创建 `.ps1` 或 `.sh` 文件
2. 添加详细的注释和使用说明
3. 在根目录更新此 README
4. 测试脚本功能

### 添加新指南

1. 在 `guides/` 目录创建 `.md` 文件
2. 遵循统一的文档格式
3. 提供实际可运行的代码示例
4. 包含截图和演示

---

## 🎯 脚本列表

| 脚本名称 | 用途 | 执行时间 |
|---------|------|----------|
| init-frontend.ps1 | 初始化前端环境 | ~3 分钟 |
| build-deploy.ps1 | 构建和部署 | ~5 分钟 |
| ui-test.ps1 | UI 测试 | ~8 分钟 |
| dev-server.ps1 | 启动开发服务器 | ~30 秒 |
| optimize-assets.ps1 | 优化静态资源 | ~2 分钟 |

---

*最后更新：2026-03-09*  
*维护者：豆沙 (Dousha)*
