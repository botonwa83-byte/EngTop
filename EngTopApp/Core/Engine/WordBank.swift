import Foundation

/// 课标词汇库条目：小学+初中重点词汇精选（500词），每词配音标、释义与例句。
/// 数据来源：人教版小学教材词汇（3-6年级8册，按跨册复现率精选200）+ 初中词汇书
/// （按"延续到高考3500 + 有例句"精选300），去重合并，覆盖课标小学505/初中1600的核心子集。
struct WordBankEntry: Identifiable, Codable {
    let word: String
    let phonetic: String   // 英式音标
    let meaning: String    // 中文释义（最多3个义项，"词性. 释义"拼接）
    let stage: Int         // 1 小学 2 初中
    let example: String        // 英文例句（个别词条缺失为空串）
    let exampleMeaning: String // 例句中文翻译

    var id: String { word }
    var stageTitle: String { ["", "小学", "初中"][stage] }
    var hasExample: Bool { !example.isEmpty }
}

/// 课标词汇库：词表存 Bundle 资源（WordBank.json，精选500词约100KB），首次访问一次性载入。
/// 与 SpeechPlayer 打通：点词条读单词、点例句旁喇叭读例句；与 Atlas 图鉴打通：作为素材库的一个板块入口。
enum WordBank {
    static let all: [WordBankEntry] = load()

    static var countsByStage: (primary: Int, junior: Int) {
        let c = Dictionary(grouping: all, by: \.stage).mapValues(\.count)
        return (c[1] ?? 0, c[2] ?? 0)
    }

    /// 按学段与搜索词过滤（匹配拼写或释义），结果按字母序。
    static func entries(stage: Int?, query: String) -> [WordBankEntry] {
        let keyword = query.trimmingCharacters(in: .whitespaces).lowercased()
        return all.filter { e in
            guard stage == nil || e.stage == stage else { return false }
            guard !keyword.isEmpty else { return true }
            return e.word.lowercased().contains(keyword) || e.meaning.contains(keyword)
        }
    }

    /// 首字母分组索引：供 List 分节展示，非字母开头归入 "#"。
    static func letterIndex(_ entries: [WordBankEntry]) -> [(letter: String, items: [WordBankEntry])] {
        let groups = Dictionary(grouping: entries) { e -> String in
            let f = e.word.lowercased().first.map(String.init) ?? "#"
            return ("a"..."z").contains(f) ? f.uppercased() : "#"
        }
        return groups.keys.sorted().map { ($0, groups[$0]!.sorted { $0.word.lowercased() < $1.word.lowercased() }) }
    }

    private static func load() -> [WordBankEntry] {
        guard let url = Bundle.main.url(forResource: "WordBank", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let entries = try? JSONDecoder().decode([WordBankEntry].self, from: data)
        else { return [] }
        return entries
    }
}
