import SwiftUI

/// 语言素材库（图鉴 Tab）：静态知识统一索引——词汇 + 句式/词块库，与"提分驾驶舱"(算法日计划)、
/// "题型靶场"(限时刷题)、两个写作工坊(长文写作+教练)各自分工，不再重复模块掌握度展示。
struct AtlasView: View {
    @ObservedObject private var vocabStore = VocabStore.shared
    @ObservedObject private var knowledgeProgress = KnowledgeProgressStore.shared
    @State private var selectedStage: StudyStage? = nil
    @State private var selectedAbility: Ability? = nil
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    knowledgeSummary
                    vocabLibrary
                    knowledgeLibrary
                    phraseLibrary
                }
                .padding(Spacing.lg)
                .readableWidth()
            }
            .background(Color.apexBackground.ignoresSafeArea())
            .navigationTitle("语言素材库")
            .searchable(text: $searchText, prompt: "搜索语法、词汇或例句")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
        }
    }

    private var knowledgeSummary: some View {
        let total = JuniorKnowledgeCatalog.all.count
        let done = knowledgeProgress.mastered.count
        return VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("英语知识图谱").font(AppFont.cardTitle)
                    Text("小学至初三 · \(total) 个核心知识点").font(AppFont.caption).foregroundColor(.secondary)
                }
                Spacer()
                Text("\(done)/\(total)").font(AppFont.bigStat(24)).foregroundColor(.apexStarBlue)
            }
            ProgressView(value: Double(done), total: Double(max(total, 1))).tint(.apexEmerald)
        }.cardSurface(padding: Spacing.md)
    }

    private var knowledgeLibrary: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "小学 · 初中知识图谱", systemImage: "map", accent: .apexStarBlue)
            ForEach(selectedStage.map { [$0] } ?? Array(StudyStage.allCases)) { stage in
                let points = JuniorKnowledgeCatalog.points(stage: stage, ability: selectedAbility, query: searchText)
                if !points.isEmpty {
                HStack {
                    Text(stage.title).font(AppFont.cardTitle)
                    Spacer()
                    Text("\(points.count) 个知识点").font(AppFont.caption).foregroundColor(.secondary)
                }
                ForEach(points) { point in
                    NavigationLink { KnowledgeDetailView(point: point) } label: {
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        Image(systemName: "circle.fill").font(.system(size: 7)).foregroundColor(.apexStarBlue).padding(.top, 6)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(point.title).font(AppFont.body)
                            Text(point.summary).font(AppFont.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        TagChip(text: point.ability.title, color: .apexMystery)
                    }
                    }.buttonStyle(.plain)
                }
                }
            }
        }
        .cardSurface()
    }

    // MARK: 词汇

    private var vocabLibrary: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "词汇", systemImage: "character.book.closed", accent: .apexLava)
            Text("拼写 / 搭配辨析 / 熟词僻义三种练法；高频且你最弱的词永远排最前。").font(AppFont.caption).foregroundColor(.secondary)
            ForEach(Array(vocabStore.priorityList(VocabData.all).enumerated()), id: \.element.word.id) { idx, entry in
                NavigationLink { VocabDetailView(word: entry.word) } label: {
                    vocabRow(rank: idx + 1, word: entry.word)
                }.buttonStyle(.plain)
            }
        }
        .cardSurface()
    }

    private func vocabRow(rank: Int, word: VocabWord) -> some View {
        let mastered = vocabStore.isMastered(word.id)
        return HStack(spacing: Spacing.md) {
            Text("\(rank)").font(AppFont.bigStat(20)).foregroundColor(.apexLava).frame(width: 26)
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(word.headword).font(AppFont.cardTitle)
                    TagChip(text: word.category.title, color: word.category == .collocation ? .apexStarBlue : .apexMystery)
                }
                Text(word.meaning).font(AppFont.caption).foregroundColor(.secondary).lineLimit(1)
            }
            Spacer()
            if mastered { Image(systemName: "checkmark.seal.fill").foregroundColor(.apexEmerald) }
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.sm)
        .background(Color.apexBackground).cornerRadius(Radius.chip)
        .opacity(mastered ? 0.6 : 1)
    }

    // MARK: 句式 / 词块库

    private var phraseLibrary: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "句式 / 词块库", systemImage: "text.quote", accent: .apexEmerald)
            ForEach(PhraseCategory.allCases) { cat in
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    TagChip(text: cat.title, color: cat.color)
                    ForEach(PhraseBook.cards(in: cat)) { card in
                        HStack(alignment: .top, spacing: Spacing.sm) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(card.en).font(AppFont.body).foregroundColor(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text(card.zh).font(AppFont.caption).foregroundColor(.secondary)
                                Text(card.usage).font(AppFont.chip).foregroundColor(cat.color)
                            }
                            Spacer(minLength: 0)
                            ReviewToggleButton(id: "p:\(card.id)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(Spacing.sm)
                        .background(Color.apexBackground).cornerRadius(Radius.chip)
                    }
                }
            }
        }
        .cardSurface()
    }
}

struct KnowledgeDetailView: View {
    let point: JuniorKnowledgePoint
    @ObservedObject private var progress = KnowledgeProgressStore.shared
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                HStack { TagChip(text: point.stage.title, color: .apexStarBlue); TagChip(text: point.ability.title, color: .apexMystery) }
                Text(point.title).font(AppFont.sectionTitle)
                Text(point.summary).font(AppFont.body).foregroundColor(.secondary)
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Label("掌握方法", systemImage: "lightbulb.fill").font(AppFont.cardTitle).foregroundColor(.apexGold)
                    Text("先理解规则，再观察例句中的结构，最后用同一结构替换人物、动作或时间。")
                        .font(AppFont.body).foregroundColor(.secondary)
                }.cardSurface(padding: Spacing.md)
                Button {
                    progress.toggle(point.id)
                } label: {
                    Label(progress.isMastered(point.id) ? "已掌握" : "标记为已掌握", systemImage: progress.isMastered(point.id) ? "checkmark.seal.fill" : "circle")
                        .frame(maxWidth: .infinity).padding(Spacing.md)
                        .background(progress.isMastered(point.id) ? Color.apexEmerald.opacity(0.2) : Color.apexCardSurface)
                        .cornerRadius(Radius.inner)
                }.buttonStyle(.plain)
                SectionHeader(title: "示例", systemImage: "text.quote", accent: .apexLava)
                ForEach(point.examples, id: \.self) { example in
                    Text(example).font(AppFont.cardTitle).frame(maxWidth: .infinity, alignment: .leading)
                        .cardSurface(padding: Spacing.md)
                }
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Label("易错提醒", systemImage: "exclamationmark.triangle.fill").font(AppFont.cardTitle).foregroundColor(.apexLava)
                    Text("不要只背中文意思。检查主语、动词形式、词序和时间标志是否互相匹配。")
                        .font(AppFont.body).foregroundColor(.secondary)
                }.cardSurface(padding: Spacing.md)
                NavigationLink("开始 3 题专项练习") { KnowledgePracticeView(point: point) }
                    .font(AppFont.cardTitle).foregroundColor(.white).frame(maxWidth: .infinity).padding(Spacing.md)
                    .background(Color.apexStarBlue).cornerRadius(Radius.inner)
            }.padding(Spacing.lg)
        }.background(Color.apexBackground.ignoresSafeArea()).navigationTitle("知识点")
    }
}

/// "加入复习"按钮：加入 SM-2 复习库后变为已加入态。句式卡/词汇卡通用，按各自的 id 前缀区分。
struct ReviewToggleButton: View {
    let id: String
    @ObservedObject private var scheduler = ReviewScheduler.shared
    var body: some View {
        let added = scheduler.contains(id)
        Button { scheduler.addIfAbsent(id) } label: {
            Image(systemName: added ? "checkmark.circle.fill" : "plus.circle")
                .foregroundColor(added ? .apexEmerald : .apexStarBlue)
        }
        .buttonStyle(.plain)
        .disabled(added)
    }
}
