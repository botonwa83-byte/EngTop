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
        XCTAssertGreaterThanOrEqual(CuratedKnowledgeQuestions.all.count, 100)
        XCTAssertEqual(Set(CuratedKnowledgeQuestions.all.compactMap { question in
            JuniorKnowledgeCatalog.all.first { $0.id == question.knowledgePointID }?.stage
        }).count, 4)
    }

    func testCuratedQuestionsReferenceRealPointsAndHaveUniqueIDs() {
        let pointIDs = Set(JuniorKnowledgeCatalog.all.map(\.id))
        let questions = CuratedKnowledgeQuestions.all
        XCTAssertEqual(Set(questions.map(\.id)).count, questions.count)
        XCTAssertTrue(questions.allSatisfy { pointIDs.contains($0.knowledgePointID) })
        XCTAssertTrue(questions.allSatisfy { $0.options.indices.contains($0.answer) && Set($0.options).count == $0.options.count })
    }

    func testEveryKnowledgePointHasACompleteLesson() {
        let lessons = KnowledgeLessonCatalog.all()
        XCTAssertEqual(lessons.count, JuniorKnowledgeCatalog.all.count)
        XCTAssertTrue(lessons.allSatisfy { !$0.rule.isEmpty && !$0.example.isEmpty && !$0.trap.isEmpty && !$0.transfer.isEmpty })
    }
}
