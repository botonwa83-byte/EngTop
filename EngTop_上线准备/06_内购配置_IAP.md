# EngTop 内购配置（App Store Connect）

## 商品参数

| 项 | 值 |
|----|----|
| 类型 | 非消耗型 / Non-Consumable |
| 产品 ID | `com.engtop.app.full_unlock` |
| 参考名称（Reference Name） | `EngTop Full Unlock` |
| 显示名称（中文） | `完整版解锁` |
| 价格 | ¥22 档位（以 ASC 实际价格档为准） |
| 家庭共享 | 关闭 |
| 审核截图 | 付费墙截图（建议 6.9" 一张） |

> ⚠️ 本轮已把产品 ID 从 `com.engapex.app.full_unlock` 改为 `com.engtop.app.full_unlock`。ASC 中若已创建 engapex 商品，**不要复用**，必须在 EngTop 的 App 下新建本商品。

## 商品描述（ASC）

完整版解锁：开放主线全部七关（阅读 / 应用文 / 读后续写 / 听力等）、两个工坊全部场景与写作教练。免费部分（主线前 3 关、提分驾驶舱、估分器、提分雷达、考点图谱、句式库、词汇专项、错题本、能力训练营）继续保持免费。无订阅、无续费，支持换机恢复购买。

## 代码一致性核对

| 位置 | 值 | 状态 |
|------|----|------|
| `EngTopApp/Core/Engine/PurchaseManager.swift` → `productID` | `com.engtop.app.full_unlock` | ✅ |
| `EngTopApp.storekit` → `productID` | `com.engtop.app.full_unlock` | ✅ |
| `project.yml` → `PRODUCT_BUNDLE_IDENTIFIER` | `com.engtop.app` | ✅ |
| 产品 ID 前缀与 bundle id 一致 | `com.engtop.app.` | ✅ |
| UserDefaults 购买缓存键 | `engtop_full_unlocked`（原 `engapex_full_unlocked`） | ✅ |

## 免费档划线（代码中的常量）

- `PurchaseManager.freeLevelCount = 3`：主线前 3 关免费。
- `MainLevel.isFree` 标记必须与之一致，由 `EngTopAppTests/PurchasePolicyTests.swift` 守门。
- 工坊场景的 `isFree` 标记（每个体裁/主题第 1 个场景）另行维护，调整时同步更新审核备注。

## 提交前

- ⬜ 在 ASC「App 内购买项目」按上表新建商品，状态设为「准备提交」。
- ⬜ 在版本页勾选本商品随版本一起提交。
- ⬜ 沙盒实测：购买解锁、恢复购买、取消不解锁、删除重装可恢复。
