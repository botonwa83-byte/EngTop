import SwiftUI

/// 全库统一检索：一次搜索同时覆盖重点词汇500 / 词汇专项 / 句式词块 / 语法知识点，
/// 结果分组展示，词条可直接发音，条目可跳详情。解决"想找东西要挨个库翻"的问题。
struct LibrarySearchView: View {
    @State private var query = ""
    @FocusState private var focused: Bool

    private var keyword: String { query.trimmingCharacters(in: .whitespaces).lowercased() }

    // MARK: 四个库的命中结果

    private var wordHits: [WordBankEntry] {
        guard !keyword.isEmpty else { return [] }
        return Array(WordBank.entries(stage: nil, query: query).prefix(40))
    }

    private var vocabHits: [VocabWord] {
        guard !keyword.isEmpty else { return [] }
        return Array(VocabData.all.filter {
            $0.headword.lowercased().contains(keyword)
                || $0.meaning.contains(keyword)
                || $0.collocations.contains { $0.lowercased().contains(keyword) }
        }.prefix(20))
    }

    private var phraseHits: [PhraseCard] {
        guard !keyword.isEmpty else { return [] }
        return Array(PhraseBook.all.filter {
            $0.en.lowercased().contains(keyword) || $0.zh.contains(keyword) || $0.usage.contains(keyword)
        }.prefix(20))
    }

    private var knowledgeHits: [JuniorKnowledgePoint] {
        guard !keyword.isEmpty else { return [] }
        return Array(JuniorKnowledgeCatalog.points(query: query).prefix(20))
    }

    private var methodHits: [StudyMethod] {
        guard !keyword.isEmpty else { return [] }
        return StudyMethodCatalog.search(query)
    }

    private var totalHits: Int { wordHits.count + vocabHits.count + phraseHits.count + knowledgeHits.count + methodHits.count }

    var body: some View {
        List {
            if keyword.isEmpty {
                emptyState
            } else if totalHits == 0 {
                Section {
                    ContentUnavailableViewCompat(
                        title: "没有找到「\(query)」",
                        systemImage: "magnifyingglass",
                        description: "试试更短的拼写，或换成中文释义关键词。")
                }
            } else {
                if !wordHits.isEmpty {
                    Section("重点词汇 · \(wordHits.count)") {
                        ForEach(wordHits) { entry in
                            WordBankSearchRow(entry: entry)
                        }
                    }
                }
                if !vocabHits.isEmpty {
                    Section("词汇专项 · \(vocabHits.count)") {
                        ForEach(vocabHits) { word in
                            NavigationLink { VocabDetailView(word: word) } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(word.headword).font(AppFont.cardTitle)
                                    Text(word.meaning).font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
                                }
                            }
                        }
                    }
                }
                if !phraseHits.isEmpty {
                    Section("句式 / 词块 · \(phraseHits.count)") {
                        ForEach(phraseHits) { card in
                            PhraseRow(card: card)
                                .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                        }
                    }
                }
                if !knowledgeHits.isEmpty {
                    Section("语法知识点 · \(knowledgeHits.count)") {
                        ForEach(knowledgeHits) { point in
                            NavigationLink { KnowledgeDetailView(point: point) } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 6) {
                                        Text(point.title).font(AppFont.body)
                                        TagChip(text: point.stage.title, color: .apexStarBlue)
                                    }
                                    Text(point.summary).font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
                                }
                            }
                        }
                    }
                }
                if !methodHits.isEmpty {
                    Section("学习方法 · \(methodHits.count)") {
                        ForEach(methodHits) { method in
                            NavigationLink { StudyMethodDetailView(method: method) } label: {
                                StudyMethodRow(method: method, score: StudyMethodStore.shared.score(for: method))
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("全库检索")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query, prompt: "搜单词、句式、知识点")
        .onAppear { focused = true }
    }

    /// 空查询时展示五个库的规模与直达入口，检索页本身也是索引页。
    @ViewBuilder private var emptyState: some View {
        Section("库规模") {
            indexRow("学习方法", "\(StudyMethod.allCases.count) 个", "lightbulb.max", .apexGold) {
                StudyMethodLibraryView()
            }
            indexRow("重点词汇 500", "\(WordBank.all.count) 词", "text.book.closed", .apexStarBlue) {
                WordBankView()
            }
            indexRow("词汇专项", "\(VocabData.all.count) 词", "character.book.closed", .apexLava) {
                VocabLibraryView()
            }
            indexRow("句式 / 词块库", "\(PhraseBook.all.count) 条", "text.quote", .apexEmerald) {
                PhraseLibraryView()
            }
            indexRow("语法知识点", "\(JuniorKnowledgeCatalog.all.count) 个", "map", .apexMystery) {
                KnowledgeLibraryView()
            }
        }
    }

    private func indexRow<D: View>(_ title: String, _ count: String, _ icon: String,
                                   _ color: Color, @ViewBuilder destination: @escaping () -> D) -> some View {
        NavigationLink { destination() } label: {
            HStack(spacing: Spacing.sm) {
                Image(systemName: icon).foregroundColor(color).frame(width: 24)
                Text(title).font(AppFont.body)
                Spacer()
                Text(count).font(AppFont.caption).foregroundColor(.secondary)
            }
        }
    }
}

/// 检索结果里的重点词汇行：点词读单词、点喇叭读例句。
struct WordBankSearchRow: View {
    let entry: WordBankEntry
    @ObservedObject private var player = SpeechPlayer.shared

    private var isPlaying: Bool { player.isPlaying }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Text(entry.word).font(AppFont.cardTitle)
                if !entry.phonetic.isEmpty {
                    Text("/\(entry.phonetic)/").font(AppFont.caption).foregroundColor(.secondary).lineLimit(1)
                }
                Spacer(minLength: 0)
                TagChip(text: entry.stageTitle, color: entry.stage == 1 ? .apexEmerald : .apexStarBlue)
                Button { player.speak(entry.word) } label: {
                    Image(systemName: isPlaying ? "waveform" : "speaker.wave.fill")
                        .font(AppFont.subhead)
                        .foregroundColor(isPlaying ? .apexEmerald : .apexStarBlue)
                }.buttonStyle(.plain)
            }
            Text(entry.meaning).font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
            if entry.hasExample {
                HStack(alignment: .top, spacing: Spacing.sm) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(entry.example).font(AppFont.caption).italic()
                            .fixedSize(horizontal: false, vertical: true)
                        Text(entry.exampleMeaning).font(AppFont.chip).foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer(minLength: 0)
                    PronounceButton(text: entry.example, fontSize: 13)
                }
            }
        }
        .padding(.vertical, Spacing.xxs)
    }
}
