# 包子铺博客系统部署手册

## 部署脚本说明

包子铺博客系统的部署脚本 `deploy.sh` 包含以下步骤：

1. 拉取最新的代码
2. 构建后端应用
3. 构建前端应用
4. 停止旧服务
5. 部署新服务
6. 启动新服务
7. 进行健康检查

## 部署前准备

1. 确保服务器已安装 Java、Maven、Node.js 和 Nginx
2. 确保 `/opt/baozipu` 目录存在并包含完整的项目代码
3. 确保 systemd 服务配置已放置在 `/etc/systemd/system/` 目录下
4. 确保 Nginx 配置已放置在 `/etc/nginx/conf.d/` 目录下

## 部署步骤

1. 运行部署脚本：
   ```bash
   ./deploy.sh
   ```

2. 验证服务是否正常启动：
   ```bash
   systemctl status baozipu-backend
   ```

3. 验证 Nginx 配置是否正确：
   ```bash
   nginx -t
   ```

4. 重新加载 Nginx 配置：
   ```bash
   systemctl reload nginx
   ```

## 注意事项

- 部署过程中会停止现有服务，请在低峰期执行
- 部署完成后会进行健康检查，确保服务正常运行
- 如需回滚，可将 `/opt/baozipu/releases/` 目录下的旧版本 jar 包重新链接到 `/opt/baozipu/current.jar`