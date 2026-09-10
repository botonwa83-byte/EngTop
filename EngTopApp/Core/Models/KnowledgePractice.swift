import Foundation

struct KnowledgePracticeQuestion: Identifiable {
    let id: String
    let knowledgePointID: String
    let prompt: String
    let options: [String]
    let answer: Int
    let explanation: String
    let kind: String
}

/// 知识点专项练习工厂。
///
/// 每个知识点固定产出 `questionsPerPoint`（20）道题，分两批练习：
/// 1. 先取人工策展题（`CuratedKnowledgeQuestions`）——作者编写的题最优先；
/// 2. 再用 `KnowledgePracticeGenerator` 依据该知识点自身的规则摘要、示例、能力和学段派生巩固题补齐。
///
/// 派生题只使用知识点目录里已有的授权内容，不臆造“某年某卷”的真题出处；
/// 每题都带 `kind` 题型标签，学生能看到自己在练识别、理解、归类、策略、迁移还是复盘。
enum KnowledgePracticeFactory {
    static let questionsPerPoint = 20
    static let batchSize = 10

    static func questions(for point: JuniorKnowledgePoint) -> [KnowledgePracticeQuestion] {
        var items = CuratedKnowledgeQuestions.forPoint(point.id)
        var seen = Set(items.map(\.id))

        let derived = KnowledgePracticeGenerator.consolidation(for: point)
        guard !derived.isEmpty else { return Array(items.prefix(questionsPerPoint)) }

        var cursor = 0
        while items.count < questionsPerPoint {
            let source = derived[cursor % derived.count]
            cursor += 1
            let padded = KnowledgePracticeQuestion(
                id: "\(source.id)-r\(cursor)",
                knowledgePointID: source.knowledgePointID,
                prompt: source.prompt,
                options: source.options,
                answer: source.answer,
                explanation: source.explanation,
                kind: source.kind
            )
            if seen.insert(padded.id).inserted { items.append(padded) }
            if cursor > derived.count * 2 { break }
        }
        return Array(items.prefix(questionsPerPoint))
    }
}

/// 巩固题派生器。
///
/// 设计原则：
/// - 只使用知识点自身的 `summary`、`examples`、`ability`、`stage` 和讲解卡的规则文本；
/// - 干扰项取自同阶段其它知识点，保证“干扰项也是真实存在的英语知识点”，不凭空造句；
/// - 生成过程完全确定（自实现哈希决定正确项位置），同一知识点每次产出同样的 20 道题，便于测试与复习。
enum KnowledgePracticeGenerator {
    // MARK: - 对外入口

    static func consolidation(for point: JuniorKnowledgePoint) -> [KnowledgePracticeQuestion] {
        drafts(for: point).enumerated().compactMap { index, draft in
            make(
                point: point,
                index: index + 1,
                prompt: draft.prompt,
                correct: draft.correct,
                distractors: draft.distractors,
                explanation: draft.explanation,
                kind: draft.kind
            )
        }
    }

    // MARK: - 内部类型

    private struct Draft {
        let prompt: String
        let correct: String
        let distractors: [String]
        let explanation: String
        let kind: String
    }

    // MARK: - 20 道巩固题

    private static func drafts(for point: JuniorKnowledgePoint) -> [Draft] {
        let peers = JuniorKnowledgeCatalog.all.filter { $0.stage == point.stage && $0.id != point.id }
        let peerExamples = rotate(unique(peers.flatMap(\.examples)), by: 1)
        let peerSummaries = unique(peers.map(\.summary))
        let peerTitles = rotate(unique(peers.map(\.title)), by: 1)

        let ownExamples = unique(point.examples)
        let sample = ownExamples.first ?? point.summary
        let alternate = ownExamples.count > 1 ? ownExamples[1] : sample

        let hints = LearningStrategyHints.self
        let rule = KnowledgeLessonCatalog.ruleText(for: point.ability)
        let others = hints.alternateAbilities(point.ability)

        // 按能力类型作答的题需要先给出能力归属，否则多个选项都说得通。这里与知识图谱里的标签保持一致。
        let label = "「\(point.title)」（\(point.ability.title)类）"
        let transferTask = hints.transferTask(point.ability, sample: sample)
        let pathTask = "先读「\(point.title)」的规则摘要 → 再观察示例「\(sample)」→ 最后做巩固题并写一次迁移。"

        return [
            // 1—2 示例识别：确认能认出这个知识点的正确用法
            Draft(prompt: "下面哪一项是「\(point.title)」的正确示例？",
                  correct: sample,
                  distractors: peerExamples,
                  explanation: "「\(sample)」直接体现了「\(point.title)」。核心规则：\(point.summary)",
                  kind: "识别"),
            Draft(prompt: "哪一项符合「\(point.title)」的用法？",
                  correct: alternate,
                  distractors: rotate(peerExamples, by: 2),
                  explanation: "「\(alternate)」同样属于「\(point.title)」。判断依据是规则摘要：\(point.summary)",
                  kind: "识别"),

            // 3—4 规则摘要：正向匹配与反查各一次
            Draft(prompt: "下面哪一项描述的是「\(point.title)」？",
                  correct: point.summary,
                  distractors: peerSummaries,
                  explanation: "「\(point.title)」的规则摘要就是：\(point.summary)",
                  kind: "理解"),
            Draft(prompt: "「\(point.title)」主要帮助你掌握什么？",
                  correct: point.summary,
                  distractors: rotate(peerSummaries, by: 3),
                  explanation: "这个知识点的学习目标：\(point.summary)",
                  kind: "理解"),

            // 5—6 归类：能力与学段
            Draft(prompt: "「\(point.title)」主要训练哪项英语能力？",
                  correct: point.ability.title,
                  distractors: others.map(\.title),
                  explanation: "「\(point.title)」归在「\(point.ability.title)」能力下。",
                  kind: "归类"),
            Draft(prompt: "「\(point.title)」属于哪个学段的学习内容？",
                  correct: point.stage.title,
                  distractors: StudyStage.allCases.filter { $0 != point.stage }.map(\.title),
                  explanation: "「\(point.title)」安排在「\(point.stage.title)」阶段学习。",
                  kind: "归类"),

            // 7—10 学习策略：第一步、掌握标准、常见错误、复盘检查
            Draft(prompt: "学习\(label)时，第一步应该做什么？",
                  correct: rule,
                  distractors: others.map { KnowledgeLessonCatalog.ruleText(for: $0) },
                  explanation: "「\(point.ability.title)」类知识点的通用策略：\(rule)",
                  kind: "策略"),
            Draft(prompt: "怎样才算真正掌握了\(label)？",
                  correct: hints.mastery(point.ability),
                  distractors: others.map { hints.mastery($0) },
                  explanation: "掌握的标准是能用出来，而不是只记住答案。\(hints.mastery(point.ability))",
                  kind: "策略"),
            Draft(prompt: "练\(label)时，下面哪项做法最容易出错？",
                  correct: hints.pitfall(point.ability),
                  distractors: others.map { hints.pitfall($0) },
                  explanation: "需要避开的做法：\(hints.pitfall(point.ability))",
                  kind: "易错"),
            Draft(prompt: "做完\(label)的练习后，应该优先检查什么？",
                  correct: hints.check(point.ability),
                  distractors: others.map { hints.check($0) },
                  explanation: "检查动作：\(hints.check(point.ability))",
                  kind: "复盘"),

            // 11—13 迁移与反查
            Draft(prompt: "想继续巩固「\(point.title)」，下面哪项迁移任务最合适？",
                  correct: transferTask,
                  distractors: others.map { hints.transfer($0) },
                  explanation: "迁移的关键是保留结构、替换内容：\(transferTask)",
                  kind: "迁移"),
            Draft(prompt: "「\(sample)」最可能对应下面哪个知识点？",
                  correct: point.title,
                  distractors: peerTitles,
                  explanation: "这句示例练习的正是「\(point.title)」：\(point.summary)",
                  kind: "定位"),
            Draft(prompt: "「\(rule)」这条策略最适合用来学下面哪个知识点？",
                  correct: point.title,
                  distractors: rotate(peerTitles, by: 2),
                  explanation: "这条策略对应「\(point.ability.title)」，本题的落点是「\(point.title)」。",
                  kind: "定位"),

            // 14 学习路径
            Draft(prompt: "要把「\(point.title)」从理解练到会用，下面哪条学习路径最合理？",
                  correct: pathTask,
                  distractors: others.map { hints.badPath($0) },
                  explanation: "先规则、再示例、最后练习与迁移，是「\(point.title)」的推荐路径。",
                  kind: "策略"),

            // 15 错题处理
            Draft(prompt: "「\(point.title)」的题总是做错，下一步最应该做什么？",
                  correct: hints.remedy(point.ability),
                  distractors: others.map { hints.remedy($0) },
                  explanation: "错误的下一步不是继续刷题：\(hints.remedy(point.ability))",
                  kind: "复盘"),

            // 16 练习目标
            Draft(prompt: "这一组「\(point.title)」练习的目标是什么？",
                  correct: "能识别并在句子里正确使用「\(point.title)」",
                  distractors: [
                      "把「\(point.title)」的答案顺序背下来",
                      "只记住「\(point.title)」的中文名字",
                      "把「\(point.title)」的所有例句抄写十遍"
                  ],
                  explanation: "练习目标是能用出来；只记答案顺序或中文名字，遇到新句子仍然会错。",
                  kind: "理解"),

            // 17 示例的作用
            Draft(prompt: "示例「\(sample)」在「\(point.title)」的学习中起什么作用？",
                  correct: "示范「\(point.title)」在实际语境中的用法",
                  distractors: [
                      "提供一个需要逐字背诵的固定答案",
                      "说明「\(point.title)」只在考试里出现",
                      "证明「\(point.title)」没有规律可循"
                  ],
                  explanation: "示例的价值是把规则放进实际语境，便于对照和替换。",
                  kind: "理解"),

            // 18 练习建议
            Draft(prompt: "接下来一周，练\(label)最有效的方式是？",
                  correct: hints.practicePlan(point.ability),
                  distractors: others.map { hints.practicePlan($0) },
                  explanation: "练习方式要匹配能力类型：\(hints.practicePlan(point.ability))",
                  kind: "策略"),

            // 19 考查题型
            Draft(prompt: "\(label)最可能在下面哪种题型里被考到？",
                  correct: hints.module(point.ability),
                  distractors: others.map { hints.module($0) },
                  explanation: "「\(point.ability.title)」主要落在「\(hints.module(point.ability))」里考查。",
                  kind: "归类"),

            // 20 复习节奏
            Draft(prompt: "把「\(point.title)」加入复习，下面哪种节奏最合适？",
                  correct: "当天练习后、第二天和一周后各复习一次",
                  distractors: [
                      "今天连续做十遍，之后不再复习",
                      "只在考试前一晚集中看一次",
                      "每次复习都从头重做全部 20 题"
                  ],
                  explanation: "间隔复习比一次性集中重复更牢固，且复习时优先重做错题。",
                  kind: "复盘")
        ]
    }

    // MARK: - 生成与工具

    private static func make(
        point: JuniorKnowledgePoint,
        index: Int,
        prompt: String,
        correct: String,
        distractors: [String],
        explanation: String,
        kind: String
    ) -> KnowledgePracticeQuestion? {
        let pool = unique(distractors).filter { $0 != correct }
        guard pool.count >= 3 else { return nil }

        let chosen = Array(pool.prefix(3))
        let slot = answerSlot(seed: "\(point.id)|\(index)")
        var options: [String] = []
        var answer = 0
        for position in 0..<4 {
            if position == slot {
                answer = position
                options.append(correct)
            } else {
                options.append(chosen[position < slot ? position : position - 1])
            }
        }
        return KnowledgePracticeQuestion(
            id: "\(point.id)-derived-\(index)",
            knowledgePointID: point.id,
            prompt: prompt,
            options: options,
            answer: answer,
            explanation: explanation,
            kind: kind
        )
    }

    /// 自实现 FNV-1a：Swift 的 `hashValue` 每个进程都不同，不能用来决定选项位置。
    private static func answerSlot(seed: String) -> Int {
        var hash: UInt64 = 14_695_981_039_346_656_037
        for byte in seed.utf8 {
            hash ^= UInt64(byte)
            hash = hash &* 1_099_511_628_211
        }
        return Int(hash % 4)
    }

    private static func unique(_ values: [String]) -> [String] {
        var seen = Set<String>()
        var result: [String] = []
        for value in values where seen.insert(value).inserted {
            result.append(value)
        }
        return result
    }

    /// 循环左移，让同族题目的干扰项顺序不同，避免两道题的选项完全一致。
    private static func rotate(_ values: [String], by offset: Int) -> [String] {
        guard values.count > 1 else { return values }
        let shift = ((offset % values.count) + values.count) % values.count
        return Array(values[shift...] + values[..<shift])
    }
}

/// 按能力类型给出的学习策略提示。全部是通用学习策略，不涉及具体语法判断，避免生成错误规则。
private enum LearningStrategyHints {
    static func alternateAbilities(_ ability: Ability) -> [Ability] {
        Array(Ability.allCases.filter { $0 != ability }.prefix(3))
    }

    static func mastery(_ ability: Ability) -> String {
        switch ability {
        case .vocabulary: return "能在新句子里换掉词块并使用正确，而不是只背中文意思"
        case .wordOrder: return "能自己排出陈述句和疑问句的正确语序"
        case .tense: return "能根据时间标志独立选对时态，而不是靠语感"
        case .reading: return "能回到原文找到依据，并排除只重复词汇的干扰项"
        case .listening: return "能先预测场景，再抓住人物、数字和转折词"
        case .expression: return "能换一个主题写出结构相同的完整句子"
        }
    }

    static func pitfall(_ ability: Ability) -> String {
        switch ability {
        case .vocabulary: return "只背中文释义，不看搭配和词性"
        case .wordOrder: return "按中文语序逐词硬翻"
        case .tense: return "忽略时间标志，只凭语感选时态"
        case .reading: return "只找和原文重复的词，不核对完整句意"
        case .listening: return "只听关键词，不预测场景和设问"
        case .expression: return "堆砌长句，不检查句子骨架是否完整"
        }
    }

    static func check(_ ability: Ability) -> String {
        switch ability {
        case .vocabulary: return "检查搭配和词性是否匹配语境"
        case .wordOrder: return "检查主语、谓语和各成分的语序"
        case .tense: return "检查时间标志和动词形式是否一致"
        case .reading: return "检查答案在原文中是否有明确依据"
        case .listening: return "检查关键数字、地点和转折有没有听清"
        case .expression: return "检查人称、时态、连接词和标点"
        }
    }

    static func transfer(_ ability: Ability) -> String {
        switch ability {
        case .vocabulary: return "把词块换到另一个话题里，再写一句完整的话"
        case .wordOrder: return "把同一句改成否定句和一般疑问句，比较语序变化"
        case .tense: return "把例句的时间改成昨天或明天，再写出对应的句子"
        case .reading: return "从今天的短文里找出两个代词，说出它们分别指代什么"
        case .listening: return "把同一段对话换成购物或问路场景，再说一次"
        case .expression: return "换一个人物和一件物品，重组一句新的表达"
        }
    }

    /// 迁移任务要贴住知识点本身的示例，不同能力类型换的东西不一样，避免出现"给拼读题换主语"这种错配。
    static func transferTask(_ ability: Ability, sample: String) -> String {
        switch ability {
        case .vocabulary: return "把示例「\(sample)」里的词块换到另一个话题，再说一句完整的话。"
        case .wordOrder: return "把示例「\(sample)」改成否定句和一般疑问句，比较语序变化。"
        case .tense: return "把示例「\(sample)」的时间改成昨天或明天，再写出对应的句子。"
        case .reading: return "仿照示例「\(sample)」的做法，从今天读到的短文里找一处依据并说出结论。"
        case .listening: return "把示例「\(sample)」遮住，只听不看地辨认一次，写下听到的内容再核对。"
        case .expression: return "仿照示例「\(sample)」换一个人物和一件物品，重组一句新的表达。"
        }
    }

    static func remedy(_ ability: Ability) -> String {
        switch ability {
        case .vocabulary: return "回到词块和例句，把搭配重新读一遍再重做题"
        case .wordOrder: return "先划出主语和谓语，再重排语序后重做题"
        case .tense: return "先圈出时间标志，写出判断依据再重做题"
        case .reading: return "回到原文划出依据句，标出干扰项错在哪里"
        case .listening: return "先预测场景和可能答案，再重听一次"
        case .expression: return "先写句子骨架，再补细节和连接词"
        }
    }

    static func practicePlan(_ ability: Ability) -> String {
        switch ability {
        case .vocabulary: return "每天记三个词块，并分别把它们用到一句话里"
        case .wordOrder: return "每天把两句陈述句改成否定句和一般疑问句"
        case .tense: return "每天用同一个动词写三个不同时间的句子"
        case .reading: return "每天读一段短文，划出一处代词指代和一处同义替换"
        case .listening: return "每天听一段对话，先写预测再核对听到的信息"
        case .expression: return "每天按对象、内容、目的三步写一小段表达"
        }
    }

    static func module(_ ability: Ability) -> String {
        switch ability {
        case .vocabulary: return "词汇与词块选择"
        case .wordOrder: return "语法填空与句型转换"
        case .tense: return "时态辨析与语法填空"
        case .reading: return "阅读理解与完形填空"
        case .listening: return "听力场景与对话理解"
        case .expression: return "写作与应用文表达"
        }
    }

    static func badPath(_ ability: Ability) -> String {
        switch ability {
        case .vocabulary: return "先背十个生词，再回来读规则摘要"
        case .wordOrder: return "先把例句全抄一遍，再想语序规则"
        case .tense: return "先做二十道题，再回头看时间标志"
        case .reading: return "先看选项，再决定要不要读原文"
        case .listening: return "先看答案文本，再听录音"
        case .expression: return "先追求句子长度，再考虑骨架是否完整"
        }
    }
}
