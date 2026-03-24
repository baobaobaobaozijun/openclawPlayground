# 数据库 Schema 管理规范

**创建时间:** 2026-03-24
**维护者:** 灌汤 (PM)
**教训来源:** 2026-03-24 本地/远程 schema 不一致事故

---

## 核心原则：唯一真相源

**`F:\openclaw\code\backend\scripts\schema.sql` 是唯一的数据库表结构定义文件。**

- 所有环境（本地开发、远程生产）必须从这一个文件建表
- Entity 类 (Java) 是"设计源"，schema.sql 必须与 Entity 一致
- 任何表结构变更，必须先改 Entity → 再改 schema.sql → 两套环境同步执行

---

## 变更流程

```
1. 酱肉修改 Entity 类
   ↓
2. 酱肉同步修改 schema.sql（去掉中文注释，避免编码问题）
   ↓
3. 酱肉修改 test-data.sql（字段必须与 schema 一致）
   ↓
4. 酱肉本地验证：DROP + CREATE + INSERT 全部成功
   ↓
5. 通知灌汤/酸菜：远程环境需要同步
   ↓
6. 酸菜/灌汤在远程执行同步
   ↓
7. 两套环境 COUNT 验证一致
```

---

## 禁止事项

- ❌ 直接在 MySQL 命令行 ALTER TABLE（必须改 schema.sql）
- ❌ schema.sql 中使用中文注释（本地 PowerShell 管道编码会乱码）
- ❌ test-data.sql 引用 schema.sql 中不存在的字段
- ❌ 本地和远程使用不同版本的 schema

---

## 验证命令

**本地：**
```powershell
mysql -u root -e "DROP DATABASE IF EXISTS openclaw; CREATE DATABASE openclaw DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
Get-Content schema.sql | mysql -u root openclaw
Get-Content test-data.sql | mysql -u root openclaw
mysql -u root openclaw -e "SELECT (SELECT COUNT(*) FROM users) as u, (SELECT COUNT(*) FROM categories) as c, (SELECT COUNT(*) FROM tags) as t, (SELECT COUNT(*) FROM articles) as a, (SELECT COUNT(*) FROM article_tags) as at_"
```

**远程：**
```bash
scp schema.sql root@8.137.175.240:/tmp/
scp test-data.sql root@8.137.175.240:/tmp/
ssh root@8.137.175.240 "mysql -u root -e 'DROP DATABASE IF EXISTS openclaw; CREATE DATABASE openclaw DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci'; mysql -u root openclaw < /tmp/schema.sql; mysql -u root openclaw < /tmp/test-data.sql"
```

**预期结果：** users=3, categories=7, tags=8, articles=6, article_tags=10

---

## 编码注意

- schema.sql 和 test-data.sql 不要包含中文注释
- 本地 PowerShell 通过管道传给 mysql 时，中文会变成乱码导致语法错误
- 英文注释即可

---

*2026-03-24 事故记录：schema.sql (phone/nickname) vs Entity (username/email) 字段不一致，导致 test-data.sql 远程成功本地失败。修复方式：以 Entity 为准重写 schema.sql。*
