# Redis Key 速查

这些 key 主要定义在 `RedisConstants` 和业务实现类中，可用于定位缓存、登录态、Feed 流、签到和秒杀相关数据。

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

## 版本说明

String、Hash、Set、ZSet、BitMap 和 GEO 可在常见 Redis 版本中使用。`stream.orders` 依赖 Redis Stream，需要 Redis 5+。
