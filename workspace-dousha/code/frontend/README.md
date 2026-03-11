# 博客前端项目

基于 Vue 3 + TypeScript + Vite + Element Plus 构建的博客管理系统前端。

## 🚀 技术栈

- **框架:** Vue 3.4+ (Composition API)
- **语言:** TypeScript 5.3+
- **构建工具:** Vite 5.0+
- **UI 组件库:** Element Plus 2.5+
- **状态管理:** Pinia 2.1+
- **路由:** Vue Router 4.2+
- **HTTP 客户端:** Axios 1.6+
- **日期处理:** Day.js 1.11+
- **样式:** SCSS

## 📁 项目结构

```
frontend/
├── public/                 # 静态资源
├── src/
│   ├── assets/            # 项目资源
│   │   └── styles/       # 全局样式
│   ├── components/        # 公共组件
│   │   └── business/     # 业务组件
│   ├── views/            # 页面组件
│   │   └── article/      # 文章模块
│   ├── router/           # 路由配置
│   ├── stores/           # Pinia 状态管理
│   ├── api/              # API 接口
│   ├── utils/            # 工具函数
│   ├── types/            # TypeScript 类型定义
│   ├── App.vue           # 根组件
│   └── main.ts           # 入口文件
├── index.html
├── package.json
├── vite.config.ts
├── tsconfig.json
└── README.md
```

## 🛠️ 开发指南

### 安装依赖

```bash
npm install
```

### 启动开发服务器

```bash
npm run dev
```

访问 http://localhost:5173

### 构建生产版本

```bash
npm run build
```

### 代码检查

```bash
npm run lint
npm run format
```

## 📝 已完成功能

### 文章管理模块

- ✅ 文章列表页面
  - 搜索功能
  - 分类筛选
  - 状态筛选
  - 排序功能
  - 分页功能
  
- ✅ 文章详情页面
  - 文章信息展示
  - 统计数据展示
  - 操作按钮（编辑、发布、删除）
  
- ✅ 文章编辑页面
  - 新建文章
  - 编辑文章
  - Markdown 支持
  - 草稿保存
  - 封面图片
  
- ✅ 状态管理 (Pinia)
  - 文章数据管理
  - 分类/标签管理
  - 加载状态管理
  
- ✅ API 封装
  - Axios 请求封装
  - 统一错误处理
  - 请求/响应拦截器
  
- ✅ 路由配置
  - 页面路由
  - 路由守卫
  - 页面标题设置

## 🎯 下一步计划

- [ ] 用户登录/注册页面
- [ ] 个人中心页面
- [ ] 评论管理模块
- [ ] 数据统计面板
- [ ] 暗色模式支持
- [ ] 移动端适配优化
- [ ] 单元测试覆盖
- [ ] E2E 测试

## 📄 许可证

MIT
