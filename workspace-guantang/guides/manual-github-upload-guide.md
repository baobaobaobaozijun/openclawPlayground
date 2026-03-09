# 📤 手动上传到 GitHub - 操作指南

## ⚠️ 当前状态

**网络检查:** 暂时无法访问 GitHub (可能是网络或 DNS 问题)

**解决方案:** 请按照以下步骤手动在命令行中执行命令

---

## 🚀 快速上传步骤

### 1️⃣ 灌汤 PM - openclawPlayground

打开 PowerShell 或 CMD，依次执行：

```powershell
# 进入目录
cd F:\openclaw\workspace

# 确认远程仓库
git remote -v

# 如果看不到 origin，添加远程仓库
git remote add origin https://github.com/baobaobaobaozijun/openclawPlayground.git

# 推送代码
git push -u origin main
```

**输入凭证:**
- Username: `baobaobaobaozijun`
- Password: [你的 GitHub Personal Access Token](https://github.com/settings/tokens)

---

### 2️⃣ 酱肉后端 - openclaw-backend

```powershell
cd F:\openclaw\workspace-jiangrou

# 初始化并推送
git remote add origin https://github.com/baobaobaobaozijun/openclaw-backend.git
git branch -M main
git push -u origin main
```

---

### 3️⃣ 豆沙前端 - openclaw-frontend

```powershell
cd F:\openclaw\workspace-dousha

# 初始化并推送
git remote add origin https://github.com/baobaobaobaozijun/openclaw-frontend.git
git branch -M main
git push -u origin main
```

---

### 4️⃣ 酸菜运维 - openclaw-devops

```powershell
cd F:\openclaw\workspace-suancai

# 初始化并推送
git remote add origin https://github.com/baobaobaobaozijun/openclaw-devops.git
git branch -M main
git push -u origin main
```

---

## 🔐 获取 Personal Access Token

如果还没有 Token，请按以下步骤创建：

### 步骤 1: 访问 Token 页面
打开浏览器，访问：https://github.com/settings/tokens

### 步骤 2: 生成新 Token
1. 点击 **"Generate new token"** → **"Generate new token (classic)"**
2. 填写备注（Note）：例如 "OpenClaw Upload"
3. 选择过期时间（Expiration）：建议选 **No expiration** 或 **90 days**
4. 勾选权限（Scopes）：
   - ✅ `repo` (Full control of private repositories)
   - ✅ `workflow` (Update GitHub Action workflows)

### 步骤 3: 复制 Token
1. 点击 **"Generate token"**
2. **立即复制**生成的 token（以 `ghp_` 开头）
3. ⚠️ **重要:** Token 只会显示一次，离开页面后无法再查看！

### 步骤 4: 使用 Token
推送代码时：
- Username: `baobaobaobaozijun`
- Password: 粘贴你复制的 Token（不会显示字符）

---

## ✅ 验证上传成功

上传完成后，在浏览器中访问以下链接检查：

1. **openclawPlayground**: https://github.com/baobaobaobaozijun/openclawPlayground
2. **openclaw-backend**: https://github.com/baobaobaobaozijun/openclaw-backend
3. **openclaw-frontend**: https://github.com/baobaobaobaozijun/openclaw-frontend
4. **openclaw-devops**: https://github.com/baobaobaobaozijun/openclaw-devops

每个仓库应该能看到：
- ✅ IDENTITY.md
- ✅ ROLE.md
- ✅ SOUL.md
- ✅ README.md
- ✅ .gitignore

---

## 🆘 常见问题解决

### 问题 1: "Could not resolve host: github.com"

**原因:** DNS 解析失败或网络问题

**解决方法:**

**方法 A: 修改 DNS**
```powershell
# 以管理员身份运行 PowerShell
# 网络设置 → 更改适配器选项 → 右键当前网络 → 属性
# 选择 "Internet 协议版本 4 (TCP/IPv4)" → 属性
# 使用以下 DNS 服务器:
# 首选：8.8.8.8
# 备用：8.8.4.4
```

**方法 B: 刷新 DNS 缓存**
```powershell
ipconfig /flushdns
```

**方法 C: 检查代理**
```powershell
# 如果使用代理，确保代理正常工作
# 或临时关闭代理
```

---

### 问题 2: "Authentication failed"

**原因:** 密码错误或 Token 过期

**解决方法:**

1. 清除保存的凭证：
```powershell
cmdkey /list
cmdkey /delete:git:https://github.com
```

2. 重新推送并使用新 Token：
```powershell
git push -u origin main
# 输入用户名和新的 Token
```

---

### 问题 3: "Repository not found"

**原因:** GitHub 上还没有创建这个仓库

**解决方法:**

1. 打开浏览器访问：https://github.com/new
2. 创建对应的空仓库（不要勾选 Initialize with README）
3. 重新执行推送命令

---

### 问题 4: "Permission denied"

**原因:** 没有该仓库的写入权限

**解决方法:**

1. 确认你是仓库的所有者或协作者
2. 如果是组织仓库，检查你的权限级别
3. 使用正确的 SSH key 或 Token

---

## 📊 上传检查清单

完成每个仓库后，在对应框打勾：

### openclawPlayground (灌汤)
- [ ] 仓库已创建
- [ ] 代码已推送
- [ ] 能在 GitHub 看到文件
- [ ] 包含所有核心文件

### openclaw-backend (酱肉)
- [ ] 仓库已创建
- [ ] 代码已推送
- [ ] 能在 GitHub 看到文件
- [ ] 包含所有核心文件

### openclaw-frontend (豆沙)
- [ ] 仓库已创建
- [ ] 代码已推送
- [ ] 能在 GitHub 看到文件
- [ ] 包含所有核心文件

### openclaw-devops (酸菜)
- [ ] 仓库已创建
- [ ] 代码已推送
- [ ] 能在 GitHub 看到文件
- [ ] 包含所有核心文件

---

## 🎉 上传成功后的下一步

1. **更新 README 中的链接**
   - 在所有相关文档中更新仓库 URL
   
2. **配置分支保护**
   - 在 GitHub 仓库 Settings → Branches → Add rule
   - Branch name pattern: `main`
   - 勾选 "Require a pull request before merging"

3. **启用 GitHub Actions (可选)**
   - 用于自动化测试和部署

4. **邀请协作者 (可选)**
   - Settings → Collaborators → Add people

---

## 📞 需要帮助？

如果在上传过程中遇到问题：

1. 截图错误信息
2. 告诉我具体的错误内容
3. 我会帮你分析并提供解决方案

---

**准备好后，按照上面的步骤开始上传吧！** 💪
