# Redis Key 速查

这些 key 主要定义在 `RedisConstants` 和业务实现类中。学习时建议边调用接口边用 Redis 客户端观察 key 的变化。

| Key 模式 | 数据结构 | 说明 | 相关代码 |
| --- | --- | --- | --- |
| `login:code:{phone}` | String | 手机验证码，带 TTL | `UserServiceImpl#sendCode` |
| `login:token:{token}` | Hash | 登录用户信息，带 TTL | `UserServiceImpl#login` |
| `cache:shop:{id}` | String JSON | 商户缓存 | `ShopServiceImpl`, `CacheClient` |
| `lock:shop:{id}` | String | 商户缓存重建互斥锁 | `CacheClient` |
| `shop:geo:{typeId}` | GEO | 按商户类型保存坐标 | `loadShopData`, `queryShopByType` |
| `seckill:stock:{voucherId}` | String | 秒杀库存 | `seckill.lua` |
| `seckill:order:{voucherId}` | Set | 已抢购用户集合 | `seckill.lua` |
| `stream.orders` | Stream | 秒杀订单消息队列 | `VoucherOrderServiceImpl` |
| `sign:{userId}:yyyyMM` | BitMap | 用户月度签到记录 | `UserServiceImpl#sign` |
| `blog:liked:{blogId}` | ZSet | 笔记点赞用户排行 | `BlogServiceImpl#likeBlog` |
| `feed:{userId}` | ZSet | 用户收件箱 Feed 流 | `BlogServiceImpl#saveBlog` |
| `follows:{userId}` | Set | 用户关注集合 | `FollowServiceImpl#follow` |

## 当前环境提醒

本机 Redis 版本为 `3.2.100`，可学习 String、Hash、Set、ZSet、BitMap、GEO 的大部分内容，但不支持 Stream。要完整复现秒杀异步下单，建议启动 `docker-compose.yml` 中的 Redis 6.2，或安装 Redis 5+。

