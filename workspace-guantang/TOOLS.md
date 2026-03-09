<!-- Last Modified: 2026-03-09 -->

# TOOLS.md - 本地笔记

## 📁 权限边界

**⚠️ 重要：写操作限制**

| 路径 | 权限 | 说明 |
|------|------|------|
| `F:\openclaw\agent\*` | ✅ 可写 | 我的工作空间 |
| `F:\openclaw\code\*` | ❌ 只读 | 代码目录 |
| `F:\openclaw\workspace\*` | ❌ 只读 | 其他工作区 |
| `C:\*` | ❌ 禁止 | 系统目录 |
| 其他所有路径 | ❌ 只读 | 外部数据 |

---

## 🛠️ 我的 Skills

### 1. working-logger 📝

**用途:** 记录对 `F:\openclaw\agent` 的所有修改

**日志位置:** `F:\openclaw\agent\workinglog\`

**文件名格式:** `YYYYMMDD-hhmmss-{修改人}-{修改内容}.md`

### 2. auto-github-push 🚀

**用途:** 自动推送代码到 GitHub

**仓库:** https://github.com/baobaobaobaozijun/openclawPlayground

**触发时机:** 每次修改完 agent 文件夹后

---

## 📡 Agent 通信

### 收件箱路径

| Agent | 收件箱 |
|-------|--------|
| 酱肉 | `F:\openclaw\workspace\communication\inbox\jiangrou\` |
| 豆沙 | `F:\openclaw\workspace\communication\inbox\dousha\` |
| 酸菜 | `F:\openclaw\workspace\communication\inbox\suancai\` |

### 消息格式

```json
{
  "from": "guantang",
  "to": "{agent}",
  "action": "{action}",
  "data": {},
  "timestamp": "ISO8601"
}
```

---

## 🔧 常用命令

```bash
# GitHub 认证
gh auth login

# 检查 git 状态
cd F:\openclaw\agent && git status

# 手动推送
cd F:\openclaw\agent && git add . && git commit -m "message" && git push

# 安装 skill
cd F:\openclaw\agent\workspace-guantang
npx clawhub install <skill-name>
```

---

*最后更新：2026-03-09*
