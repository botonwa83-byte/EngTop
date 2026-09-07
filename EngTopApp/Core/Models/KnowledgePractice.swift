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

enum KnowledgePracticeFactory {
    static func questions(for point: JuniorKnowledgePoint) -> [KnowledgePracticeQuestion] {
        let curated = CuratedKnowledgeQuestions.forPoint(point.id)
        let guaranteed = curated.isEmpty ? [CuratedKnowledgeQuestions.coverageQuestion(for: point)] : []
        let peers = JuniorKnowledgeCatalog.all.filter { $0.stage == point.stage && $0.id != point.id }
        let distractors = Array(peers.prefix(3))
        let example = point.examples[0]
        let generated = [
            KnowledgePracticeQuestion(id: point.id + "-example", knowledgePointID: point.id, prompt: "哪一项是“\(point.title)”的正确示例？", options: [example] + distractors.compactMap(\.examples.first), answer: 0, explanation: point.summary, kind: "识别"),
            KnowledgePracticeQuestion(id: point.id + "-meaning", knowledgePointID: point.id, prompt: "“\(point.title)”主要帮助你掌握什么？", options: [point.summary] + distractors.map(\.summary), answer: 0, explanation: "记住核心规则：\(point.summary)", kind: "应用"),
            KnowledgePracticeQuestion(id: point.id + "-ability", knowledgePointID: point.id, prompt: "这个知识点主要训练哪项英语能力？", options: Ability.allCases.map(\.title), answer: Ability.allCases.firstIndex(of: point.ability) ?? 0, explanation: "它属于“\(point.ability.title)”能力。", kind: "迁移")
        ]
        return Array((curated + guaranteed + generated).prefix(3))
    }
}
