import Foundation

struct KnowledgeLesson {
    let pointID: String
    let rule: String
    let example: String
    let trap: String
    let transfer: String
}

enum KnowledgeLessonCatalog {
    /// 按能力类型给出的“第一步策略”。专项练习的派生题也会复用这段文案，因此单独抽出。
    static func ruleText(for ability: Ability) -> String {
        switch ability {
        case .vocabulary: return "先确认词义和词性，再把它放进完整词块中记忆。"
        case .wordOrder: return "先找主语和谓语，再补宾语、时间、地点等成分。"
        case .tense: return "先找时间标志，再判断动作发生的时间和持续状态。"
        case .reading: return "先圈出题干关键词，再回到原文定位并核对上下文。"
        case .listening: return "先预测场景和可能答案，听时抓人物、数字、地点和转折。"
        case .expression: return "先搭句子骨架，再替换人物、动作、对象和连接词。"
        }
    }

    static func lesson(for point: JuniorKnowledgePoint) -> KnowledgeLesson {
        let example = point.examples.first ?? "Practice this pattern."
        return KnowledgeLesson(pointID: point.id, rule: ruleText(for: point.ability), example: example, trap: "不要只背中文意思：检查词序、动词形式和语境是否匹配。", transfer: "把示例中的主语或时间换掉，再说出一个新句子。")
    }

    static func all() -> [KnowledgeLesson] { JuniorKnowledgeCatalog.all.map(lesson) }
}
