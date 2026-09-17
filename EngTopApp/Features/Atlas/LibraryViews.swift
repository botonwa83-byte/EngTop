import SwiftUI

// MARK: - 词汇专项库（独立子页）
// 素材库首页只放入口与统计，全量词条在这里滚动，避免首页被上千条列表撑爆。

/// 词汇专项：拼写 + 搭配/僻义小测，按"高频且最弱"排序。
struct VocabLibraryView: View {
    @ObservedObject private var store = VocabStore.shared
    @State private var query = ""

    /// 排序后按关键词过滤，保持"最弱优先"的相对顺序。
    private var words: [(word: VocabWord, score: Double)] {
        let ranked = store.priorityList(VocabData.all)
        let keyword = query.trimmingCharacters(in: .whitespaces).lowercased()
        guard !keyword.isEmpty else { return ranked }
        return ranked.filter {
            $0.word.headword.lowercased().contains(keyword) || $0.word.meaning.contains(keyword)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                InfoBanner(
                    title: "词汇狙击",
                    systemImage: "character.book.closed",
                    accent: .apexLava,
                    detail: "拼写 / 搭配辨析 / 熟词僻义三种练法；高频且你最弱的词永远排最前。")
                if words.isEmpty {
                    ContentUnavailableViewCompat(
                        title: "没有匹配的词",
                        systemImage: "magnifyingglass",
                        description: "试试更短的拼写，或换成中文关键词。")
                        .frame(height: 240)
                } else {
                    ForEach(Array(words.enumerated()), id: \.element.word.id) { idx, entry in
                        NavigationLink { VocabDetailView(word: entry.word) } label: {
                            VocabRow(rank: idx + 1, word: entry.word, mastered: store.isMastered(entry.word.id))
                        }.buttonStyle(.plain)
                    }
                }
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("词汇专项")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query, prompt: "搜单词或释义")
    }
}

/// 词汇行：素材库与词汇专项共用的展示单元。
struct VocabRow: View {
    let rank: Int
    let word: VocabWord
    var mastered: Bool = false

    var body: some View {
        HStack(spacing: Spacing.md) {
            Text("\(rank)").font(AppFont.bigStat(20)).foregroundColor(.apexLava).frame(width: 26)
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(word.headword).font(AppFont.cardTitle)
                    TagChip(text: word.category.title,
                            color: word.category == .collocation ? .apexStarBlue : .apexMystery)
                }
                Text(word.meaning).font(AppFont.caption).foregroundColor(.secondary).lineLimit(1)
            }
            Spacer()
            if mastered { Image(systemName: "checkmark.seal.fill").foregroundColor(.apexEmerald) }
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .cardSurface(padding: Spacing.md)
        .opacity(mastered ? 0.6 : 1)
    }
}

// MARK: - 语法知识点库（独立子页）

/// 小学 · 初中知识图谱：按学段/能力筛选 + 搜索，点进知识点详情。
struct KnowledgeLibraryView: View {
    @State private var selectedStage: StudyStage?
    @State private var selectedAbility: Ability?
    @State private var query = ""

    private var points: [JuniorKnowledgePoint] {
        JuniorKnowledgeCatalog.points(stage: selectedStage, ability: selectedAbility, query: query)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                filterBar
                if points.isEmpty {
                    ContentUnavailableViewCompat(
                        title: "没有匹配的知识点",
                        systemImage: "magnifyingglass",
                        description: "换个关键词，或清空筛选条件再试。")
                        .frame(height: 260)
                } else {
                    ForEach(StudyStage.allCases) { stage in
                        let group = points.filter { $0.stage == stage }
                        if !group.isEmpty {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                HStack {
                                    Text(stage.title).font(AppFont.cardTitle)
                                    Spacer()
                                    Text("\(group.count) 个").font(AppFont.caption).foregroundColor(.secondary)
                                }
                                ForEach(group) { point in
                                    NavigationLink { KnowledgeDetailView(point: point) } label: {
                                        KnowledgeRow(point: point)
                                    }.buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("语法知识点")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query, prompt: "搜知识点或例句")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { filterMenu }
        }
    }

    private var filterBar: some View {
        HStack(spacing: Spacing.sm) {
            if let s = selectedStage { chip(s.title) { selectedStage = nil } }
            if let a = selectedAbility { chip(a.title) { selectedAbility = nil } }
            Spacer()
            Text("共 \(points.count) 个").font(AppFont.caption).foregroundColor(.secondary)
        }
    }

    private func chip(_ title: String, onRemove: @escaping () -> Void) -> some View {
        Button(action: onRemove) {
            HStack(spacing: 4) {
                Text(title).font(AppFont.chip)
                Image(systemName: "xmark.circle.fill").font(.system(size: 11))
            }
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(Color.apexStarBlue.opacity(0.14))
            .foregroundColor(.apexStarBlue)
            .clipShape(Capsule())
        }.buttonStyle(.plain)
    }

    private var filterMenu: some View {
        Menu {
            Button("全部学段") { selectedStage = nil }
            ForEach(StudyStage.allCases) { stage in
                Button(stage.title) { selectedStage = stage }
            }
            Divider()
            Button("全部能力") { selectedAbility = nil }
            ForEach(Ability.allCases) { ability in
                Button(ability.title) { selectedAbility = ability }
            }
        } label: { Image(systemName: "line.3.horizontal.decrease.circle") }
    }
}

/// 知识点行：素材库与知识点库共用的展示单元。
/// 会带上该知识点绑定的学习方法，以及「已练 / 已掌握」的状态。
struct KnowledgeRow: View {
    let point: JuniorKnowledgePoint
    @ObservedObject private var progress = KnowledgeProgressStore.shared

    private var method: StudyMethod { StudyMethodCatalog.primary(for: point) }

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Image(systemName: "circle.fill").font(.system(size: 7)).foregroundColor(.apexStarBlue).padding(.top, 6)
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(point.title).font(AppFont.body)
                    if progress.isMastered(point.id) {
                        Image(systemName: "checkmark.seal.fill").font(.caption2).foregroundColor(.apexEmerald)
                    } else if progress.isPracticed(point.id) {
                        Image(systemName: "checkmark.circle").font(.caption2).foregroundColor(.apexStarBlue)
                    }
                }
                Text(point.summary).font(AppFont.caption).foregroundColor(.secondary)
                HStack(spacing: 4) {
                    Image(systemName: method.icon).font(.system(size: 9)).foregroundColor(method.accent)
                    Text(method.title).font(AppFont.chip).foregroundColor(method.accent)
                }
            }
            Spacer(minLength: 0)
            TagChip(text: point.ability.title, color: .apexMystery)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.sm)
        .background(Color.apexBackground).cornerRadius(Radius.chip)
    }
}

// MARK: - 句式 / 词块库（独立子页）

/// 句式 / 词块库：按分类分组，可发音、可加入复习。
struct PhraseLibraryView: View {
    @State private var query = ""

    private var cardsByCategory: [(category: PhraseCategory, cards: [PhraseCard])] {
        let keyword = query.trimmingCharacters(in: .whitespaces).lowercased()
        return PhraseCategory.allCases.compactMap { cat in
            let cards = PhraseBook.cards(in: cat).filter { card in
                keyword.isEmpty
                    || card.en.lowercased().contains(keyword)
                    || card.zh.contains(keyword)
                    || card.usage.contains(keyword)
            }
            return cards.isEmpty ? nil : (cat, cards)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                InfoBanner(
                    title: "句式 / 词块库",
                    systemImage: "text.quote",
                    accent: .apexEmerald,
                    detail: "读后续写与应用文的高分弹药，点喇叭听读，点 + 加入复习。")
                ForEach(cardsByCategory, id: \.category.id) { group in
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        HStack {
                            TagChip(text: group.category.title, color: group.category.color)
                            Spacer()
                            Text("\(group.cards.count) 条").font(AppFont.caption).foregroundColor(.secondary)
                        }
                        ForEach(group.cards) { card in
                            PhraseRow(card: card, accent: group.category.color)
                        }
                    }
                }
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("句式 / 词块库")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query, prompt: "搜句式或用法")
    }
}

/// 句式卡行：句库与检索结果共用。
struct PhraseRow: View {
    let card: PhraseCard
    var accent: Color = .apexEmerald

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            VStack(alignment: .leading, spacing: 2) {
                Text(card.en).font(AppFont.body).foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(card.zh).font(AppFont.caption).foregroundColor(.secondary)
                Text(card.usage).font(AppFont.chip).foregroundColor(accent)
            }
            Spacer(minLength: 0)
            PronounceButton(text: card.en)
            ReviewToggleButton(id: "p:\(card.id)")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.sm)
        .background(Color.apexBackground).cornerRadius(Radius.chip)
    }
}

// MARK: - 共用小组件

/// 库页顶部说明条：标题 + 一句话用法。
struct InfoBanner: View {
    let title: String
    let systemImage: String
    let accent: Color
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: systemImage).font(AppFont.cardTitle).foregroundColor(accent)
            Text(detail).font(AppFont.caption).foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.md)
    }
}
