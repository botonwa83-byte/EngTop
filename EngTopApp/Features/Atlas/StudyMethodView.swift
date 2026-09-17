import SwiftUI

// MARK: - 学习方法库（素材库第五个库）
//
// 为什么单独成库：知识点库回答「学什么」，方法库回答「怎么学」。
// 每个方法都能落到任意一道新题上，所以方法是跨知识点的资产，而不是某个知识点的附属品。

struct StudyMethodLibraryView: View {
    @ObservedObject private var progress = StudyMethodStore.shared
    @State private var query = ""

    private var methods: [StudyMethod] { StudyMethodCatalog.search(query) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                InfoBanner(
                    title: "英语学习方法",
                    systemImage: "lightbulb.max.fill",
                    accent: .apexGold,
                    detail: "8 个可迁移的固定动作：每个都是四步，练完一个知识点，能把它用到下一道新题上。")
                summaryCard
                ForEach(methods) { method in
                    NavigationLink { StudyMethodDetailView(method: method) } label: {
                        StudyMethodRow(method: method, score: progress.score(for: method))
                    }.buttonStyle(.plain)
                }
                if methods.isEmpty {
                    ContentUnavailableViewCompat(
                        title: "没有匹配的方法",
                        systemImage: "magnifyingglass",
                        description: "试试「时态」「阅读」「复习」这类关键词。")
                        .frame(height: 220)
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("学习方法")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query, prompt: "搜方法名、四步或误区")
    }

    private var summaryCard: some View {
        HStack(spacing: Spacing.md) {
            stat("已练方法", "\(progress.practicedMethodCount)/\(StudyMethod.allCases.count)", .apexStarBlue)
            Divider().frame(height: 34)
            stat("方法题作答", "\(progress.totalAttempts)", .apexLava)
            Divider().frame(height: 34)
            stat("覆盖知识点", "\(JuniorKnowledgeCatalog.all.count)", .apexEmerald)
        }
        .frame(maxWidth: .infinity)
        .cardSurface(padding: Spacing.md)
    }

    private func stat(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: 3) {
            Text(value).font(AppFont.bigStat(20)).foregroundColor(color).lineLimit(1).minimumScaleFactor(0.75)
            Text(title).font(AppFont.chip).foregroundColor(.secondary).lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}

/// 方法行：图标 + 名称 + 一句话 + 掌握度。
struct StudyMethodRow: View {
    let method: StudyMethod
    var score: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: Radius.chip).fill(method.accent.opacity(0.16))
                        .frame(width: 34, height: 34)
                    Image(systemName: method.icon).font(.system(size: 15, weight: .semibold))
                        .foregroundColor(method.accent)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(method.title).font(AppFont.cardTitle)
                    Text(method.abilityLabel).font(AppFont.chip).foregroundColor(.secondary)
                }
                Spacer(minLength: 0)
                Text("\(StudyMethodCatalog.points(of: method).count) 个知识点")
                    .font(AppFont.chip).foregroundColor(.secondary)
                Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
            }
            Text(method.oneLiner).font(AppFont.caption).foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: Spacing.sm) {
                ProgressView(value: Double(score), total: 100).tint(method.accent)
                Text(score > 0 ? "\(score)" : "未练")
                    .font(AppFont.chip).foregroundColor(.secondary).frame(width: 30, alignment: .trailing)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.md)
    }
}

// MARK: - 方法详情：四步动作 + 示例 + 自检 + 涉及知识点

struct StudyMethodDetailView: View {
    let method: StudyMethod
    @ObservedObject private var progress = StudyMethodStore.shared

    private var points: [JuniorKnowledgePoint] { StudyMethodCatalog.points(of: method) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header
                stepsCard
                exampleCard
                pitfallCard
                selfCheckCard
                drillEntry
                pointsSection
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle(method.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        let score = progress.score(for: method)
        return VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: method.icon).font(.title2).foregroundColor(method.accent)
                VStack(alignment: .leading, spacing: 2) {
                    Text(method.title).font(AppFont.sectionTitle)
                    Text(method.abilityLabel).font(AppFont.chip).foregroundColor(.secondary)
                }
                Spacer()
                Text(score > 0 ? "\(score) 分" : "未练")
                    .font(AppFont.bigStat(22)).foregroundColor(method.accent)
            }
            Text(method.oneLiner).font(AppFont.body).foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: Spacing.sm) {
                TagChip(text: "\(method.steps.count) 步动作", color: method.accent)
                TagChip(text: "覆盖 \(points.count) 个知识点", color: .apexStarBlue)
                Spacer()
                ReviewToggleButton(id: "m:\(method.rawValue)")
            }
        }
        .cardSurface(padding: Spacing.md)
    }

    private var stepsCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "四步动作", systemImage: "list.number", accent: method.accent)
            ForEach(Array(method.steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Text("\(index + 1)")
                        .font(AppFont.bigStat(15))
                        .foregroundColor(.white)
                        .frame(width: 22, height: 22)
                        .background(method.accent)
                        .clipShape(Circle())
                    Text(step).font(AppFont.body)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 0)
                }
            }
        }
        .cardSurface(padding: Spacing.md)
    }

    private var exampleCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "示范一句", systemImage: "text.quote", accent: .apexEmerald)
            HStack(alignment: .top, spacing: Spacing.sm) {
                Text(method.exampleEn).font(AppFont.cardTitle)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
                PronounceButton(text: method.exampleEn, fontSize: 15)
            }
            Text(method.exampleHint).font(AppFont.caption).foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .cardSurface(padding: Spacing.md)
    }

    private var pitfallCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("最容易踩的坑", systemImage: "exclamationmark.triangle.fill")
                .font(AppFont.cardTitle).foregroundColor(.apexDanger)
            Text(method.pitfall).font(AppFont.body).foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.md)
    }

    private var selfCheckCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("自检问题", systemImage: "checkmark.bubble.fill")
                .font(AppFont.cardTitle).foregroundColor(.apexGold)
            Text(method.selfCheck).font(AppFont.body)
                .fixedSize(horizontal: false, vertical: true)
            Text("能自己回答这个问题，才算真正掌握了这个方法；答不上来就回到四步动作再走一遍。")
                .font(AppFont.chip).foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.md)
    }

    @ViewBuilder private var drillEntry: some View {
        let questions = StudyMethodDrillView.questions(for: method)
        NavigationLink { StudyMethodDrillView(method: method) } label: {
            HStack(spacing: Spacing.md) {
                Image(systemName: "figure.run").font(.title3).foregroundColor(.apexStarBlue)
                VStack(alignment: .leading, spacing: 2) {
                    Text("用这个方法练 \(questions.count) 道题").font(AppFont.cardTitle)
                    Text("题目来自这个方法覆盖的知识点，每题都标出该用哪一步")
                        .font(AppFont.caption).foregroundColor(.secondary)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.md)
            .background(Color.apexStarBlue.opacity(0.12))
            .cornerRadius(Radius.inner)
        }
        .buttonStyle(.plain)
        .disabled(questions.isEmpty)
    }

    private var pointsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "这些知识点都用它", systemImage: "map", accent: .apexMystery)
            ForEach(points) { point in
                NavigationLink { KnowledgeDetailView(point: point) } label: {
                    KnowledgeRow(point: point)
                }.buttonStyle(.plain)
            }
        }
    }
}

// MARK: - 方法专练：把该方法覆盖的知识点方法题串成一组练习

struct StudyMethodDrillView: View {
    let method: StudyMethod

    @State private var index = 0
    @State private var selected: Int?
    @State private var correctCount = 0
    @State private var wrongIDs: [String] = []

    /// 该方法覆盖的知识点上的方法题，按知识点顺序排列（学段从低到高）。
    static func questions(for method: StudyMethod) -> [KnowledgePracticeQuestion] {
        let ids = StudyMethodCatalog.points(of: method).map(\.id)
        let order = Dictionary(uniqueKeysWithValues: ids.enumerated().map { ($1, $0) })
        return KnowledgeQuestionInjection3.all
            .filter { order[$0.knowledgePointID] != nil }
            .sorted { (order[$0.knowledgePointID] ?? 0) < (order[$1.knowledgePointID] ?? 0) }
    }

    private var questions: [KnowledgePracticeQuestion] { Self.questions(for: method) }
    private var pointTitles: [String: String] {
        Dictionary(uniqueKeysWithValues: JuniorKnowledgeCatalog.all.map { ($0.id, $0.title) })
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                if questions.isEmpty {
                    ContentUnavailableViewCompat(
                        title: "暂无方法题",
                        systemImage: "questionmark.circle",
                        description: "这个方法的练习正在整理。")
                        .frame(height: 260)
                } else if index < questions.count {
                    questionBody(questions[index])
                } else {
                    resultBody
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle(method.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder private func questionBody(_ question: KnowledgePracticeQuestion) -> some View {
        ProgressView(value: Double(index), total: Double(questions.count)).tint(method.accent)
        HStack {
            Text("第 \(index + 1)/\(questions.count) 题").font(AppFont.caption).foregroundColor(.secondary)
            Spacer()
            TagChip(text: question.kind, color: .apexMystery)
        }
        Text("知识点：\(pointTitles[question.knowledgePointID] ?? question.knowledgePointID)")
            .font(AppFont.chip).foregroundColor(method.accent)
        Text(question.prompt).font(AppFont.sectionTitle)
            .fixedSize(horizontal: false, vertical: true)

        ForEach(Array(question.options.enumerated()), id: \.offset) { option, text in
            Button { answer(option, question) } label: {
                HStack {
                    Text(text).font(AppFont.body).multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 0)
                    if selected == option {
                        Image(systemName: option == question.answer ? "checkmark.circle.fill" : "xmark.circle.fill")
                    }
                }
                .padding(Spacing.md).frame(maxWidth: .infinity, alignment: .leading)
                .background(optionColor(option, question)).cornerRadius(Radius.inner)
            }
            .buttonStyle(.plain).disabled(selected != nil)
        }

        if selected != nil {
            VStack(alignment: .leading, spacing: 6) {
                Label(method.title, systemImage: method.icon)
                    .font(AppFont.cardTitle).foregroundColor(method.accent)
                Text(question.explanation).font(AppFont.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardSurface(padding: Spacing.md)

            Button(index == questions.count - 1 ? "查看结果" : "下一题") {
                index += 1
                selected = nil
            }
            .font(AppFont.cardTitle).foregroundColor(.white)
            .frame(maxWidth: .infinity).padding(Spacing.md)
            .background(Color.apexStarBlue).cornerRadius(Radius.inner)
        }
    }

    private var resultBody: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.md) {
                Image(systemName: correctCount == questions.count ? "checkmark.seal.fill" : "arrow.clockwise.circle.fill")
                    .font(.system(size: 46)).foregroundColor(method.accent)
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(method.title) · 练完一组").font(AppFont.sectionTitle)
                    Text("答对 \(correctCount)/\(questions.count) 题").font(AppFont.body).foregroundColor(.secondary)
                }
            }
            if wrongIDs.isEmpty {
                Text("这一组全对。下一步：把这个方法用到一个新知识点上，确认它真的可迁移。")
                    .font(AppFont.body).foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text("答错的 \(wrongIDs.count) 道题已自动进入智能复习，按遗忘曲线到期后会在「智能复习」里再出现一次。")
                    .font(AppFont.body).foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            VStack(alignment: .leading, spacing: 6) {
                Label("再确认一次这个方法的自检问题", systemImage: "checkmark.bubble.fill")
                    .font(AppFont.cardTitle).foregroundColor(.apexGold)
                Text(method.selfCheck).font(AppFont.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardSurface(padding: Spacing.md)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func answer(_ option: Int, _ question: KnowledgePracticeQuestion) {
        selected = option
        let correct = option == question.answer
        if correct { correctCount += 1 } else { wrongIDs.append(question.id) }
        StudyMethodStore.shared.record(method, correct: correct)
        EngStore.shared.recordAbilityChallenge(correct ? .correct : .wrong, ability: method.abilities.first ?? .reading)
        // 打通「练 → 复」：答错的方法题进入 SM-2 复习队列
        if !correct { ReviewScheduler.shared.addIfAbsent("k:\(question.id)") }
    }

    private func optionColor(_ option: Int, _ question: KnowledgePracticeQuestion) -> Color {
        guard let selected else { return .apexCardSurface }
        if option == question.answer { return .apexEmerald.opacity(0.2) }
        if option == selected { return .apexDanger.opacity(0.2) }
        return .apexCardSurface
    }
}
