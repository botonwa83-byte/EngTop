import XCTest
@testable import EngTopApp

/// 上线守门测试：内购产品 ID 与免费档划线。
/// 范式要求「内购划线靠常量 + 单测守门」，改动 freeLevelCount 或关卡 isFree 标记时这里会先失败。
final class PurchasePolicyTests: XCTestCase {

    func testProductIDMatchesBundlePrefix() {
        let manager = PurchaseManager.shared
        XCTAssertEqual(manager.productID, "com.engtop.app.full_unlock")
        XCTAssertTrue(
            manager.productID.hasPrefix("com.engtop.app."),
            "内购产品 ID 前缀必须与 App 的 bundle id 一致，否则 App Store Connect 无法关联商品"
        )
    }

    func testFreeTierPolicy() {
        let free = PurchaseManager.freeLevelCount
        XCTAssertGreaterThan(free, 0)
        XCTAssertLessThan(free, MainLineData.levels.count, "免费档之外必须留有付费主线关卡")

        for level in MainLineData.levels.prefix(free) {
            XCTAssertTrue(level.isFree, "前 \(free) 关应标记为免费：\(level.id)")
        }
        for level in MainLineData.levels.dropFirst(free) {
            XCTAssertFalse(level.isFree, "第 \(free) 关之后应为付费关卡：\(level.id)")
        }
    }

    func testFreeLevelsAreNeverLocked() {
        let manager = PurchaseManager.shared
        for level in MainLineData.levels where level.order <= PurchaseManager.freeLevelCount {
            XCTAssertFalse(manager.isLevelLocked(level), "免费关卡不应被锁：\(level.id)")
        }
    }
}
