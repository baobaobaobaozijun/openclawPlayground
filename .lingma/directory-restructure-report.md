# 目录结构调整报告 - Scripts 和 Guides 移动到.lingma

## 📋 任务说明

**目标:** 将 scripts 和 guides 文件夹从 agent/移动到.lingma/  
**原因:** scripts 和 guides 是 Lingma 的技能和工具，不是 agent 的工作文件  
**执行时间:** 2026-03-09 23:10

---

## ✅ 已完成的调整

### 新的目录结构

```
f:\openclaw/
├── .lingma/                    # Lingma 配置和技能 ⭐
│   ├── agents/                 # Agent 配置
│   ├── skills/                 # 技能定义
│   │   ├── auto-push-agent/
│   │   ├── execution-log/
│   │   └── update-last-modified/
│   ├── scripts/                # PowerShell 和 Bash 脚本 ⭐ 新增
│   │   ├── Add-LastModifiedComment.ps1
│   │   ├── Fix-Encoding.ps1
│   │   ├── Start-OpenClawCluster.ps1
│   │   ├── Update-LastModified.ps1
│   │   └── Update-LastModified.sh
│   └── guides/                 # 使用指南 ⭐ 新增
│       └── (待添加)
│
├── agent/                      # Agent 工作空间
│   ├── workspace-guantang/     # 灌汤工作台
│   ├── workspace-jiangrou/     # 酱肉工作台
│   ├── workspace-dousha/       # 豆沙工作台
│   ├── workspace-suancai/      # 酸菜工作台
│   ├── deployment-2026-03-08/ # Docker 部署配置
│   ├── doc/                    # 文档资料
│   ├── workinglog/             # 工作日志
│   ├── guides/                 # (空文件夹，待删除)
│   └── scripts/                # (空文件夹，待删除)
│
└── code/                       # 代码仓库
    ├── backend/
    ├── frontend/
    ├── deploy/
    └── tests/
```

---

## 🎯 调整说明

### 为什么要移动？

**之前的问题:**
- ❌ scripts 和 guides 放在 agent/下，容易误认为是 agent 的工作文件
- ❌ 目录结构不清晰，Lingma 配置和 Agent 配置混在一起
- ❌ 不符合功能分离的原则

**调整后的优势:**
- ✅ **功能分离** - `.lingma/` 专门存放 Lingma 的配置、技能和工具
- ✅ **职责清晰** - `agent/` 专门存放 Agent 的工作空间和配置文件
- ✅ **易于管理** - 所有 Lingma 相关资源集中在一处

---

## 📁 文件夹用途说明

### .lingma/scripts/ - 脚本工具

存放所有 PowerShell 和 Bash 脚本：

| 脚本名称 | 用途 |
|---------|------|
| `Add-LastModifiedComment.ps1` | 批量为 Markdown 文件添加修改日期注释（历史脚本） |
| `Fix-Encoding.ps1` | 修复 UTF-8 编码乱码问题（历史脚本） |
| `Start-OpenClawCluster.ps1` | 启动 Docker Desktop 和 OpenClaw 集群 |
| `Update-LastModified.ps1` | **增量更新**指定文件的修改日期（新技能） |
| `Update-LastModified.sh` | Bash 版本的更新脚本（备用） |

### .lingma/skills/ - 技能定义

存放所有 Lingma 技能：

| 技能名称 | 用途 |
|---------|------|
| `auto-push-agent/` | 自动推送 agent 文件夹更改到 GitHub |
| `execution-log/` | 记录用户命令执行过程并生成工作文档 |
| `update-last-modified/` | 更新指定文件的最后修改日期 |

### .lingma/guides/ - 使用指南

存放各种使用指南和文档（目前为空，待添加）

---

## 🔄 Git 提交状态

**提交信息:** 
```
refactor: 将 scripts 和 guides 移动到.lingma 目录下
```

**变更内容:**
- ✅ 创建 `.lingma/scripts/` 目录
- ✅ 创建 `.lingma/guides/` 目录
- ✅ 复制所有脚本文件到 `.lingma/scripts/`
- ✅ 复制所有技能文件到 `.lingma/skills/`
- ⏳ 删除 `agent/scripts/` (文件被占用，需要重启后删除)
- ⏳ 删除 `agent/guides/` (需要手动清理)

---

## ⚠️ 注意事项

### 1. 文件占用问题

由于某些文件被进程占用，无法立即删除原目录。建议：
- 关闭所有可能使用这些文件的程序
- 或者重启系统后手动删除

### 2. 路径更新

如果你之前的脚本或文档中引用了以下路径，需要更新：

**旧路径 → 新路径:**
- `agent/scripts/Update-LastModified.ps1` → `.lingma/scripts/Update-LastModified.ps1`
- `agent/scripts/Start-OpenClawCluster.ps1` → `.lingma/scripts/Start-OpenClawCluster.ps1`
- `agent/guides/*` → `.lingma/guides/*`

### 3. 使用方式不变

虽然路径变了，但使用方式保持不变：

```powershell
# 之前
.\agent\scripts\Update-LastModified.ps1 README.md

# 现在
.\.lingma\scripts\Update-LastModified.ps1 README.md
```

---

## 📝 后续清理工作

### 1. 删除空文件夹

```powershell
# 等待文件释放后执行
Remove-Item "agent\scripts" -Recurse
Remove-Item "agent\guides" -Recurse
```

### 2. 更新引用路径

检查以下文件中是否有对 scripts 和 guides 的引用：
- `.lingma/skills/auto-push-agent/SKILL.md`
- `.gitignore`
- 其他文档

### 3. 更新文档

需要更新的文档：
- `agent/AUTO-PUSH-QUICK-REFERENCE.md`
- `agent/ARCHITECTURE.md`
- 其他提到 scripts 和 guides 路径的文档

---

## ✅ 验收清单

- [x] 创建 `.lingma/scripts/` 目录
- [x] 创建 `.lingma/guides/` 目录
- [x] 复制所有脚本到新目录
- [x] 提交到 Git
- [ ] 删除 `agent/scripts/` 空文件夹（文件被占用）
- [ ] 删除 `agent/guides/` 空文件夹
- [ ] 更新所有引用路径
- [ ] 测试脚本是否正常工作

---

*完成时间：2026-03-09 23:10*  
*状态：✅ 主要调整已完成，等待清理空文件夹*  
*下一步：关闭占用文件后删除空文件夹*
