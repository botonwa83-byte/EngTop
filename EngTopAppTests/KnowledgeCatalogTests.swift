import XCTest
@testable import EngTopApp

final class KnowledgeCatalogTests: XCTestCase {
    func testCatalogHasUniqueIDs() {
        let ids = JuniorKnowledgeCatalog.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count)
    }

    func testCatalogCoversEveryStageAndAbility() {
        XCTAssertEqual(Set(JuniorKnowledgeCatalog.all.map(\.stage)), Set(StudyStage.allCases))
        XCTAssertEqual(Set(JuniorKnowledgeCatalog.all.map(\.ability)), Set(Ability.allCases))
    }

    func testEveryPointHasTeachingMaterial() {
        XCTAssertTrue(JuniorKnowledgeCatalog.all.allSatisfy {
            !$0.title.isEmpty && !$0.summary.isEmpty && !$0.examples.isEmpty
        })
    }

    func testCatalogHasCurriculumScaleCoverage() {
        XCTAssertGreaterThanOrEqual(JuniorKnowledgeCatalog.all.count, 140)
        for stage in StudyStage.allCases {
            XCTAssertGreaterThanOrEqual(JuniorKnowledgeCatalog.all.filter { $0.stage == stage }.count, 20)
        }
    }

    func testCatalogCanFilterByStageAbilityAndText() {
        let results = JuniorKnowledgeCatalog.points(stage: .juniorThree, ability: .tense, query: "完成时")
        XCTAssertFalse(results.isEmpty)
        XCTAssertTrue(results.allSatisfy { $0.stage == .juniorThree && $0.ability == .tense })
    }

    func testEveryKnowledgePointGeneratesThreeValidQuestions() {
        for point in JuniorKnowledgeCatalog.all {
            let questions = KnowledgePracticeFactory.questions(for: point)
            XCTAssertEqual(questions.count, 3)
            XCTAssertTrue(questions.allSatisfy { !$0.options.isEmpty && $0.options.indices.contains($0.answer) })
            XCTAssertTrue(questions.allSatisfy { $0.knowledgePointID == point.id })
        }
    }

    func testCuratedQuestionsCoverMultipleStagesAndAbilities() {
        XCTAssertGreaterThanOrEqual(CuratedKnowledgeQuestions.all.count, 40)
        XCTAssertEqual(Set(CuratedKnowledgeQuestions.all.compactMap { question in
            JuniorKnowledgeCatalog.all.first { $0.id == question.knowledgePointID }?.stage
        }).count, 4)
    }
}
