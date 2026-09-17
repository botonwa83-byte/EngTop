import Foundation

/// 知识点进度：区分「练过」与「已掌握」。
/// 练过 = 在这个知识点上作答过（自动记录）；已掌握 = 学生自己确认（手动标记）。
final class KnowledgeProgressStore: ObservableObject {
    static let shared = KnowledgeProgressStore()

    @Published private(set) var mastered: Set<String> = []
    @Published private(set) var practiced: Set<String> = []

    private let key = "knowledge.mastered.v1"
    private let practicedKey = "knowledge.practiced.v1"

    private init() {
        mastered = Set(UserDefaults.standard.stringArray(forKey: key) ?? [])
        practiced = Set(UserDefaults.standard.stringArray(forKey: practicedKey) ?? [])
    }

    func toggle(_ id: String) {
        if mastered.contains(id) { mastered.remove(id) } else { mastered.insert(id) }
        UserDefaults.standard.set(Array(mastered), forKey: key)
    }

    func isMastered(_ id: String) -> Bool { mastered.contains(id) }

    /// 练习过该知识点（作答即记录），用于在图谱里区分「练过」与「没碰过」。
    func markPracticed(_ id: String) {
        guard practiced.insert(id).inserted else { return }
        UserDefaults.standard.set(Array(practiced), forKey: practicedKey)
    }

    func isPracticed(_ id: String) -> Bool { practiced.contains(id) }

    var practicedCount: Int { practiced.count }

    /// 图谱总进度 = 练过或已掌握。
    var touchedCount: Int { mastered.union(practiced).count }
}
