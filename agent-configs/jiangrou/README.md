# OpenClaw Backend - 后端服务

🥩 **由酱肉Agent 负责的后端业务代码仓库**

---

## 🏠 关于本项目

这是 OpenClaw 项目的**后端业务代码仓库**，包含所有服务器端代码。

**注意：** 如果你要找的是酱肉Agent 的配置文档，请访问：https://github.com/baobaobaobaozijun/openclawPlayground/tree/main/workspace-programmer/jiangrou

---

## 📁 项目结构

```
openclaw-backend/
├── README.md              # 本文件
├── requirements.txt       # Python 依赖
├── .gitignore            # Git 忽略配置
│
├── src/                  # 源代码目录（待创建）
│   ├── api/             # API 接口层
│   │   ├── __init__.py
│   │   ├── auth.py      # 认证接口
│   │   └── articles.py  # 文章接口
│   │
│   ├── models/          # 数据模型层
│   │   ├── __init__.py
│   │   ├── user.py      # 用户模型
│   │   └── article.py   # 文章模型
│   │
│   ├── services/        # 业务逻辑层
│   │   ├── __init__.py
│   │   ├── auth_service.py
│   │   └── article_service.py
│   │
│   └── utils/           # 工具函数
│       ├── __init__.py
│       └── helpers.py
│
├── tests/               # 测试代码（待创建）
│   ├── test_api.py
│   └── test_models.py
│
└── docs/                # 技术文档（待创建）
    ├── api-docs.md
    └── database-schema.md
```

---

## 🚀 快速开始

### 1. 环境要求

- Python 3.9+
- MySQL 8.0+ / PostgreSQL 13+
- Redis 6.0+

### 2. 安装依赖

```bash
pip install -r requirements.txt
```

### 3. 配置数据库

```bash
# 创建数据库
mysql -u root -p
CREATE DATABASE openclaw CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 4. 运行服务

```bash
# 开发环境
python src/main.py --debug

# 生产环境
gunicorn src.main:app -w 4 -b 0.0.0.0:8000
```

---

## 👨‍💻 负责人

**主要开发者:** 🥩 酱肉Agent  
**角色:** 后端工程师 / 系统架构师

查看酱肉的配置文档：https://github.com/baobaobaobaozijun/openclawPlayground

---

## 📋 API 文档

### 认证接口

- `POST /api/auth/login` - 用户登录
- `POST /api/auth/register` - 用户注册
- `POST /api/auth/logout` - 用户登出

### 文章接口

- `GET /api/articles` - 获取文章列表
- `GET /api/articles/{id}` - 获取文章详情
- `POST /api/articles` - 创建文章
- `PUT /api/articles/{id}` - 更新文章
- `DELETE /api/articles/{id}` - 删除文章

**完整 API 文档:** [docs/api-docs.md](./docs/api-docs.md) (待编写)

---

## 🛠️ 技术栈

- **Web 框架:** FastAPI / Flask / Django (待定)
- **数据库:** MySQL / PostgreSQL
- **缓存:** Redis
- **ORM:** SQLAlchemy
- **认证:** JWT
- **部署:** Docker + Docker Compose

---

## 📊 开发进度

- [ ] 项目基础架构搭建
- [ ] 用户认证模块
- [ ] 文章管理模块
- [ ] 数据库设计
- [ ] API 接口开发
- [ ] 单元测试
- [ ] 性能优化
- [ ] 生产环境部署

---

## 🔗 相关仓库

| 仓库 | 用途 |
|------|------|
| [openclawPlayground](https://github.com/baobaobaobaozijun/openclawPlayground) | Agent 配置文档中心 |
| [openclaw-frontend](https://github.com/baobaobaobaozijun/openclaw-frontend) | 前端业务代码 |
| [openclaw-devops](https://github.com/baobaobaobaozijun/openclaw-devops) | 运维测试脚本 |

---

**开始构建强大的后端服务吧！** 💪
