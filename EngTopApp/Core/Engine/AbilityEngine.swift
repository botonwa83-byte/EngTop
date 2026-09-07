import Foundation

enum Ability: String, CaseIterable, Identifiable, Codable {
    case vocabulary, wordOrder, tense, reading, listening, expression
    var id: String { rawValue }
    var title: String {
        switch self {
        case .vocabulary: return "词汇识别"
        case .wordOrder: return "句子重力"
        case .tense: return "时间变身"
        case .reading: return "线索追踪"
        case .listening: return "声音雷达"
        case .expression: return "表达装配"
        }
    }
}

enum ChallengeResult { case correct, wrong }

struct AbilityProfile: Codable {
    private(set) var xp: Int = 0
    private(set) var combo: Int = 0
    private var scores: [Ability: Int] = [:]

    mutating func apply(result: ChallengeResult, ability: Ability) {
        switch result {
        case .correct:
            xp += 12
            combo += 1
            scores[ability] = min(100, score(for: ability) + 6)
        case .wrong:
            combo = 0
            scores[ability] = max(0, score(for: ability) - 1)
        }
    }

    func score(for ability: Ability) -> Int { scores[ability] ?? 0 }
    var level: Int { max(1, xp / 60 + 1) }
}
