# API 接口清单

后端基础地址：

```text
http://127.0.0.1:8081
```

前端代理路径：

```text
http://127.0.0.1:8082/api
```

## 用户与登录

| 方法 | 路径 | 说明 | 相关模块 |
| --- | --- | --- | --- |
| POST | `/user/code` | 发送验证码 | Redis String + TTL |
| POST | `/user/login` | 手机验证码登录 | token 登录态、Redis Hash |
| GET | `/user/me` | 获取当前用户 | 拦截器、ThreadLocal |
| POST | `/user/sign` | 签到 | BitMap |
| GET | `/user/sign/count` | 连续签到统计 | BITFIELD |

## 商户

| 方法 | 路径 | 说明 | 相关模块 |
| --- | --- | --- | --- |
| GET | `/shop/{id}` | 根据 id 查询商户 | 缓存穿透、击穿、逻辑过期 |
| PUT | `/shop` | 修改商户 | 数据库与缓存一致性 |
| GET | `/shop/of/type` | 按类型分页查询商户 | 分页、GEO 附近查询 |
| GET | `/shop-type/list` | 查询商户类型 | Redis List 缓存 |

## 优惠券与秒杀

| 方法 | 路径 | 说明 | 相关模块 |
| --- | --- | --- | --- |
| POST | `/voucher/seckill` | 新增秒杀券 | MySQL 数据准备 |
| POST | `/voucher-order/seckill/{id}` | 秒杀下单 | Lua、分布式锁、Redis Stream |

Redis Stream 相关能力需要 Redis 5+。

## 探店与关注

| 方法 | 路径 | 说明 | 相关模块 |
| --- | --- | --- | --- |
| GET | `/blog/hot` | 热门探店笔记 | 分页、点赞状态 |
| GET | `/blog/{id}` | 查询笔记详情 | 用户信息补全 |
| PUT | `/blog/like/{id}` | 点赞或取消点赞 | ZSet 排行 |
| GET | `/blog/likes/{id}` | 查询点赞 top5 | ZSet 分数排序 |
| POST | `/blog` | 发布探店笔记 | Feed 流推送 |
| GET | `/blog/of/follow` | 查询关注流 | ZSet 滚动分页 |
| PUT | `/follow/{id}/{isFollow}` | 关注或取消关注 | Set |
| GET | `/follow/or/not/{id}` | 查询是否关注 | MySQL 查询 |
| GET | `/follow/common/{id}` | 查询共同关注 | Set 交集 |
