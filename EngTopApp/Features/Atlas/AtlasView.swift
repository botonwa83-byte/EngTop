import SwiftUI

/// 素材库（索引页）：只做"找东西"这一件事——顶部统一检索，下面四个库的入口与进度。
/// 各库的全量条目各自在独立子页滚动，首页不再堆上千条列表（学生翻页累的根因）。
struct AtlasView: View {
    @ObservedObject private var vocabStore = VocabStore.shared
    @ObservedObject private var knowledgeProgress = KnowledgeProgressStore.shared
    @ObservedObject private var methodStore = StudyMethodStore.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    searchEntry
                    knowledgeSummary
                    methodSummary
                    libraryGrid
                    WordPulsePromoCard()
                }
                .padding(Spacing.lg)
                .readableWidth()
            }
            .background(Color.apexBackground.ignoresSafeArea())
            .navigationTitle("素材库")
        }
    }

    // MARK: 统一检索入口

    private var searchEntry: some View {
        NavigationLink { LibrarySearchView() } label: {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                Text("搜单词、句式、知识点").font(AppFont.body).foregroundColor(.secondary)
                Spacer()
                Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
            }
            .padding(.vertical, Spacing.md).padding(.horizontal, Spacing.md)
            .background(Color.apexCardSurface)
            .cornerRadius(Radius.inner)
            .overlay(RoundedRectangle(cornerRadius: Radius.inner).stroke(Color.secondary.opacity(0.18)))
        }
        .buttonStyle(.plain)
    }

    // MARK: 图谱总进度

    private var knowledgeSummary: some View {
        let total = JuniorKnowledgeCatalog.all.count
        let done = knowledgeProgress.mastered.count
        let touched = knowledgeProgress.touchedCount
        return VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("英语知识图谱").font(AppFont.cardTitle)
                    Text("小学至初三 · \(total) 个核心知识点 · 已练 \(touched) 个").font(AppFont.caption).foregroundColor(.secondary)
                }
                Spacer()
                Text("\(touched)/\(total)").font(AppFont.bigStat(24)).foregroundColor(.apexStarBlue)
            }
            ProgressView(value: Double(touched), total: Double(max(total, 1))).tint(.apexEmerald)
            Text("已掌握 \(done) 个（自己确认） · 练过即计入进度")
                .font(AppFont.chip).foregroundColor(.secondary)
        }.cardSurface(padding: Spacing.md)
    }

    // MARK: 学习方法进度

    private var methodSummary: some View {
        NavigationLink { StudyMethodLibraryView() } label: { methodSummaryCard }
            .buttonStyle(.plain)
    }

    private var methodSummaryCard: some View {
        let practiced = methodStore.practicedMethodCount
        let total = StudyMethod.allCases.count
        return VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("英语学习方法").font(AppFont.cardTitle)
                    Text("\(total) 个四步方法 · 已练 \(practiced) 个 · 方法题作答 \(methodStore.totalAttempts) 次")
                        .font(AppFont.caption).foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
            }
            Text("先学方法，再用方法做题：每个知识点都绑定了一个可迁移的方法。")
                .font(AppFont.chip).foregroundColor(.apexGold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.md)
    }

    // MARK: 四个库入口

    private var libraryGrid: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "五个库", systemImage: "square.grid.2x2", accent: .apexStarBlue)
            LazyVGrid(columns: [GridItem(.flexible(), spacing: Spacing.md),
                                GridItem(.flexible(), spacing: Spacing.md)], spacing: Spacing.md) {
                NavigationLink { StudyMethodLibraryView() } label: {
                    LibraryEntryCard(icon: "lightbulb.max", color: .apexGold,
                                     title: "学习方法",
                                     detail: "\(StudyMethod.allCases.count) 个方法",
                                     footnote: "四步动作 · 可迁移")
                }.buttonStyle(.plain)

                NavigationLink { WordBankView() } label: {
                    LibraryEntryCard(icon: "text.book.closed", color: .apexStarBlue,
                                     title: "重点词汇 500",
                                     detail: "小学 200 · 初中 300",
                                     footnote: "带音标与例句")
                }.buttonStyle(.plain)

                NavigationLink { VocabLibraryView() } label: {
                    LibraryEntryCard(icon: "character.book.closed", color: .apexLava,
                                     title: "词汇专项",
                                     detail: "\(VocabData.all.count) 词",
                                     footnote: "已掌握 \(vocabStore.mastered.count)")
                }.buttonStyle(.plain)

                NavigationLink { KnowledgeLibraryView() } label: {
                    LibraryEntryCard(icon: "map", color: .apexMystery,
                                     title: "语法知识点",
                                     detail: "\(JuniorKnowledgeCatalog.all.count) 个",
                                     footnote: "已练 \(knowledgeProgress.touchedCount) · 已掌握 \(knowledgeProgress.mastered.count)")
                }.buttonStyle(.plain)

                NavigationLink { PhraseLibraryView() } label: {
                    LibraryEntryCard(icon: "text.quote", color: .apexEmerald,
                                     title: "句式 / 词块",
                                     detail: "\(PhraseBook.all.count) 条",
                                     footnote: "续写 · 应用文弹药")
                }.buttonStyle(.plain)
            }
        }
    }
}

/// 素材库入口卡：图标 + 名称 + 规模 + 一行补充信息。
struct LibraryEntryCard: View {
    let icon: String
    let color: Color
    let title: String
    let detail: String
    let footnote: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: Radius.inner).fill(color.opacity(0.16)).frame(width: 40, height: 40)
                Image(systemName: icon).font(.system(size: 18, weight: .semibold)).foregroundColor(color)
            }
            Text(title).font(AppFont.cardTitle).foregroundColor(.primary)
            Text(detail).font(AppFont.caption).foregroundColor(.secondary)
            Text(footnote).font(AppFont.chip).foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.md)
    }
}

struct KnowledgeDetailView: View {
    let point: JuniorKnowledgePoint
    @ObservedObject private var progress = KnowledgeProgressStore.shared
    @ObservedObject private var methodStore = StudyMethodStore.shared

    private var method: StudyMethod { StudyMethodCatalog.primary(for: point) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                HStack {
                    TagChip(text: point.stage.title, color: .apexStarBlue)
                    TagChip(text: point.ability.title, color: .apexMystery)
                    if progress.isPracticed(point.id) { TagChip(text: "已练过", color: .apexEmerald) }
                }
                Text(point.title).font(AppFont.sectionTitle)
                Text(point.summary).font(AppFont.body).foregroundColor(.secondary)
                let lesson = KnowledgeLessonCatalog.lesson(for: point)
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Label("核心规则", systemImage: "brain.head.profile").font(AppFont.cardTitle).foregroundColor(.apexStarBlue)
                    Text(lesson.rule).font(AppFont.body)
                    Text("示例：\(lesson.example)").font(AppFont.body).foregroundColor(.apexEmerald)
                    Text("易错点：\(lesson.trap)").font(AppFont.caption).foregroundColor(.apexLava)
                    Text("迁移任务：\(lesson.transfer)").font(AppFont.caption).foregroundColor(.secondary)
                }.cardSurface(padding: Spacing.md)
                methodCard
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
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        Text(example).font(AppFont.cardTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        PronounceButton(text: example, englishOnly: true)
                    }
                    .cardSurface(padding: Spacing.md)
                }
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Label("易错提醒", systemImage: "exclamationmark.triangle.fill").font(AppFont.cardTitle).foregroundColor(.apexLava)
                    Text(method.pitfall)
                        .font(AppFont.body).foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }.cardSurface(padding: Spacing.md)
                let practiceCount = KnowledgePracticeFactory.questions(for: point).count
                NavigationLink("开始专项练习（\(practiceCount) 题）") { KnowledgePracticeView(point: point) }
                    .font(AppFont.cardTitle).foregroundColor(.white).frame(maxWidth: .infinity).padding(Spacing.md)
                    .background(practiceCount > 0 ? Color.apexStarBlue : Color.secondary).cornerRadius(Radius.inner)
                    .disabled(practiceCount == 0)
            }.padding(Spacing.lg)
        }.background(Color.apexBackground.ignoresSafeArea()).navigationTitle("知识点")
    }

    /// 用这个知识点对应的「学习方法」替代原来那句通用文案：方法名 + 四步 + 掌握度 + 直达入口。
    private var methodCard: some View {
        let score = methodStore.score(for: method)
        return VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: method.icon).foregroundColor(method.accent)
                Text("用「\(method.title)」学这个知识点").font(AppFont.cardTitle)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
                Text(score > 0 ? "\(score) 分" : "未练")
                    .font(AppFont.chip).foregroundColor(method.accent)
            }
            ForEach(Array(method.steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Text("\(index + 1)").font(AppFont.bigStat(12)).foregroundColor(.white)
                        .frame(width: 18, height: 18).background(method.accent).clipShape(Circle())
                    Text(step).font(AppFont.caption)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 0)
                }
            }
            HStack(spacing: Spacing.md) {
                NavigationLink { StudyMethodDetailView(method: method) } label: {
                    Text("看方法详情").font(AppFont.chip).foregroundColor(.apexStarBlue)
                }.buttonStyle(.plain)
                Spacer()
                ReviewToggleButton(id: "m:\(method.rawValue)")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.md)
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
