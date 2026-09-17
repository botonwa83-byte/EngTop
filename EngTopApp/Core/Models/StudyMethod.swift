import SwiftUI

/// 英语学科的学习方法。
///
/// 这套方法不是「学习技巧清单」，而是**可以迁移到任何一道英语题上的固定动作**：
/// 每个方法都是 4 步，每一步都能落到具体句子、具体词或具体依据上，
/// 学生练完一个知识点后，能在下一个新句子上重复同样的四步。
///
/// 与现有体系的关系：
/// - 每个知识点由 `StudyMethodCatalog.primary(for:)` 指派一个主方法，知识点详情页会展示该方法；
/// - 第三轮注入题（`KnowledgeQuestionInjection3`）为每个知识点配一道方法题，把方法落到真实语言点；
/// - 方法卡可以加入 SM-2 复习（复习 id 前缀 `m:`），与错题走同一套遗忘曲线。
enum StudyMethod: String, CaseIterable, Identifiable, Codable {
    case timeMarker     // 时间标志法（时态 / 语态）
    case chunk          // 语块记忆法（词汇）
    case backbone       // 主干手术法（句子语序）
    case evidence       // 原文取证法（阅读）
    case scene          // 场景预测法（听力）
    case skeleton       // 骨架替换法（表达 / 写作）
    case contrast       // 对比归类法（易混辨析）
    case spacing        // 间隔复盘法（复习与纠错）

    var id: String { rawValue }

    var title: String {
        switch self {
        case .timeMarker: return "时间标志法"
        case .chunk: return "语块记忆法"
        case .backbone: return "主干手术法"
        case .evidence: return "原文取证法"
        case .scene: return "场景预测法"
        case .skeleton: return "骨架替换法"
        case .contrast: return "对比归类法"
        case .spacing: return "间隔复盘法"
        }
    }

    /// 一句话说清「什么时候用它」。
    var oneLiner: String {
        switch self {
        case .timeMarker: return "遇到动词填空，先找时间标志，再决定动词形式。"
        case .chunk: return "记单词记「词块」：搭配 + 词性 + 一个自己的例句。"
        case .backbone: return "句子看不懂，先去掉枝叶，只看主谓（宾）。"
        case .evidence: return "每个答案都要回原文划出依据句，划不出就不选。"
        case .scene: return "听力先猜场景和问题，听时只抓关键信息。"
        case .skeleton: return "写作先搭骨架，再替换人物、动作、对象。"
        case .contrast: return "易混项列成表格比「不同条件」，而不是背两个中文意思。"
        case .spacing: return "错题按「当天、次日、一周、一月」四档复习，而不是一次刷十遍。"
        }
    }

    /// 四步固定动作。每一步都要求学生动手（圈、划、写、比），不只是「看懂」。
    var steps: [String] {
        switch self {
        case .timeMarker:
            return [
                "圈出时间标志：every day / now / yesterday / already / since / by the end of…",
                "把标志翻成时间：经常→现在时，此刻→进行时，过去→过去时，已经或持续→完成时",
                "用主语核对助动词：am/is/are、do/does、have/has，注意单复数",
                "写下动词形式后，把整句读一遍，确认时间与形式对得上"
            ]
        case .chunk:
            return [
                "先写词性和核心义：n. 包 / v. 打包 / adj. 拥挤的",
                "记一个固定搭配：look forward to、in order to、take care of，连介词一起记",
                "配一个自己能用的例句，把人物和场景换成自己的生活",
                "换话题再用一次：把同一个词块写进另一个主题的句子里"
            ]
        case .backbone:
            return [
                "先找谓语动词——一个句子只有一个主要谓语，先把时态和语态定下来",
                "往前找主语，确认主谓一致；be 动词也算谓语",
                "判断句型：主谓 / 主系表 / 主谓宾 / 主谓双宾 / 主谓宾补",
                "把时间、地点、原因、条件等修饰成分按英语习惯放回句尾或句首"
            ]
        case .evidence:
            return [
                "读题干划关键词：人名、数字、动词、否定词",
                "回原文定位到那一句，用笔划线，不凭印象作答",
                "把选项与依据句做同义比对，重点看范围和程度（all / must / only 最危险）",
                "排除「只在词汇上重复、但意思越界」的选项，并说出它错在哪"
            ]
        case .scene:
            return [
                "看题干和选项猜场景：校园 / 购物 / 问路 / 电话 / 出行 / 计划",
                "预判可能答案：时间、价格、地点、做的事、说话人态度",
                "听时抓三类词：数字、转折（but / however）、语气（I'd love to, but…）",
                "用速记符号记关键词，不追求每个词都听清，第二遍只补漏掉的那一处"
            ]
        case .skeleton:
            return [
                "定骨架：谁 + 做什么 + 对谁 + 为什么（主语 + 谓语 + 宾语 + 目的）",
                "定人称和时态，写出动词的正确形式",
                "替换内容词：换人物、换物品、换地点，骨架不动",
                "加连接词和细节（because / so / however），最后检查标点和大小写"
            ]
        case .contrast:
            return [
                "找出这一组易混项：some/any、few/little、who/which、too/enough…",
                "列对比条件：肯定还是否定、可数还是不可数、指人还是指物、范围大小",
                "每个条件写一组「只差一个词」的最小对比例句",
                "用新句子自测：先判条件，再选形式；判不出条件就说明表格还没画完"
            ]
        case .spacing:
            return [
                "当天：把错题按错因归档（时间标志没看 / 搭配记错 / 语序颠倒 / 范围越界）",
                "次日：只重做错题，先自己想，再看答案",
                "一周：换一个新句子自测同一个知识点，不复述原题",
                "一月：看错因分布，找出最常错的一类集中突破"
            ]
        }
    }

    /// 示范句（英语），用于方法卡上的示例。
    var exampleEn: String {
        switch self {
        case .timeMarker: return "I have lived here since 2020."
        case .chunk: return "I'm looking forward to the summer holiday."
        case .backbone: return "The boy who won the game is my friend."
        case .evidence: return "The writer suggests that students should start early."
        case .scene: return "Could you tell me how to get to the library?"
        case .skeleton: return "We should save water because it is important."
        case .contrast: return "Do you have any milk? — Yes, I have some."
        case .spacing: return "I chose “went”, but every Sunday needs “goes”."
        }
    }

    /// 示例的讲解：说明方法怎么用在这句话上。
    var exampleHint: String {
        switch self {
        case .timeMarker: return "since 2020 是完成时标志 → have + 过去分词 lived。"
        case .chunk: return "记 look forward to + 名词或 doing，别单独背 forward。"
        case .backbone: return "去掉 who won the game，主干是 The boy is my friend。"
        case .evidence: return "答案若写成 all students must，范围比原文更绝对，可以排除。"
        case .scene: return "听到 how to get to… 就锁定「问路」，重点记方向词和路口。"
        case .skeleton: return "骨架是 We + should do + 宾语，把 water 换成 paper 就是新句子。"
        case .contrast: return "同一个语境只换 some / any：否定和疑问用 any，肯定用 some。"
        case .spacing: return "错因归为「忽略时间标志」，次日重做时先圈 every Sunday。"
        }
    }

    /// 最常见的使用误区。
    var pitfall: String {
        switch self {
        case .timeMarker: return "不看时间标志，凭语感选时态，选完也不知道为什么。"
        case .chunk: return "只背中文释义，不看搭配和词性，写句子时用不出来。"
        case .backbone: return "按中文语序逐词硬翻，句子越写越长却没有谓语。"
        case .evidence: return "只找和原文重复的词，不核对完整句意和范围。"
        case .scene: return "只听关键词，不预测场景和设问，听完不知道问了什么。"
        case .skeleton: return "先追求句子长度，再考虑骨架是否完整，结果主语谓语都不齐。"
        case .contrast: return "把两个易混词都背成同一个中文意思，分不清使用条件。"
        case .spacing: return "今天连续做十遍，之后不再复习；或每次复习都从头重做全部题。"
        }
    }

    /// 自检问题：学生能自己回答，才算真正掌握这个方法。
    var selfCheck: String {
        switch self {
        case .timeMarker: return "我能说出这道题的时间标志词是哪个吗？"
        case .chunk: return "我能用这个词块写出一句和课本不一样的话吗？"
        case .backbone: return "我把修饰成分去掉后，剩下的部分能独立成句吗？"
        case .evidence: return "我的答案能在原文划出依据句吗？"
        case .scene: return "听之前我能说出两个可能的答案吗？"
        case .skeleton: return "我写的句子里主语和谓语齐全吗？"
        case .contrast: return "我能说出这两个词的分界条件吗？"
        case .spacing: return "我能用一句话说出这次错在哪一类原因吗？"
        }
    }

    /// 这个方法与哪些英语能力对应。
    var abilities: [Ability] {
        switch self {
        case .timeMarker: return [.tense]
        case .chunk: return [.vocabulary]
        case .backbone: return [.wordOrder]
        case .evidence: return [.reading]
        case .scene: return [.listening]
        case .skeleton: return [.expression]
        case .contrast: return [.vocabulary, .wordOrder, .reading]
        case .spacing: return Ability.allCases
        }
    }

    var icon: String {
        switch self {
        case .timeMarker: return "clock.badge.checkmark"
        case .chunk: return "square.stack.3d.up"
        case .backbone: return "figure.walk.arrival"
        case .evidence: return "text.magnifyingglass"
        case .scene: return "ear.badge.waveform"
        case .skeleton: return "square.on.square.dashed"
        case .contrast: return "arrow.left.arrow.right"
        case .spacing: return "calendar.badge.clock"
        }
    }

    var accent: Color {
        switch self {
        case .timeMarker: return .apexEmerald
        case .chunk: return .apexLava
        case .backbone: return .apexStarBlue
        case .evidence: return .apexMystery
        case .scene: return .apexGold
        case .skeleton: return .apexDanger
        case .contrast: return .apexStarBlue
        case .spacing: return .apexEmerald
        }
    }

    /// 所属能力名（用于列表标签）。`contrast` / `spacing` 是跨能力的通用方法。
    var abilityLabel: String {
        switch self {
        case .contrast: return "跨能力 · 辨析"
        case .spacing: return "跨能力 · 复习"
        default: return abilities.first?.title ?? "通用"
        }
    }
}

/// 知识点 → 方法的指派表。
///
/// 默认按能力指派；「易混辨析」型知识点（some/any、few/little、who/which 等）
/// 统一指派给对比归类法，因为它们的学习动作本来就是「比不同条件」，用错方法会越练越乱。
enum StudyMethodCatalog {
    static var all: [StudyMethod] { StudyMethod.allCases }

    /// 用「对比归类法」的知识点：都是成对成组的易混项，学习动作本来就是“比不同条件”。
    private static let contrastPoints: Set<String> = [
        // 小学
        "p-have", "p-nouns", "p-numbers", "p-plurals", "p-some-any", "p-time",
        "p-articles", "p-demonstratives", "p-prepositions", "p-wh",
        // 初一
        "j1-count", "j1-quantifiers", "j1-prep", "j1-prepositions", "j1-indefinite", "j1-whose",
        "j1-possessive", "j1-possessive-pronoun", "j1-pronouns", "j1-reflexive",
        "j1-frequency", "j1-frequency-count", "j1-frequency-question", "j1-connectors",
        "j1-spelling-rules", "j1-exclamatory",
        // 初二
        "j2-adjectives", "j2-comparative", "j2-superlative", "j2-too-enough", "j2-exclamation",
        "j2-preposition-time", "j2-articles", "j2-both-either", "j2-question-tags",
        "j2-question-forms", "j2-voice", "j2-modal", "j2-verb-forms", "j2-cause", "j2-used-to",
        // 初三
        "j3-relative-choice", "j3-tenses-review", "j3-conjunctions", "j3-nonfinite",
        "j3-word-building", "j3-phrasal", "j3-passive-tenses", "j3-conditional-review",
        "j3-passive", "j3-modal-passive", "j3-inversion", "j3-ellipsis", "j3-sequence",
        "j3-cloze", "j3-tag", "j3-writing-cohesion"
    ]

    /// 用「主干手术法」的知识点：难点在句子结构本身（从句、语序、句型），而不是在找信息。
    private static let backbonePoints: Set<String> = [
        "j2-conditional", "j2-relative-basic", "j2-object",
        "j3-adverbial", "j3-relative", "j3-indirect", "j3-object-clause",
        "j3-object-order", "j3-reported", "j3-subjunctive"
    ]

    /// 用「原文取证法」的知识点：依据在上下文里找，而不是在句子里搭结构。
    private static let evidencePoints: Set<String> = [
        "j3-context"
    ]

    /// 该知识点推荐的主方法。
    static func primary(for point: JuniorKnowledgePoint) -> StudyMethod {
        if contrastPoints.contains(point.id) { return .contrast }
        if backbonePoints.contains(point.id) { return .backbone }
        if evidencePoints.contains(point.id) { return .evidence }
        switch point.ability {
        case .tense: return .timeMarker
        case .vocabulary: return .chunk
        case .wordOrder: return .backbone
        case .reading: return .evidence
        case .listening: return .scene
        case .expression: return .skeleton
        }
    }

    /// 该知识点的配套方法：主方法 + 通用的间隔复盘法（每次都要复习）。
    static func methods(for point: JuniorKnowledgePoint) -> [StudyMethod] {
        let main = primary(for: point)
        return main == .spacing ? [main] : [main, .spacing]
    }

    /// 覆盖某能力的全部方法。
    static func methods(for ability: Ability) -> [StudyMethod] {
        all.filter { $0.abilities.contains(ability) }
    }

    /// 使用该方法的全部知识点，按学段与 id 排序。
    static func points(of method: StudyMethod) -> [JuniorKnowledgePoint] {
        JuniorKnowledgeCatalog.all
            .filter { primary(for: $0) == method }
            .sorted { lhs, rhs in
                let order: [StudyStage] = [.primary, .juniorOne, .juniorTwo, .juniorThree]
                let li = order.firstIndex(of: lhs.stage) ?? 0
                let ri = order.firstIndex(of: rhs.stage) ?? 0
                if li != ri { return li < ri }
                return lhs.id < rhs.id
            }
    }

    /// 检索：方法名、一句话、四步、误区任一命中。
    static func search(_ query: String) -> [StudyMethod] {
        let keyword = query.trimmingCharacters(in: .whitespaces).lowercased()
        guard !keyword.isEmpty else { return all }
        return all.filter { method in
            method.title.lowercased().contains(keyword)
                || method.oneLiner.lowercased().contains(keyword)
                || method.pitfall.lowercased().contains(keyword)
                || method.selfCheck.lowercased().contains(keyword)
                || method.abilityLabel.lowercased().contains(keyword)
                || method.steps.contains { $0.lowercased().contains(keyword) }
        }
    }

    /// 判断一道题是不是「方法题」：第三轮注入包（`inj3-` 前缀）专产方法题。
    /// 不能用 `kind` 判断——派生题里也有「迁移」这类同名标签。
    static func isMethodQuestion(_ question: KnowledgePracticeQuestion) -> Bool {
        question.id.hasPrefix("inj3-")
    }
}

/// 方法练习进度：记录每个方法被练过多少次、答对多少，作为「方法掌握度」。
/// 数据来自知识点练习里的方法题（kind 为「方法」/「诊断」/「迁移」）。
final class StudyMethodStore: ObservableObject {
    static let shared = StudyMethodStore()

    struct Stat: Codable {
        var attempts: Int = 0
        var correct: Int = 0
    }

    @Published private(set) var stats: [String: Stat] = [:]

    private let key = "studymethod.progress.v1"

    private init() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([String: Stat].self, from: data) else { return }
        stats = decoded
    }

    func stat(for method: StudyMethod) -> Stat { stats[method.rawValue] ?? Stat() }

    func record(_ method: StudyMethod, correct: Bool) {
        var value = stat(for: method)
        value.attempts += 1
        if correct { value.correct += 1 }
        stats[method.rawValue] = value
        save()
    }

    /// 方法掌握度 0—100：正确率为主，练习量给少量加成（练得多但全错不给分）。
    func score(for method: StudyMethod) -> Int {
        let s = stat(for: method)
        guard s.attempts > 0 else { return 0 }
        let accuracy = Double(s.correct) / Double(s.attempts)
        let volume = min(1.0, Double(s.attempts) / 5.0)
        return Int((accuracy * 85 + volume * 15).rounded())
    }

    var practicedMethodCount: Int {
        stats.values.filter { $0.attempts > 0 }.count
    }

    /// 推荐下一个要练的方法：先挑没练过的，再挑掌握度最低的。
    var recommendedMethod: StudyMethod {
        StudyMethod.allCases.sorted { lhs, rhs in
            let lhsUnseen = stat(for: lhs).attempts == 0
            let rhsUnseen = stat(for: rhs).attempts == 0
            if lhsUnseen != rhsUnseen { return lhsUnseen }
            let ls = score(for: lhs), rs = score(for: rhs)
            if ls != rs { return ls < rs }
            return lhs.rawValue < rhs.rawValue
        }.first ?? .timeMarker
    }

    var totalAttempts: Int { stats.values.reduce(0) { $0 + $1.attempts } }

    func reset() {
        stats = [:]
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
