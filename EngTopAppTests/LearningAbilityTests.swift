import XCTest
@testable import EngTopApp

final class LearningAbilityTests: XCTestCase {
    func testMissionCatalogCoversEveryLearningAbilityAndStage() {
        let missions = LearningMissionCatalog.all

        XCTAssertGreaterThanOrEqual(missions.count, 12)
        XCTAssertEqual(Set(missions.map(\.id)).count, missions.count)
        XCTAssertEqual(Set(missions.map(\.ability)), Set(LearningAbility.allCases))
        XCTAssertEqual(Set(missions.map(\.stage)), Set(StudyStage.allCases))

        for ability in LearningAbility.allCases {
            XCTAssertGreaterThanOrEqual(missions.filter { $0.ability == ability }.count, 2)
        }
    }

    func testProgressScoreRewardsAccuracyTransferAndReflection() {
        let stats = LearningMissionStat(attempts: 2, correct: 1, transfers: 1, reflections: 1)

        XCTAssertEqual(LearningProgressEngine.score(for: stats), 50)
    }

    func testRecommendationMovesPastCompletedMission() {
        let defaults = UserDefaults(suiteName: "LearningAbilityTests.recommendation")!
        defaults.removePersistentDomain(forName: "LearningAbilityTests.recommendation")
        let store = LearningProgressStore(defaults: defaults)
        let first = LearningMissionCatalog.all[0]

        store.record(first, correct: true, transferCompleted: true, reflectionCompleted: true)

        XCTAssertNotEqual(store.recommendedMission.id, first.id)
        XCTAssertEqual(store.stat(for: first.id).attempts, 1)
        XCTAssertEqual(store.stat(for: first.id).transfers, 1)
        XCTAssertEqual(store.stat(for: first.id).reflections, 1)
    }
}
