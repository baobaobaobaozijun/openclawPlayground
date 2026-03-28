<!-- Last Modified: 2026-03-28 00:20 -->

# Agent 任务交付确认模板

**使用说明：** Agent 完成任务后，使用此模板提交交付物供 PM 验收。

---

## 任务交付格式

```markdown
【任务完成 - {Agent 名} - {YYYY-MM-DD HH:mm}】

**任务 ID：** {Plan-XXX RX}
**任务名称：** {任务描述}

**交付物：**
- [x] 文件路径 1
- [x] 文件路径 2

**验收标准自查：**
- [x] 标准 1
- [x] 标准 2
- [x] 标准 3

**工作日志：** {F:\openclaw\agent\workinglog\{agent}\{文件名}.md}

**备注：** {可选，说明特殊情况}

**请 PM 验收。**
```

---

## PM 验收流程

1. **验证交付物存在** - Test-Path 检查文件
2. **代码审查** - 抽查关键代码
3. **验收标准核对** - 逐一检查
4. **工作日志检查** - 确认已记录

**验收结果：**
- ✅ 通过 → 标记任务完成，分配下一轮
- ❌ 驳回 → 列出问题，要求返工

---

## 验收响应格式

```markdown
【验收结果 - PM 灌汤 - {YYYY-MM-DD HH:mm}】

**任务 ID：** {Plan-XXX RX}
**验收结果：** ✅ 通过 / ❌ 驳回

**意见：**
- {通过：无意见}
- {驳回：具体问题列表}

**下一步：**
- {通过：分配下一轮任务}
- {驳回：要求 XX 时间内返工}
```

---

## 示例

```markdown
【任务完成 - 酱肉 - 2026-03-28 01:30】

**任务 ID：** Plan-011 R1
**任务名称：** users 表添加 access_level 字段

**交付物：**
- [x] F:\openclaw\code\backend\src\main\resources\db\migration\V2__add_access_level.sql
- [x] F:\openclaw\agent\workspace-jiangrou\logs\plan011-r1-log.md

**验收标准自查：**
- [x] SQL 脚本可执行
- [x] 字段类型 TINYINT DEFAULT 0
- [x] 已添加注释

**工作日志：** F:\openclaw\agent\workinglog\jiangrou\20260328-013000-jiangrou-plan011-r1.md

**备注：** 已在测试环境验证

**请 PM 验收。**
```

---

*模板版本：v1.0 | 创建者：灌汤 PM | 2026-03-28 00:20*
