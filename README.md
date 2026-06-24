# Review Platform

Review Platform is a Dianping-style local services demo. It contains two Spring Boot backends, static frontend pages, database scripts, Redis/MySQL configuration, and operational notes for running the project locally.

## Structure

| Path | Description |
| --- | --- |
| `backend/hm-dianping-starter` | Starter backend used for incremental implementation |
| `backend/hm-dianping-complete` | Complete backend used for verification and comparison |
| `frontend/hmdp` | Static frontend pages; API requests are sent through `/api` |
| `resources/db/hmdp.sql` | MySQL initialization script |
| `resources/jmeter/秒杀抢购.jmx` | Voucher seckill load-test script |
| `resources/materials/素材` | Image and text materials used by the demo |
| `scripts/start-starter.ps1` | Local helper script for the starter backend |
| `scripts/stop-local.ps1` | Stops local backend/frontend helper processes |
| `config/local-env.example.ps1` | Example environment variable file |

## Documentation

| File | Description |
| --- | --- |
| `docs/项目启动指南.md` | Local startup options and configuration |
| `docs/功能操作指南.md` | Feature operation guide and verification steps |
| `docs/本地复现指南.md` | Reproduction guide from dependencies to frontend access |
| `docs/API接口清单.md` | Main backend API list |
| `docs/Redis-Key速查.md` | Redis key and data-structure reference |
| `docs/代码导读.md` | Backend module and Redis-related code map |

## Quick Start

1. Start infrastructure:

```powershell
docker compose up -d
```

2. Configure local credentials:

```powershell
Copy-Item .\config\local-env.example.ps1 .\config\local-env.ps1
notepad .\config\local-env.ps1
. .\config\local-env.ps1
```

3. Run a backend:

```powershell
cd backend\hm-dianping-complete
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

4. Serve the frontend with Nginx or another static server that proxies `/api` to `http://127.0.0.1:8081`.

See `docs/项目启动指南.md` for detailed commands.
