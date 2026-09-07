import XCTest
@testable import EngTopApp

final class AbilityEngineTests: XCTestCase {
    func testCorrectSentenceChallengeAddsXPAndUpdatesAbility() {
        var profile = AbilityProfile()
        profile.apply(result: .correct, ability: .wordOrder)

        XCTAssertEqual(profile.xp, 12)
        XCTAssertEqual(profile.score(for: .wordOrder), 6)
        XCTAssertEqual(profile.combo, 1)
    }

    func testWrongAnswerBreaksComboButKeepsScoreBounded() {
        var profile = AbilityProfile()
        profile.apply(result: .correct, ability: .wordOrder)
        profile.apply(result: .wrong, ability: .wordOrder)

        XCTAssertEqual(profile.combo, 0)
        XCTAssertEqual(profile.xp, 12)
        XCTAssertGreaterThanOrEqual(profile.score(for: .wordOrder), 0)
    }
}
