<!-- Last Modified: 2026-03-23 -->

# 🔴 紧急任务：前端打包

**负责人:** 豆沙 (Dousha)  
**优先级:** CRITICAL  
**截止时间:** 2026-03-23 18:00

---

## 任务目标

使用 npm/vite 打包前端项目，生成静态文件到 dist 目录。

---

## 执行步骤

### 1. 检查项目完整性

```powershell
cd F:\openclaw\code\frontend

# 检查 package.json 是否存在
Test-Path package.json

# 检查源码目录
Get-ChildItem src -Recurse -Name | Select-Object -First 20
```

**预期:**
- package.json 存在
- 有 src/views/、src/components/ 等目录

### 2. 检查 Node.js 和 npm

```powershell
node -version
npm -version
```

**预期输出:**
```
v20.x.x 或更高
10.x.x 或更高
```

### 3. 安装依赖（如未安装）

```powershell
cd F:\openclaw\code\frontend
npm install
```

**预期:** 无报错，node_modules 目录生成

### 4. 清理并构建

```powershell
cd F:\openclaw\code\frontend
npm run build
```

**预期输出:**
```
✓ built in xxx ms
dist/ 目录生成
```

**输出文件:**
```
F:\openclaw\code\frontend\dist\
├── index.html
├── assets/
│   ├── index-xxx.css
│   └── index-xxx.js
└── ...
```

### 5. 验证 dist 内容

```powershell
cd F:\openclaw\code\frontend\dist
Test-Path index.html
Get-ChildItem
```

**预期:**
- index.html 存在
- assets 目录存在

### 6. 本地预览（可选）

```powershell
cd F:\openclaw\code\frontend
npm run preview
```

**预期:** 本地可访问预览服务器

### 7. 写工作日志

**文件:** `workinglog/dousha/20260323-XXXXXX-dousha-前端打包.md`

**内容:**
- 执行的命令
- 命令输出（关键部分）
- dist 目录结构
- 验证结果

---

## 可能的问题及解决

| 问题 | 解决 |
|------|------|
| npm install 失败 | 检查网络，配置 npm 镜像 (taobao) |
| 构建报错 | 检查 TypeScript 错误，修复语法问题 |
| 依赖版本冲突 | 删除 node_modules 重新安装 |

---

## 验收标准

- [ ] dist 目录存在
- [ ] dist/index.html 存在
- [ ] dist/assets/ 存在
- [ ] 工作日志已写

---

*灌汤 (PM) | 2026-03-23*
