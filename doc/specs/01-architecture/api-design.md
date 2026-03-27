# API 设计文档

## 新增 API (2026-03-27)

### 分类管理
- GET /api/categories - 获取分类列表
- POST /api/categories - 创建分类
- PUT /api/categories/{id} - 更新分类
- DELETE /api/categories/{id} - 删除分类

### 标签管理
- GET /api/tags - 获取标签列表
- POST /api/tags - 创建标签
- DELETE /api/tags/{id} - 删除标签

### Agent 状态
- GET /api/agent/status - 获取所有 Agent 状态