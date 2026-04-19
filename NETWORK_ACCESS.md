# 跨设备访问指南

## 问题说明

默认情况下，项目使用 `localhost` 作为后端地址，这导致：
- 本机访问正常
- 其他设备（手机、平板、其他电脑）无法访问
- 显示"网络连接失败，请检查网络"

## 解决方案

### 1. 获取本机 IP 地址

在 Windows PowerShell 中运行：
```powershell
ipconfig | findstr "IPv4"
```

找到你的局域网 IP，例如：`192.168.1.100`

### 2. 修改环境变量配置

编辑 `frontend/.env` 文件，将 IP 地址修改为你的实际 IP：

```env
VITE_API_BASE_URL=http://你的IP地址:8083/api
```

例如：
```env
VITE_API_BASE_URL=http://192.168.1.100:8083/api
```

### 3. 确保后端监听所有网络接口

`backend/src/main/resources/application.yml` 已配置：

```yaml
server:
  port: 8083
  address: 0.0.0.0  # 监听所有网络接口
```

### 4. 防火墙设置

确保 Windows 防火墙允许 8083 端口（后端）和 3000 端口（前端）的入站连接。

**添加防火墙规则（管理员权限 PowerShell）：**

```powershell
# 允许后端端口
netsh advfirewall firewall add rule name="StudentMgmt-Backend" dir=in action=allow protocol=tcp localport=8083

# 允许前端端口
netsh advfirewall firewall add rule name="StudentMgmt-Frontend" dir=in action=allow protocol=tcp localport=3000
```

## 启动服务

### 1. 启动后端

```bash
cd backend
mvn spring-boot:run
```

后端将监听 `0.0.0.0:8083`，允许任何设备访问。

### 2. 启动前端

```bash
cd frontend
npm run dev
```

前端开发服务器将监听 `0.0.0.0:3000`。

## 访问方式

### 本机访问
- 前端：http://localhost:3000/Student-Management-System/
- 后端：http://localhost:8083

### 其他设备访问（同一局域网）

假设你的电脑 IP 是 `192.168.1.100`：

- **手机/平板**：http://192.168.1.100:3000/Student-Management-System/
- **其他电脑**：http://192.168.1.100:3000/Student-Management-System/

## 常见问题

### Q1: 其他设备显示"网络连接失败"

**可能原因：**
1. 防火墙阻止了端口访问
2. IP 地址配置错误
3. 设备和电脑不在同一网络

**解决方法：**
1. 检查防火墙设置
2. 确认使用正确的 IP 地址
3. 确保所有设备连接同一个 WiFi/路由器

### Q2: 如何查看本机 IP？

**Windows:**
```powershell
ipconfig
```

**Mac/Linux:**
```bash
ifconfig
# 或
ip addr
```

### Q3: 部署到公网服务器

如果需要让外网访问，建议：
1. 购买云服务器（阿里云、腾讯云等）
2. 部署后端到服务器
3. 修改前端 `.env.production` 中的 API 地址为服务器公网 IP
4. 使用 Nginx 部署前端静态文件

## 生产环境部署

构建生产版本：

```bash
cd frontend
npm run build
```

生成的 `dist` 文件夹可以部署到任何静态服务器。

**注意：** 生产环境需要修改 `.env.production` 中的 API 地址为实际的后端服务器地址。
