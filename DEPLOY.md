# 免费部署完整教程（小白版，跟着点就行）

目标：把"学生管理系统"免费放到网上，别人能用手机/电脑打开、登录、聊天。
全程 0 元，浏览器操作为主，不用买服务器，不用懂 Linux。

```
你的浏览器
   │
   ├─ 打开 https://你的项目.pages.dev   ← 网页界面（Cloudflare Pages 免费托管，第 5 步）
   │        │
   │        ├─ 登录/查数据/导出等 → https://student-management.onrender.com/api  ← 后端（Render 免费托管，第 4 步）
   │        └─ 实时聊天（WebSocket） → wss://student-management.onrender.com/ws/chat
   │                                              │
   │                                              └─ 数据存在 → TiDB Cloud 免费数据库（第 2 步）
   └─ 代码放 GitHub（第 3 步），Render 和 Cloudflare 都从 GitHub 自动拉代码
```

**你需要注册 4 个免费账号**（都只要邮箱，不需要信用卡）：GitHub、TiDB Cloud、Render、Cloudflare。
**时间**：第一次全流程约 1~1.5 小时。每一步都有"✅ 看到什么算成功"。

---

## 第 0 步：确认你的电脑有 Git（推代码要用）

1. 按 `Win + R`，输入 `cmd` 回车，打开黑窗口
2. 输入 `git --version` 回车
   - 显示 `git version 2.x.x` → 有了，跳过本步
   - 提示"不是内部或外部命令" → 去 https://git-scm.com/download/win 下载安装，一路"下一步"装完，重新打开 cmd 再试一次
3. （可选）觉得命令行难，可以装 **GitHub Desktop**（https://desktop.github.com ），图形界面提交代码，后面第 3 步会给两种方式

---

## 第 1 步：注册 GitHub（有账号跳过）

1. 打开 https://github.com/signup
2. 填邮箱、密码、用户名，完成邮箱验证
3. 登录后记住你的用户名，后面 `https://github.com/你的用户名/仓库名.git` 要用

---

## 第 2 步：TiDB Cloud 建免费数据库（约 15 分钟）

TiDB 是"兼容 MySQL"的免费云数据库，不用自己装 MySQL。

### 2.1 注册并创建数据库集群

1. 打开 https://tidbcloud.com ，点 **Sign Up / 注册**（可以选"用 Google/GitHub 账号登录"更省事）
2. 登录后首次进入，会引导创建集群（Cluster）。如果没自动弹，点左上角 **Create Cluster / 创建集群**
3. 按下面选：
   - **部署类型**：选 **Serverless**（免费的那个，千万不要选 Dedicated 付费版）
   - **云厂商/区域（Region）**：选 **Singapore / ap-southeast-1**（从中国访问最快；找不到就选离你最近的）
   - **集群名字**：随便填，比如 `student-db`
4. 点 **Create / 创建**，等 1~5 分钟，状态变成 **Running/运行中** ✅

### 2.2 创建项目用的数据库（表不用建，后端会自动建）

1. 在 TiDB Cloud 网页左侧菜单找 **Chat2Query**（这是网页版 SQL 编辑器，不用装任何软件）
2. 选你刚创建的集群，在输入框里粘贴这一行，点运行 ▶：
   ```sql
   CREATE DATABASE student_db;
   ```
3. 看到成功提示 ✅

### 2.3 记下连接信息（第 4 步填到 Render 里要用）

1. 回到集群页面，点 **Connect / 连接** 按钮
2. 选 **Connect with JDBC** 标签页，你会看到：
   - **Host**（形如 `gateway01.ap-southeast-1.prod.aws.tidbcloud.com`）
   - **Port**：`4000`
   - **User**（形如 `xxxxxxx.root`，一长串，要完整复制）
   - **Password**：如果没设置过，点 **Generate Password / 生成密码**，复制保存好（**只显示一次**，丢了要点 Reset 重置）

把 Host、User、Password 复制到一个记事本里备用。

---

## 第 3 步：把项目代码推到 GitHub（约 10 分钟）

### 方式 A：命令行（推荐，就 3 条命令）

1. 打开项目文件夹 `D:\网页集\springboot期末考核`，在地址栏输入 `cmd` 回车（会在这个目录打开黑窗口）
2. 先看看代码仓库连到哪了：
   ```
   git remote -v
   ```
   - 有输出（形如 `origin https://github.com/xxx/xxx.git`）→ 跳到第 4 条命令
   - 没有输出 → 去 GitHub 网页点 **New repository** 新建一个空仓库（名字随便，如 `student-management`，**不要勾选** "Add a README"），然后执行：
     ```
     git remote add origin https://github.com/你的用户名/student-management.git
     ```
3. 确认一下登录身份（只第一次需要）：
   ```
   git config --global user.name "你的名字"
   git config --global user.email "你的邮箱"
   ```
4. 提交并推送（这会把所有改动传上去）：
   ```
   git add -A
   git commit -m "部署准备：Dockerfile/render.yaml/部署文档/WS地址适配"
   git push -u origin main
   ```
5. 第一次推送会弹窗让你用 GitHub 登录授权 ✅
6. 刷新 GitHub 网页，能看到代码文件 ✅

> 如果 `git push` 报错说仓库不存在/没有权限，检查第 2 条的远程地址是否正确。

### 方式 B：GitHub Desktop（图形界面）

1. 打开 GitHub Desktop → 登录 GitHub
2. **File → Add Local Repository…** → 选择 `D:\网页集\springboot期末考核` 文件夹
3. 左侧会列出改动文件，底部填一句说明（如 `部署准备`），点 **Commit to main**
4. 点顶部 **Publish branch / Push origin** → 完成 ✅

---

## 第 4 步：Render 部署后端（最关键一步，约 20 分钟）

### 4.1 注册登录

1. 打开 https://render.com ，点 **Sign Up**，建议直接用 **GitHub 账号登录**（会跳转授权）
2. 免费层**一般不需要绑信用卡**；如果页面让你选套餐，选 **Free** ✅

### 4.2 用"蓝图"一键创建服务

1. 登录后点右上角 **New +**，选 **Blueprint**
2. 第一次会让你 **Connect GitHub**（授权 Render 读取你的仓库）→ 选你的仓库（可以只授权这一个仓库）
3. 选择你的 `student-management` 仓库，点 **Connect**
4. Render 会自动读取仓库里的 `render.yaml`，显示"即将创建 1 个服务"：
   - 服务名：`student-management`
   - 类型：Web Service，套餐 Free
5. 点 **Apply / Create New Resources**，开始第一次构建
6. 构建要 5~10 分钟（第一次要下载 Maven 依赖）。页面会有进度条/日志
7. 等状态变成 **Live**（绿色）✅

### 4.3 填写数据库和密钥配置（必做，否则连不上数据库）

1. 在服务页面左侧菜单点 **Environment**
2. 往下找到 **Environment Variables**，点 **Edit**
3. 把下面 4 个变量的值改好（用第 2.3 步记下的信息）：

   | 变量名 | 填什么 |
   |---|---|
   | `DB_URL` | `jdbc:mysql://你记下的Host:4000/student_db?useSSL=true&requireSSL=true&sslMode=VERIFY_IDENTITY&enabledTLSProtocols=TLSv1.2,TLSv1.3&serverTimezone=Asia/Shanghai` |
   | `DB_USERNAME` | 你记下的 User（整串，含 `.root`）|
   | `DB_PASSWORD` | 你记下的 Password |
   | `JWT_SECRET` | 随便一串至少 32 位的乱码，比如 `M9xK2vQ7pL3nR8tW5yU1iE4oS6dF0gH7jA2cV5bN8mQ3xZ`（也可以自己乱敲）|

4. 点 **Save Changes / 保存**，Render 会自动重启服务
5. 等 1~2 分钟，状态重新变 **Live**

### 4.4 验证后端活了 ✅

1. 在服务页顶部找到你的网址，形如 `https://student-management.onrender.com`（如果服务名不叫 student-management，网址里的名字会不同，记住它）
2. 用浏览器打开：`https://student-management.onrender.com/api/auth/login`
3. 看到类似下面这样的文字就是**成功**（这是正常的，因为没带登录信息）：
   ```json
   {"code":401,"message":"用户名或密码错误","data":null}
   ```
4. （可选）打开 TiDB 的 Chat2Query，运行 `SHOW TABLES;`，能看到 20 多张表，说明后端自动建表成功 ✅

> **重要**：把 `https://student-management.onrender.com` 这个网址复制保存，第 5 步要用。

### 4.5 常见卡点

| 现象 | 处理 |
|---|---|
| 构建一直失败 | 点服务页 **Logs** 标签看红字。最常见是 DB_URL 里的 Host 填错或漏了 `sslMode=...` 那段 |
| 打开 `/api/auth/login` 要等 1 分钟 | 正常！免费版后端"睡觉"了，第一次访问要等它醒（冷启动 30~60 秒），刷新一次就好 |
| 状态一会儿 Live 一会儿 Down | 看 Logs 里有没有 MySQL 连接报错，多半是 DB_URL/用户名密码不对 |

---

## 第 5 步：Cloudflare Pages 部署前端（约 15 分钟）

### 5.1 注册登录

1. 打开 https://dash.cloudflare.com/sign-up ，邮箱注册（密码登录）
2. 登录后如果让你选套餐，选 **Free**，一路下一步

### 5.2 连接仓库并配置构建

1. 左侧菜单点 **Workers & Pages**
2. 点 **Create application** → 切到 **Pages** 标签 → 点 **Connect to Git**
3. 授权 GitHub（和 Render 一样）→ 选择 `student-management` 仓库 → 点 **Begin setup**
4. 在 **Build settings / 构建设置** 里填（很重要，照抄）：
   - **Framework preset**：选 **Vite**（如果下拉里找不到，选 None 也行，下面手动填）
   - **Root directory（根目录）**：填 `frontend`（因为前端代码在 frontend 文件夹里）
   - **Build command（构建命令）**：`npm ci && npm run build`
   - **Build output directory（输出目录）**：`dist`
5. 往下找到 **Environment variables（环境变量）**，点 **Add**，填：
   - 变量名：`VITE_API_BASE_URL`
   - 值：`https://student-management.onrender.com/api`（就是第 4.4 步那个网址 + `/api`）
6. 点 **Save and Deploy**，等 1~2 分钟，构建成功 ✅
7. 页面会给你一个网址，形如 `https://你的项目名.pages.dev` —— 这就是你的**正式网址**，复制保存

### 5.3 最终验证 ✅

1. 浏览器打开 `https://你的项目名.pages.dev`
2. 用种子账号登录：
   - 管理员：用户名 `admin`，密码 `123456`
   - 或教师：`teacher1` / `123456`
3. 登录成功，点左边菜单 **实时通信**，右上角出现绿色提示 **"实时通信已连接"** → 说明前后端 + 数据库 + WebSocket 全部打通 🎉
4. 让同学用手机浏览器打开同一个网址试试（手机也能用，项目做了响应式）

---

## 第 6 步：以后怎么更新、怎么排查

### 改完代码想更新线上版本

1. 本地改完代码后，重新执行第 3 步的提交推送（`git add -A` / `git commit` / `git push`）
2. **前端**：Cloudflare Pages 检测到 GitHub 有新提交，自动重新构建，1~2 分钟后生效
3. **后端**：Render 同样自动重新部署，3~5 分钟后生效

### 排查顺序（出问题按这个顺序查）

| 现象 | 大概率原因 | 怎么查/修 |
|---|---|---|
| 网页打不开 | Cloudflare Pages 还没构建完 | 等 2 分钟刷新；Pages 项目页看构建状态 |
| 网页能开，但登录提示"网络错误" | 后端在睡觉 / 环境变量不对 | 先单独打开 `https://student-management.onrender.com/api/auth/login` 等它醒；检查 VITE_API_BASE_URL |
| 登录提示"用户名或密码错误" | 数据库没连上（表没建）或密码不对 | 看 Render Logs；用 TiDB Chat2Query 跑 `SHOW TABLES;` 确认有表 |
| 聊天提示"连接未建立" | 后端休眠中 | 刷新页面等 30~60 秒冷启动 |
| 浏览器控制台报 Mixed Content | VITE_API_BASE_URL 写成了 http | 改成 https 重新部署前端 |

### 免费额度的底线（心里有数就行）

- **Render**：免费 Web Service 每月 750 小时，睡觉时不扣；15 分钟没人访问就休眠
- **TiDB**：Serverless 免费 5GB 存储、每月 5000 万行以内读请求，演示完全够用
- **Cloudflare Pages**：免费无限流量，每月 500 次构建
- 这些免费额度**不会突然扣钱**，用到上限只会暂停/报错，不会收费

---

## 附：演示数据说明

后端启动时 Flyway 会自动建 20 多张表并插入**种子数据**（3 个老师、5 个学生、几门课和成绩），足够演示。
仓库里 `database/batch_students.sql` 是 200 个学生的批量脚本，但它包含存储过程，普通网页编辑器跑不了，
**不建议小白手动执行**；如果答辩需要大量数据，可以让懂的人用 MySQL 客户端连 TiDB 执行。

## 附：如果以后想要"永不休眠"的免费服务器

Render 免费版会休眠。想要 7×24 在线，用 **Oracle Cloud Always Free**（免费云主机，ARM 4 核 24G 内存，
注册时验证信用卡但不扣费）。部署方式大同小异：把 Dockerfile 里那套环境变量照搬过去即可。
等你想升级了再来找我，我帮你出配套教程。
