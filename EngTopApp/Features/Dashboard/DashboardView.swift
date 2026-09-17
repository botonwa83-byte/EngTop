import SwiftUI

/// 英语能力驾驶舱：只回答"今天该做什么"——行动卡在上，数据展示收进「学习报告」子页。
struct DashboardView: View {
    @EnvironmentObject var store: EngStore
    @ObservedObject private var daily = DailyManager.shared
    @ObservedObject private var learningProgress = LearningProgressStore.shared
    @ObservedObject private var methodStore = StudyMethodStore.shared
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    welcomeHeader
                    quickAccess
                    gravityChallenge
                    dailyKnowledge
                    dailyMethod
                    learningMissionCard
                    planCard
                    reportEntry
                    sniperCard
                    reviewCard
                    radarSection
                }
                .padding(Spacing.lg)
                .readableWidth()
            }
            .background(Color.apexBackground.ignoresSafeArea())
            .navigationTitle("提分决策力 · 驾驶舱")
        }
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }

    /// 快捷入口：检索优先，其次是三个最常用的库。解决"想找东西要多层翻"的问题。
    private var quickAccess: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
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
            }.buttonStyle(.plain)

            HStack(spacing: Spacing.sm) {
                quickChip("重点词汇 500", icon: "text.book.closed", color: .apexStarBlue) { WordBankView() }
                quickChip("句式库", icon: "text.quote", color: .apexEmerald) { PhraseLibraryView() }
                quickChip("知识点", icon: "map", color: .apexMystery) { KnowledgeLibraryView() }
            }
        }
    }

    private func quickChip<D: View>(_ title: String, icon: String, color: Color,
                                    @ViewBuilder destination: @escaping () -> D) -> some View {
        NavigationLink { destination() } label: {
            HStack(spacing: 5) {
                Image(systemName: icon).font(.system(size: 12, weight: .semibold))
                Text(title).font(AppFont.chip)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 9)
            .background(color.opacity(0.14))
            .foregroundColor(color)
            .clipShape(Capsule())
        }.buttonStyle(.plain)
    }

    /// 学习报告入口：把展示型数据沉到子页，首页保留一行关键结论。
    private var reportEntry: some View {
        let answered = store.abilityProfile.xp > 0
        return NavigationLink { StudyReportView() } label: {
            HStack(spacing: Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: Radius.inner)
                        .fill(Color.apexStarBlue.opacity(0.16)).frame(width: 56, height: 56)
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title2).foregroundColor(.apexStarBlue)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("学习报告").font(AppFont.cardTitle)
                    Text(answered
                         ? "能力等级 Lv.\(store.abilityProfile.level) · 估分 \(Int(store.totalEstimate.score)) · 看雷达与各模块估分"
                         : "做几道题后，这里会给出能力雷达与各模块估分")
                        .font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
            }
            .cardSurface(padding: Spacing.md)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder private var dailyKnowledge: some View {
        let mastered = KnowledgeProgressStore.shared.mastered
        if let point = JuniorKnowledgeCatalog.all.first(where: { !mastered.contains($0.id) }) {
            NavigationLink { KnowledgeDetailView(point: point) } label: {
                HStack(spacing: Spacing.md) {
                    Image(systemName: "book.pages.fill").font(.title2).foregroundColor(.apexEmerald).frame(width: 42)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("今日知识点 · \(point.stage.title)").font(AppFont.caption).foregroundColor(.secondary)
                        Text(point.title).font(AppFont.cardTitle)
                        Text(point.summary).font(AppFont.caption).foregroundColor(.secondary).lineLimit(1)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
                }.cardSurface(padding: Spacing.md)
            }.buttonStyle(.plain)
        }
    }

    /// 今日方法：把「怎么学」放到首页，与「今日知识点」形成"方法 + 知识"的配对。
    private var dailyMethod: some View {
        let method = methodStore.recommendedMethod
        let score = methodStore.score(for: method)
        return NavigationLink { StudyMethodDetailView(method: method) } label: {
            HStack(spacing: Spacing.md) {
                Image(systemName: method.icon).font(.title2).foregroundColor(method.accent).frame(width: 42)
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text("今日方法").font(AppFont.caption).foregroundColor(.secondary)
                        if methodStore.stat(for: method).attempts > 0 {
                            TagChip(text: "掌握度 \(score)", color: method.accent)
                        } else {
                            TagChip(text: "未练过", color: .apexGold)
                        }
                    }
                    Text(method.title).font(AppFont.cardTitle)
                    Text(method.steps.first ?? method.oneLiner).font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
            }.cardSurface(padding: Spacing.md)
        }.buttonStyle(.plain)
    }

    private var welcomeHeader: some View {        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("早上好，准备觉醒语感吗？").font(AppFont.cardTitle)
                Text("EngTop · 每天 10 分钟，英语变成你的超能力").font(AppFont.caption).foregroundColor(.secondary)
            }
            Spacer()
            ZStack {
                Circle().fill(Color.apexStarBlue.opacity(0.16)).frame(width: 46, height: 46)
                Image(systemName: "sparkles").font(.title2).foregroundColor(.apexStarBlue)
            }
        }
    }

    private var gravityChallenge: some View {
        NavigationLink {
            GravityChallengeView()
        } label: {
            HStack(spacing: Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: Radius.inner).fill(Color.apexLava.opacity(0.16)).frame(width: 56, height: 56)
                    Image(systemName: "arrow.up.and.down.and.arrow.left.and.right").font(.title2).foregroundColor(.apexLava)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("句子重力场").font(AppFont.cardTitle)
                    Text("拖动词块，让句子恢复正确语序").font(AppFont.caption).foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text("今日挑战").font(AppFont.caption).foregroundColor(.apexLava)
                    Text("5 题").font(AppFont.cardTitle)
                }
            }
            .cardSurface(padding: Spacing.md)
        }
        .buttonStyle(.plain)
    }

    private var learningMissionCard: some View {
        let mission = learningProgress.recommendedMission
        return NavigationLink {
            LearningMissionView(mission: mission)
        } label: {
            HStack(spacing: Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: Radius.inner)
                        .fill(Color.apexMystery.opacity(0.16))
                        .frame(width: 56, height: 56)
                    Image(systemName: mission.ability.systemImage)
                        .font(.title2)
                        .foregroundColor(.apexMystery)
                }
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text("今日能力任务").font(AppFont.cardTitle)
                        TagChip(text: mission.ability.title, color: .apexMystery)
                    }
                    Text(mission.title).font(AppFont.body)
                    Text("练习 \(mission.subtitle)，完成后记录一次迁移和反思")
                        .font(AppFont.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardSurface(padding: Spacing.md)
        }
        .buttonStyle(.plain)
    }

    // MARK: 今日提分计划（连续打卡 + 三目标）

    private var planCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("连续学习").font(AppFont.caption).foregroundColor(.secondary)
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(daily.streak)").font(AppFont.bigStat(34)).foregroundColor(.apexLava)
                        Text("天").font(AppFont.body).foregroundColor(.secondary)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Label("\(daily.streak) 天", systemImage: "flame.fill")
                        .font(AppFont.cardTitle).foregroundColor(.apexGold)
                    Text("连续打卡").font(AppFont.caption).foregroundColor(.secondary)
                }
            }
            Divider()
            HStack {
                Text("今日提分计划").font(AppFont.cardTitle)
                Spacer()
                Text("\(daily.doneCount)/3").font(AppFont.caption)
                    .foregroundColor(daily.allDone ? .apexEmerald : .secondary)
            }
            goalRow("刷题 \(min(daily.log.quizzed, DailyManager.quizGoal))/\(DailyManager.quizGoal)", done: daily.quizDone, icon: "target")
            goalRow("复习到期卡片", done: daily.reviewDone, icon: "brain.head.profile")
            goalRow("狙击 1 个高频考点", done: daily.sniperDone, icon: "scope")
        }
        .cardSurface()
    }

    private func goalRow(_ title: String, done: Bool, icon: String) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .foregroundColor(done ? .apexEmerald : .secondary)
            Image(systemName: icon).font(.caption).foregroundColor(.apexStarBlue)
            Text(title).font(AppFont.body).foregroundColor(done ? .secondary : .primary)
                .strikethrough(done)
            Spacer()
        }
    }

    // MARK: 高频狙击入口

    private var sniperCard: some View {
        let top = store.sniperToday(limit: 3)
        return NavigationLink { HighFreqView() } label: {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "scope").font(.title2).foregroundColor(.apexLava)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("高频狙击").font(AppFont.cardTitle)
                        Text("算法挑出高频且你最弱的考点，先打这些").font(AppFont.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
                }
                if !top.isEmpty {
                    FlowLayout(spacing: 6) {
                        ForEach(top) { hit in
                            TagChip(text: hit.point.name, color: .apexLava)
                        }
                    }
                }
            }
            .cardSurface(padding: Spacing.md)
        }
        .buttonStyle(.plain)
    }

    // MARK: 今日复习

    @ViewBuilder private var reviewCard: some View {
        let due = ReviewScheduler.shared.dueCount
        if due > 0 {
            NavigationLink { ReviewView() } label: {
                HStack(spacing: Spacing.md) {
                    Image(systemName: "brain.head.profile").font(.title2).foregroundColor(.apexMystery)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("今日复习 \(due) 张").font(AppFont.cardTitle)
                        Text("错题与句式按遗忘曲线到期，趁热复盘").font(AppFont.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
                }
                .cardSurface(padding: Spacing.md)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: 提分雷达 · 今日最优路径

    private var radarSection: some View {
        let path = store.topPath(limit: 3)
        return VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "提分雷达 · 今日最优路径", systemImage: "scope", accent: .apexLava)
            if store.performances.isEmpty {
                Text("做题后，雷达会按‘性价比’把你下一个 +5 分排在最前。")
                    .font(AppFont.caption).foregroundColor(.secondary)
                    .padding(.vertical, Spacing.sm)
            } else {
                ForEach(Array(path.enumerated()), id: \.element.id) { idx, opp in
                    NavigationLink {
                        if let level = MainLineData.level(for: opp.module) { QuizView(level: level) }
                    } label: { radarRow(rank: idx + 1, opp: opp) }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func radarRow(rank: Int, opp: GainOpportunity) -> some View {
        HStack(spacing: Spacing.md) {
            Text("\(rank)").font(AppFont.bigStat(22)).foregroundColor(.apexLava)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: opp.module.icon).foregroundColor(.apexStarBlue)
                    Text(opp.module.title).font(AppFont.cardTitle)
                    Spacer()
                    Text("+\(fmt(opp.expectedGain))").font(AppFont.cardTitle).foregroundColor(.apexEmerald)
                }
                Text(opp.reason).font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
                ProgressView(value: opp.normalizedROI).tint(.apexLava)
            }
        }
        .cardSurface(padding: Spacing.md)
    }

    private func fmt(_ v: Double) -> String {
        v == v.rounded() ? String(Int(v)) : String(format: "%.1f", v)
    }
}
