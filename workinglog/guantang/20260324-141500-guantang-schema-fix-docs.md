<!-- Last Modified: 2026-03-24 -->

# 工作日志

## 修改信息
- **修改人:** 灌汤
- **修改时间:** 2026-03-24 14:15:00
- **任务类型:** fix + docs

## 任务内容
1. 统一 schema：以 Entity 为准重写 schema.sql（去中文注释）
2. 统一 test-data.sql：对齐 Entity 字段
3. 两套环境重建：本地 + 远程均 DROP + CREATE + INSERT
4. 验证一致性：两套环境均 3/7/8/6/10
5. 创建三份沉淀文档

## 修改的文件
- `code/backend/scripts/schema.sql` - 重写对齐 Entity
- `code/backend/scripts/test-data.sql` - 重写对齐 Entity
- `doc/02-specs/database-schema-management.md` - 新建
- `doc/02-specs/agent-verification-protocol.md` - 新建
- `doc/08-knowledge/lessons-learned-20260324.md` - 新建

## 环境验证结果
| 环境 | users | categories | tags | articles | article_tags |
|------|-------|-----------|------|----------|-------------|
| 本地 | 3 | 7 | 8 | 6 | 10 |
| 远程 | 3 | 7 | 8 | 6 | 10 |

## 关联通知
- [ ] 待通知酱肉：schema 已统一，可以 spring-boot:run 连本地库自测
- [ ] 待 git commit + push

---

*日志自动生成*
