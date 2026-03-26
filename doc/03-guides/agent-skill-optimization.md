# Agent Skill 配置优化方案

**文档版本:** v1.0  
**创建时间:** 2026-03-26 21:40  
**负责人:** 灌汤 (PM)  
**优先级:** P1 - 中

---

## 📊 当前 Agent 配置分析

### 酱肉 (后端工程师) 🍖

**当前配置:**
- **Model:** qwen3-coder-plus
- **职责:** RESTful API、数据库设计、JWT 认证、性能优化
- **禁用工具:** 飞书日历/任务/文档/知识库等

**今日表现:**
- ✅ 17 篇工作日志，一次交付率 100%
- ✅ 擅长：单文件创建（Controller/Service/Mapper）
- ❌ 不擅长：参考模仿、多文件协调、read+edit

**Skill 需求分析:**

| 需求 | 推荐 Skill | 理由 |
|------|-----------|------|
| 代码编译验证 | `maven-compile` | 每次写完后自动编译检查 |
| 单元测试生成 | `unit-test-generator` | 提高测试覆盖率 |
| API 文档生成 | `swagger-gen` | 自动从代码生成 OpenAPI 文档 |
| 数据库迁移 | `flyway-migrate` | 自动执行 SQL 脚本 |

---

### 豆沙 (前端工程师) 🍡

**当前配置:**
- **Model:** qwen3-coder-plus
- **职责:** Vue 3 开发、TypeScript、UI/UX 设计
- **禁用工具:** 飞书日历/任务/文档/知识库等

**今日表现:**
- ✅ 10 篇工作日志，一次交付率 100%
- ✅ 擅长：页面组件、样式、响应式
- ⚠️ 注意：会添加多余字段（如 nickname）

**Skill 需求分析:**

| 需求 | 推荐 Skill | 理由 |
|------|-----------|------|
| 前端构建 | `vite-build` | 每次修改后自动构建验证 |
| ESLint 检查 | `eslint-check` | 代码规范自动检查 |
| 组件文档 | `vue-doc-gen` | 自动从组件生成文档 |
| API 类型生成 | `openapi-typescript` | 从后端 API 生成 TypeScript 类型 |

---

### 酸菜 (运维工程师) 🥬

**当前配置:**
- **Model:** qwen3-coder-plus
- **职责:** 部署脚本、CI/CD 配置、监控告警
- **禁用工具:** 飞书日历/任务/文档/知识库等

**今日表现:**
- ✅ 5 篇工作日志，单文件任务完成率高
- ⚠️ 失联 7 小时，多步骤任务易停滞

**Skill 需求分析:**

| 需求 | 推荐 Skill | 理由 |
|------|-----------|------|
| SSH 连接管理 | `ssh-session` | 保持远程连接，避免重复认证 |
| 健康检查 | `health-check` | 自动检查服务状态 |
| 日志收集 | `log-collector` | 自动收集并分析日志 |
| 备份自动化 | `backup-automation` | 定时备份数据库和文件 |

---

## 🎯 Skill 配置建议

### 优先级 1（立即添加）

#### 1.1 酱肉 - Maven 编译验证

**Skill 名称:** `maven-compile`

**用途:** 每次代码修改后自动编译验证

**配置:**
```yaml
skills:
  maven-compile:
    enabled: true
    trigger: after_write
    pattern: "*.java"
    command: "cd F:\\openclaw\\code\\backend; mvn compile -q"
    timeout: 60s
```

**收益:**
- 即时发现编译错误
- 避免错误累积
- 减少 PM 验证成本

---

#### 1.2 豆沙 - Vite 构建验证

**Skill 名称:** `vite-build`

**用途:** 每次代码修改后自动构建验证

**配置:**
```yaml
skills:
  vite-build:
    enabled: true
    trigger: after_write
    pattern: "*.vue|*.ts"
    command: "cd F:\\openclaw\\code\\frontend; npm run build"
    timeout: 120s
```

**收益:**
- 即时发现构建错误
- 确保代码可部署
- 减少 PM 验证成本

---

#### 1.3 酸菜 - SSH 会话管理

**Skill 名称:** `ssh-session`

**用途:** 保持远程服务器连接，避免重复认证

**配置:**
```yaml
skills:
  ssh-session:
    enabled: true
    server: "8.137.175.240"
    user: "root"
    keepAlive: true
    timeout: 300s
```

**收益:**
- 减少连接建立时间
- 避免认证失败
- 提高多步骤任务成功率

---

### 优先级 2（本周内）

#### 2.1 酱肉 - 单元测试生成

**Skill 名称:** `unit-test-generator`

**用途:** 自动为新建的 Service/Controller 生成单元测试

**配置:**
```yaml
skills:
  unit-test-generator:
    enabled: true
    trigger: after_write
    pattern: "*Service.java|*Controller.java"
    template: "junit5-mockito"
    coverage_target: 80%
```

**收益:**
- 提高测试覆盖率
- 减少手动编写测试时间
- 确保代码质量

---

#### 2.2 豆沙 - API 类型生成

**Skill 名称:** `openapi-typescript`

**用途:** 从后端 OpenAPI 文档生成 TypeScript 类型定义

**配置:**
```yaml
skills:
  openapi-typescript:
    enabled: true
    trigger: on_demand
    input: "F:\\openclaw\\code\\backend\\target\\swagger.json"
    output: "F:\\openclaw\\code\\frontend\\src\\types\\api.ts"
```

**收益:**
- 确保前后端类型一致
- 减少手动维护类型定义
- 自动发现 API 变更

---

#### 2.3 酸菜 - 健康检查

**Skill 名称:** `health-check`

**用途:** 自动检查服务状态（Java/MySQL/Redis/Nginx）

**配置:**
```yaml
skills:
  health-check:
    enabled: true
    schedule: "*/5 * * * *"  # 每 5 分钟
    checks:
      - name: "Java Backend"
        type: "http"
        url: "http://8.137.175.240:8081/actuator/health"
      - name: "MySQL"
        type: "tcp"
        host: "8.137.175.240"
        port: 3306
      - name: "Nginx"
        type: "http"
        url: "http://8.137.175.240/"
```

**收益:**
- 即时发现服务故障
- 减少人工检查
- 自动告警

---

### 优先级 3（长期）

#### 3.1 酱肉 - 数据库迁移

**Skill 名称:** `flyway-migrate`

**用途:** 自动执行数据库迁移脚本

**配置:**
```yaml
skills:
  flyway-migrate:
    enabled: true
    trigger: on_demand
    location: "F:\\openclaw\\code\\backend\\src\\main\\resources\\db\\migration"
    url: "jdbc:mysql://localhost:3306/baozipu"
```

---

#### 3.2 豆沙 - 组件文档生成

**Skill 名称:** `vue-doc-gen`

**用途:** 自动从 Vue 组件生成文档

**配置:**
```yaml
skills:
  vue-doc-gen:
    enabled: true
    trigger: after_write
    pattern: "*.vue"
    output: "F:\\openclaw\\agent\\doc\\frontend\\components"
```

---

#### 3.3 酸菜 - 日志收集

**Skill 名称:** `log-collector`

**用途:** 自动收集并分析服务日志

**配置:**
```yaml
skills:
  log-collector:
    enabled: true
    schedule: "0 */10 * * * *"  # 每 10 分钟
    sources:
      - "/opt/baozipu/backend/logs/app.log"
      - "/var/log/nginx/error.log"
    analysis:
      - "ERROR"
      - "Exception"
      - "Failed"
```

---

## 📋 实施清单

### 阶段 1（今晚）
- [ ] 确认 Skill 系统支持情况
- [ ] 添加酱肉 `maven-compile` Skill
- [ ] 添加豆沙 `vite-build` Skill
- [ ] 添加酸菜 `ssh-session` Skill
- [ ] 测试验证

### 阶段 2（本周）
- [ ] 添加酱肉 `unit-test-generator`
- [ ] 添加豆沙 `openapi-typescript`
- [ ] 添加酸菜 `health-check`
- [ ] 验证 Skill 触发逻辑

### 阶段 3（长期）
- [ ] 评估自定义 Skill 开发必要性
- [ ] 开发 `flyway-migrate`
- [ ] 开发 `vue-doc-gen`
- [ ] 开发 `log-collector`

---

## 🎯 预期收益

| 指标 | 当前 | 优化后 | 改善 |
|------|------|--------|------|
| 编译错误发现 | PM 手动验证 | 自动即时发现 | 100% 自动化 |
| 构建错误发现 | PM 手动验证 | 自动即时发现 | 100% 自动化 |
| SSH 连接失败 | ~10% | <1% | 90%↓ |
| 测试覆盖率 | ~60% | >80% | 33%↑ |
| 多步骤任务成功率 | ~50% | >80% | 60%↑ |

---

## ⚠️ 注意事项

1. **Skill 权限控制** - 确保 Skill 只能访问授权资源
2. **超时设置** - 避免 Skill 执行时间过长阻塞 Agent
3. **错误处理** - Skill 失败不应导致 Agent 任务失败
4. **日志记录** - Skill 执行日志应记录到工作日志

---

*文档创建完成 | 下一步：评估 Skill 系统支持情况*
