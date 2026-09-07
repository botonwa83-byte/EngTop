import Foundation

struct KnowledgeLesson {
    let pointID: String
    let rule: String
    let example: String
    let trap: String
    let transfer: String
}

enum KnowledgeLessonCatalog {
    static func lesson(for point: JuniorKnowledgePoint) -> KnowledgeLesson {
        let example = point.examples.first ?? "Practice this pattern."
        let rule: String
        switch point.ability {
        case .vocabulary: rule = "先确认词义和词性，再把它放进完整词块中记忆。"
        case .wordOrder: rule = "先找主语和谓语，再补宾语、时间、地点等成分。"
        case .tense: rule = "先找时间标志，再判断动作发生的时间和持续状态。"
        case .reading: rule = "先圈出题干关键词，再回到原文定位并核对上下文。"
        case .listening: rule = "先预测场景和可能答案，听时抓人物、数字、地点和转折。"
        case .expression: rule = "先搭句子骨架，再替换人物、动作、对象和连接词。"
        }
        return KnowledgeLesson(pointID: point.id, rule: rule, example: example, trap: "不要只背中文意思：检查词序、动词形式和语境是否匹配。", transfer: "把示例中的主语或时间换掉，再说出一个新句子。")
    }

    static func all() -> [KnowledgeLesson] { JuniorKnowledgeCatalog.all.map(lesson) }
}
