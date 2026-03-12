# HEARTBEAT.md - 灌汤的心跳配置

**最后更新:** 2026-03-12 15:08  
**心跳频率:** 每 10 分钟

---

## ❤️ 心跳检查机制 (PM 职责)

**检查频率:** 每 10 分钟

**必须执行:**
1. **发起心跳检查** - sessions_spawn 通知各 Agent 同步状态
2. **维护心跳看板** - 更新 `doc/progress/agent-heartbeat-dashboard.md`
3. **记录心跳状态** - 记录各 Agent 最后心跳时间、任务、进度
4. **主动确认** - Agent 2 次未同步时主动联系确认状态
5. **站会通报** - Agent 3 次未同步时站会通报批评

**心跳看板位置:** `F:\openclaw\agent\doc\progress\agent-heartbeat-dashboard.md`

**检查时间表:**
| 时间 | 事项 |
|------|------|
| **每 10 分钟** | 心跳检查 + 看板更新 |
| 09:00 | 晨会 + 心跳检查 |
| 14:00 | 午会 + 心跳检查 |
| 18:00 | 日验收 + 心跳检查 |

**违规处理:**
| 未同步次数 | 处理方式 |
|------------|----------|
| 第 1 次 | PM 主动确认状态 |
| 第 2 次 | 站会通报批评 |
| 第 3 次 | 上报并调整任务 |

---

## 📋 强制提交要求

### 文档提交
**触发条件:** 每次 F:\openclaw 文件夹下的文档内容发生更改

**必须执行:**
1. 检查工作区状态 (git status)
2. 添加所有更改的文件 (git add .)
3. 提交更改 (git commit -m "docs: {描述}")
4. 推送到 GitHub (git push)

### 代码提交
**触发条件:** 每次 F:\openclaw 文件夹下的代码内容发生更改

**必须执行:**
1. 检查工作区状态 (git status)
2. 添加所有更改的文件 (git add .)
3. 提交更改 (git commit -m "{type}: {描述}")
4. 拉取最新代码 (git pull --rebase)
5. 推送到 GitHub (git push)

**提交信息规范:**
| 前缀 | 用途 | 示例 |
|------|------|------|
| `feat:` | 新功能 | `feat: 添加 Agent 健康检查` |
| `fix:` | 修复 | `fix: 修正酱肉仓库地址` |
| `docs:` | 文档 | `docs: 更新 README.md` |
| `config:` | 配置 | `config: 更新 Gateway 端口` |
| `chore:` | 杂项 | `chore: 清理旧配置文件` |

---

*位置：F:\openclaw\agent\workspace-guantang\HEARTBEAT.md*
