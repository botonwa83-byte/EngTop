import Foundation

struct LearningMissionStat: Codable, Equatable {
    var attempts: Int = 0
    var correct: Int = 0
    var transfers: Int = 0
    var reflections: Int = 0
}

enum LearningProgressEngine {
    static func score(for stats: LearningMissionStat) -> Int {
        guard stats.attempts > 0 else { return 0 }
        let attempts = Double(stats.attempts)
        let accuracy = Double(stats.correct) / attempts
        let transferRate = min(1, Double(stats.transfers) / attempts)
        let reflectionRate = min(1, Double(stats.reflections) / attempts)
        return Int((accuracy * 70 + transferRate * 20 + reflectionRate * 10).rounded())
    }
}

/// 学习能力训练的离线进度，独立于题库统计，便于以后增加项目任务和成长报告。
final class LearningProgressStore: ObservableObject {
    static let shared = LearningProgressStore()

    @Published private(set) var stats: [String: LearningMissionStat] = [:]

    private let defaults: UserDefaults
    private let key = "learning.progress.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    func stat(for missionID: String) -> LearningMissionStat {
        stats[missionID] ?? LearningMissionStat()
    }

    func record(
        _ mission: LearningMission,
        correct: Bool,
        transferCompleted: Bool,
        reflectionCompleted: Bool
    ) {
        var value = stat(for: mission.id)
        value.attempts += 1
        if correct { value.correct += 1 }
        if transferCompleted { value.transfers += 1 }
        if reflectionCompleted { value.reflections += 1 }
        stats[mission.id] = value
        save()
    }

    func score(for ability: LearningAbility) -> Int {
        let missions = LearningMissionCatalog.all.filter { $0.ability == ability }
        guard !missions.isEmpty else { return 0 }
        let values = missions.map { LearningProgressEngine.score(for: stat(for: $0.id)) }
        return Int((Double(values.reduce(0, +)) / Double(values.count)).rounded())
    }

    var completedMissionCount: Int {
        stats.values.filter { $0.attempts > 0 }.count
    }

    var totalAttempts: Int {
        stats.values.reduce(0) { $0 + $1.attempts }
    }

    var recommendedMission: LearningMission {
        LearningMissionCatalog.all.sorted { lhs, rhs in
            let left = stat(for: lhs.id)
            let right = stat(for: rhs.id)
            let leftUnseen = left.attempts == 0
            let rightUnseen = right.attempts == 0
            if leftUnseen != rightUnseen { return leftUnseen }

            let leftScore = LearningProgressEngine.score(for: left)
            let rightScore = LearningProgressEngine.score(for: right)
            if leftScore != rightScore { return leftScore < rightScore }
            return lhs.id < rhs.id
        }.first!
    }

    func reset() {
        stats = [:]
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(stats) else { return }
        defaults.set(data, forKey: key)
    }

    private func load() {
        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([String: LearningMissionStat].self, from: data) else {
            return
        }
        stats = decoded
    }
}
