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

    func testEveryKnowledgePointGeneratesTwentyValidQuestions() {
        for point in JuniorKnowledgeCatalog.all {
            let questions = KnowledgePracticeFactory.questions(for: point)
            XCTAssertEqual(questions.count, 20)
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

    func testCuratedQuestionLookupUsesKnowledgePointID() {
        let question = CuratedKnowledgeQuestions.all.first { $0.id == "j3-challenge-21" }
        XCTAssertEqual(question?.knowledgePointID, "j3-perfect")
        XCTAssertTrue(CuratedKnowledgeQuestions.forPoint("j3-perfect").contains { $0.id == question?.id })
    }

    func testEveryPointHasAQuestionWithItsOwnExample() {
        for point in JuniorKnowledgeCatalog.all {
            let questions = KnowledgePracticeFactory.questions(for: point)
            XCTAssertTrue(questions.contains { $0.knowledgePointID == point.id })
        }
    }

    func testEveryKnowledgePointHasACompleteLesson() {
        let lessons = KnowledgeLessonCatalog.all()
        XCTAssertEqual(lessons.count, JuniorKnowledgeCatalog.all.count)
        XCTAssertTrue(lessons.allSatisfy { !$0.rule.isEmpty && !$0.example.isEmpty && !$0.trap.isEmpty && !$0.transfer.isEmpty })
    }

    // MARK: 有效练习题注入（120 道，两批分布）

    func testInjectionHasTwoBatchesTotallingOneHundredTwenty() {
        XCTAssertEqual(KnowledgeQuestionInjection.distributionBatch.count, 64)
        XCTAssertEqual(KnowledgeQuestionInjection.importanceBatch.count, 56)
        XCTAssertEqual(KnowledgeQuestionInjection.all.count, 120)
        XCTAssertGreaterThanOrEqual(KnowledgeQuestionInjection.all.count, 100)
    }

    func testInjectionDistributionBatchCoversThirtyTwoPointsTwice() {
        let grouped = Dictionary(grouping: KnowledgeQuestionInjection.distributionBatch, by: \.knowledgePointID)
        XCTAssertEqual(grouped.count, 32)
        XCTAssertTrue(grouped.values.allSatisfy { $0.count == 2 })
    }

    func testInjectionImportanceBatchTargetsCorePointsTwice() {
        let grouped = Dictionary(grouping: KnowledgeQuestionInjection.importanceBatch, by: \.knowledgePointID)
        XCTAssertEqual(grouped.count, 28)
        XCTAssertTrue(grouped.values.allSatisfy { $0.count == 2 })
        // 重要性批次应集中在初三核心语法/技能上
        let stages = grouped.keys.compactMap { id in
            JuniorKnowledgeCatalog.all.first { $0.id == id }?.stage
        }
        XCTAssertGreaterThanOrEqual(stages.filter { $0 == .juniorThree }.count, 14)
    }

    func testInjectionQuestionsAreValidAndUnique() {
        let questions = KnowledgeQuestionInjection.all
        XCTAssertEqual(Set(questions.map(\.id)).count, questions.count)
        let pointIDs = Set(JuniorKnowledgeCatalog.all.map(\.id))
        XCTAssertTrue(questions.allSatisfy { pointIDs.contains($0.knowledgePointID) })
        XCTAssertTrue(questions.allSatisfy { $0.options.count == 4 })
        XCTAssertTrue(questions.allSatisfy { $0.options.indices.contains($0.answer) })
        XCTAssertTrue(questions.allSatisfy { Set($0.options).count == $0.options.count })
        XCTAssertTrue(questions.allSatisfy { !$0.prompt.isEmpty && !$0.explanation.isEmpty })
    }

    func testEveryKnowledgePointNowHasCuratedPractice() {
        for point in JuniorKnowledgeCatalog.all {
            XCTAssertFalse(
                CuratedKnowledgeQuestions.forPoint(point.id).isEmpty,
                "\(point.id)「\(point.title)」缺少有效练习题")
        }
    }

    // MARK: 第二轮注入（151 道，把每个知识点的题量下限抬到 3 道）

    func testSecondInjectionTotalsOneHundredFiftyOne() {
        XCTAssertEqual(KnowledgeQuestionInjection2.primaryBatch.count, 40)
        XCTAssertEqual(KnowledgeQuestionInjection2.juniorOneBatch.count, 45)
        XCTAssertEqual(KnowledgeQuestionInjection2.juniorTwoBatch.count, 45)
        XCTAssertEqual(KnowledgeQuestionInjection2.juniorThreeBatch.count, 21)
        XCTAssertEqual(KnowledgeQuestionInjection2.all.count, 151)
    }

    func testSecondInjectionQuestionsAreValidAndUnique() {
        let questions = KnowledgeQuestionInjection2.all
        let pointIDs = Set(JuniorKnowledgeCatalog.all.map(\.id))
        XCTAssertEqual(Set(questions.map(\.id)).count, questions.count)
        XCTAssertTrue(questions.allSatisfy { pointIDs.contains($0.knowledgePointID) })
        XCTAssertTrue(questions.allSatisfy { $0.options.count == 4 })
        XCTAssertTrue(questions.allSatisfy { $0.options.indices.contains($0.answer) })
        XCTAssertTrue(questions.allSatisfy { Set($0.options).count == $0.options.count })
        XCTAssertTrue(questions.allSatisfy { !$0.prompt.isEmpty && !$0.explanation.isEmpty && !$0.kind.isEmpty })
        // 与既有题库不重叠
        let existing = Set((KnowledgeQuestionInjection.all + KnowledgeQuestionInjection2.all).map(\.id))
        XCTAssertEqual(existing.count, KnowledgeQuestionInjection.all.count + questions.count)
    }

    func testEveryKnowledgePointHasAtLeastThreeCuratedQuestions() {
        for point in JuniorKnowledgeCatalog.all {
            let count = CuratedKnowledgeQuestions.forPoint(point.id).count
            XCTAssertGreaterThanOrEqual(count, 3, "\(point.id)「\(point.title)」只有 \(count) 道有效练习")
        }
    }

    func testAnswerPositionsAreBalancedAcrossTheBank() {
        let questions = CuratedKnowledgeQuestions.all
        let total = questions.count
        for index in 0..<4 {
            let ratio = Double(questions.filter { $0.answer == index }.count) / Double(total)
            XCTAssertGreaterThan(ratio, 0.15, "正确选项落在第 \(index) 位的比例过低：\(ratio)")
            XCTAssertLessThan(ratio, 0.35, "正确选项落在第 \(index) 位的比例过高：\(ratio)")
        }
    }

    func testQuestionsOfTheSamePointDoNotShareOneAnswerSlot() {
        let grouped = Dictionary(grouping: CuratedKnowledgeQuestions.all, by: \.knowledgePointID)
        for (pointID, questions) in grouped where questions.count >= 2 {
            let slots = Set(questions.map(\.answer))
            XCTAssertGreaterThan(slots.count, 1, "\(pointID) 的题目正确选项位置完全相同，容易被猜中")
        }
    }

    // MARK: 第三轮注入（145 道英语学习方法专项，每个知识点 1 道）

    func testThirdInjectionTotalsOneHundredFortyFive() {
        XCTAssertEqual(KnowledgeQuestionInjection3.primaryBatch.count, 33)
        XCTAssertEqual(KnowledgeQuestionInjection3.juniorOneBatch.count, 33)
        XCTAssertEqual(KnowledgeQuestionInjection3.juniorTwoBatch.count, 37)
        XCTAssertEqual(KnowledgeQuestionInjection3.juniorThreeBatch.count, 42)
        XCTAssertEqual(KnowledgeQuestionInjection3.all.count, 145)
    }

    func testThirdInjectionQuestionsAreValidAndUnique() {
        let questions = KnowledgeQuestionInjection3.all
        let pointIDs = Set(JuniorKnowledgeCatalog.all.map(\.id))
        XCTAssertEqual(Set(questions.map(\.id)).count, questions.count)
        XCTAssertTrue(questions.allSatisfy { $0.id.hasPrefix("inj3-") })
        XCTAssertTrue(questions.allSatisfy { pointIDs.contains($0.knowledgePointID) })
        XCTAssertTrue(questions.allSatisfy { $0.options.count == 4 })
        XCTAssertTrue(questions.allSatisfy { $0.options.indices.contains($0.answer) })
        XCTAssertTrue(questions.allSatisfy { Set($0.options).count == $0.options.count })
        XCTAssertTrue(questions.allSatisfy {
            !$0.prompt.isEmpty && !$0.explanation.isEmpty && !$0.kind.isEmpty
        })
        // 与前两轮注入不重叠
        let earlier = Set((KnowledgeQuestionInjection.all + KnowledgeQuestionInjection2.all).map(\.id))
        let union = earlier.union(questions.map(\.id))
        XCTAssertEqual(union.count, earlier.count + questions.count)
    }

    func testEveryPointHasExactlyOneMethodQuestion() {
        for point in JuniorKnowledgeCatalog.all {
            let count = KnowledgeQuestionInjection3.all.filter { $0.knowledgePointID == point.id }.count
            XCTAssertEqual(count, 1, "\(point.id)「\(point.title)」的方法题应为 1 道，实际 \(count) 道")
        }
    }

    /// 题干里标注的方法名，必须和 `StudyMethodCatalog.primary(for:)` 指派的方法一致。
    /// 这条把「题库」和「学习方法体系」绑在一起，防止两边各自漂移。
    func testEveryMethodQuestionIsTaggedWithItsAssignedMethod() {
        for point in JuniorKnowledgeCatalog.all {
            guard let question = KnowledgeQuestionInjection3.all.first(where: { $0.knowledgePointID == point.id }) else {
                XCTFail("\(point.id) 缺少方法题")
                continue
            }
            let expected = StudyMethodCatalog.primary(for: point)
            XCTAssertTrue(question.prompt.contains(expected.title),
                          "\(point.id)「\(point.title)」应由「\(expected.title)」出题，题干为：\(question.prompt)")
            XCTAssertTrue(StudyMethodCatalog.isMethodQuestion(question),
                          "\(question.id) 应被识别为方法题")
        }
    }

    func testEveryPointHasAtLeastFourCuratedQuestions() {
        for point in JuniorKnowledgeCatalog.all {
            let count = CuratedKnowledgeQuestions.forPoint(point.id).count
            XCTAssertGreaterThanOrEqual(count, 4, "\(point.id)「\(point.title)」只有 \(count) 道有效练习")
        }
    }

    func testCuratedBankTotalsSixHundredTwentySeven() {
        // 211 核心 + 120 一轮 + 151 二轮 + 145 三轮
        XCTAssertEqual(CuratedKnowledgeQuestions.all.count, 627)
        XCTAssertEqual(KnowledgeQuestionInjection.all.count + KnowledgeQuestionInjection2.all.count
                       + KnowledgeQuestionInjection3.all.count, 416)
    }

    func testCuratedQuestionLookupCanRestoreEveryMethodQuestion() {
        for question in KnowledgeQuestionInjection3.all {
            XCTAssertEqual(CuratedKnowledgeQuestions.find(question.id)?.id, question.id)
        }
    }

    // MARK: 学习方法体系

    func testStudyMethodCatalogAssignsPointsToEveryMethodExceptSpacing() {
        // 间隔复盘法是通用复习动作，不专属某个知识点
        for method in StudyMethod.allCases where method != .spacing {
            XCTAssertFalse(StudyMethodCatalog.points(of: method).isEmpty,
                           "\(method.title) 没有指派任何知识点")
        }
        XCTAssertTrue(StudyMethodCatalog.points(of: .spacing).isEmpty)
    }

    func testEveryPointIsPairedWithItsPrimaryMethodAndSpacing() {
        for point in JuniorKnowledgeCatalog.all {
            let methods = StudyMethodCatalog.methods(for: point)
            XCTAssertTrue(methods.contains(StudyMethodCatalog.primary(for: point)),
                          "\(point.id) 的配套方法应包含主方法")
            XCTAssertTrue(methods.contains(.spacing), "\(point.id) 应配套间隔复盘法")
        }
    }

    func testEveryMethodHasFourStepsAndCompleteFields() {
        for method in StudyMethod.allCases {
            XCTAssertEqual(method.steps.count, 4, "\(method.title) 的四步动作应为 4 步")
            XCTAssertTrue(method.steps.allSatisfy { !$0.isEmpty })
            XCTAssertFalse(method.oneLiner.isEmpty)
            XCTAssertFalse(method.exampleEn.isEmpty)
            XCTAssertFalse(method.exampleHint.isEmpty)
            XCTAssertFalse(method.pitfall.isEmpty)
            XCTAssertFalse(method.selfCheck.isEmpty)
            XCTAssertFalse(method.abilities.isEmpty)
        }
    }

    func testStudyMethodSearchMatchesNameAndSteps() {
        XCTAssertTrue(StudyMethodCatalog.search("时间标志").contains(.timeMarker))
        XCTAssertTrue(StudyMethodCatalog.search("对比").contains(.contrast))
        XCTAssertTrue(StudyMethodCatalog.search("间隔").contains(.spacing))
        XCTAssertEqual(StudyMethodCatalog.search("").count, StudyMethod.allCases.count)
    }

    // MARK: 练 → 复 打通：知识点题与学习方法都能被复习项还原

    func testKnowledgeAndMethodReviewRefsResolve() {
        guard let sample = KnowledgeQuestionInjection3.all.first else {
            return XCTFail("第三轮题库为空")
        }
        guard case .knowledge(let resolved)? = ReviewRef.resolve("k:\(sample.id)") else {
            return XCTFail("k: 前缀复习项未还原为知识点题")
        }
        XCTAssertEqual(resolved.id, sample.id)
        XCTAssertEqual(resolved.knowledgePointID, sample.knowledgePointID)
        XCTAssertEqual(ReviewRef.resolve("k:\(sample.id)")?.knowledgePointID, sample.knowledgePointID)

        guard case .method(let method)? = ReviewRef.resolve("m:timeMarker") else {
            return XCTFail("m: 前缀复习项未还原为学习方法")
        }
        XCTAssertEqual(method, .timeMarker)
    }

    func testUnknownKnowledgeAndMethodReviewRefsAreRejected() {
        XCTAssertNil(ReviewRef.resolve("k:not-a-real-question"))
        XCTAssertNil(ReviewRef.resolve("m:not-a-real-method"))
    }
}
