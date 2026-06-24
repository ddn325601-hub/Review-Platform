# 黑马点评 Redis 实战学习工作区

这个工作区是从 `D:\BaiduNetdiskDownload\02-实战篇` 重新整理出来的学习版，原始资料没有被改动。目录里同时保留了课程起始代码、完整实现代码、前端静态页、讲义、SQL、压测脚本和素材，方便你一边复现一边对照。

## 目录说明

| 路径 | 作用 |
| --- | --- |
| `backend/hm-dianping-starter` | 课程起始后端代码，适合按讲义一步步补 Redis 功能 |
| `backend/hm-dianping-complete` | 完整实现版后端代码，适合运行验证和对照答案 |
| `frontend/hmdp` | 黑马点评前端静态页面，接口默认走 `/api` |
| `docs/Redis实战篇.md` | 原课程讲义，已按 UTF-8 复制 |
| `docs/项目启动指南.md` | 当前机器的启动、账号密码和验证说明 |
| `docs/项目学习指南.md` | 按章节复现项目的学习路径 |
| `docs/项目启动与功能操作教学.md` | 启动、页面操作、接口验证、Redis/MySQL 观察与排错 |
| `docs/学习路线.md` | 推荐学习顺序和每章复现目标 |
| `docs/本地复现指南.md` | 从启动依赖到跑前后端的步骤 |
| `docs/代码导读.md` | Redis 主题与关键代码文件索引 |
| `docs/章节任务卡.md` | 按章节打卡的复现任务 |
| `docs/API接口清单.md` | 前后端接口与对应学习点 |
| `docs/Redis-Key速查.md` | Redis key、数据结构和代码位置 |
| `docs/当前启动状态.md` | 本机当前启动情况和限制 |
| `resources/db/hmdp.sql` | MySQL 初始化脚本 |
| `resources/jmeter/秒杀抢购.jmx` | 秒杀压测脚本 |
| `resources/materials/素材` | 探店素材图片与文案 |
| `resources/runtime/nginx-1.18.0.zip` | 原课程 Nginx 包备份 |

## 最短运行路径

1. 启动依赖：

```powershell
docker compose up -d
```

2. 运行完整后端：

```powershell
cd backend\hm-dianping-complete
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

3. 访问前端：

使用课程 Nginx 更贴近原环境；如果只是快速看页面，可以先打开 `frontend/hmdp/index.html`，但接口请求需要 `/api` 代理到 `http://127.0.0.1:8081`。

完整步骤见 `docs/本地复现指南.md`。
