import Foundation

final class KnowledgeProgressStore: ObservableObject {
    static let shared = KnowledgeProgressStore()
    @Published private(set) var mastered: Set<String> = []
    private let key = "knowledge.mastered.v1"
    private init() { mastered = Set(UserDefaults.standard.stringArray(forKey: key) ?? []) }
    func toggle(_ id: String) {
        if mastered.contains(id) { mastered.remove(id) } else { mastered.insert(id) }
        UserDefaults.standard.set(Array(mastered), forKey: key)
    }
    func isMastered(_ id: String) -> Bool { mastered.contains(id) }
}
