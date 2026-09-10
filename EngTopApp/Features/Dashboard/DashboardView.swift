import SwiftUI

/// 英语能力驾驶舱：把 Apex 的算法反馈改造成小学初中的每日能力训练。
struct DashboardView: View {
    @EnvironmentObject var store: EngStore
    @EnvironmentObject var purchase: PurchaseManager
    @ObservedObject private var daily = DailyManager.shared
    @ObservedObject private var learningProgress = LearningProgressStore.shared
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    welcomeHeader
                    gravityChallenge
                    dailyKnowledge
                    learningMissionCard
                    planCard
                    abilitySection
                    learningAbilitySection
                    estimatorCard
                    sniperCard
                    reviewCard
                    radarSection
                    moduleBars
                }
                .padding(Spacing.lg)
                .readableWidth()
            }
            .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("提分决策力 · 驾驶舱")
        }
        .sheet(isPresented: $showPaywall) { PaywallView() }
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

    private var welcomeHeader: some View {
        HStack(alignment: .center) {
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
                    RoundedRectangle(cornerRadius: 12).fill(Color.apexLava.opacity(0.16)).frame(width: 56, height: 56)
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

    private var abilitySection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "能力雷达", systemImage: "dot.radiowaves.left.and.right", accent: .apexStarBlue)
            ForEach(Ability.allCases) { ability in
                let score = store.abilityProfile.score(for: ability)
                HStack(spacing: Spacing.sm) {
                    Image(systemName: icon(for: ability)).foregroundColor(color(for: ability)).frame(width: 22)
                    Text(ability.title).font(AppFont.body)
                    ProgressView(value: Double(score), total: 100).tint(color(for: ability))
                    Text("\(score)").font(AppFont.caption).foregroundColor(.secondary).frame(width: 28, alignment: .trailing)
                }
            }
        }
        .cardSurface(padding: Spacing.md)
    }

    private var learningAbilitySection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                SectionHeader(title: "学习能力成长", systemImage: "circle.hexagongrid.fill", accent: .apexMystery)
                NavigationLink {
                    LearningGymView()
                } label: {
                    Image(systemName: "arrow.up.right")
                        .font(AppFont.caption)
                        .foregroundColor(.apexMystery)
                }
                .accessibilityLabel("打开能力训练营")
            }
            Text("能力训练不止是答对：理解、推理、迁移和反思都会留下成长记录。")
                .font(AppFont.caption)
                .foregroundColor(.secondary)
            ForEach(LearningAbility.allCases) { ability in
                let score = learningProgress.score(for: ability)
                HStack(spacing: Spacing.sm) {
                    Image(systemName: ability.systemImage)
                        .foregroundColor(learningColor(for: ability))
                        .frame(width: 22)
                    Text(ability.title).font(AppFont.body)
                    ProgressView(value: Double(score), total: 100)
                        .tint(learningColor(for: ability))
                    Text("\(score)").font(AppFont.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 28, alignment: .trailing)
                }
            }
            Text("已完成 \(learningProgress.completedMissionCount)/\(LearningMissionCatalog.all.count) 项真实情境任务")
                .font(AppFont.chip)
                .foregroundColor(.secondary)
        }
        .cardSurface(padding: Spacing.md)
    }

    private func learningColor(for ability: LearningAbility) -> Color {
        switch ability {
        case .information: return .apexStarBlue
        case .reasoning: return .apexMystery
        case .transfer: return .apexEmerald
        case .expression: return .apexLava
        case .planning: return .apexGold
        case .reflection: return .apexDanger
        }
    }

    private func icon(for ability: Ability) -> String {
        switch ability {
        case .vocabulary: return "textformat.abc"
        case .wordOrder: return "arrow.up.and.down"
        case .tense: return "clock"
        case .reading: return "magnifyingglass"
        case .listening: return "waveform"
        case .expression: return "bubble.left.and.bubble.right"
        }
    }

    private func color(for ability: Ability) -> Color {
        switch ability {
        case .vocabulary, .reading: return .apexStarBlue
        case .wordOrder, .expression: return .apexLava
        case .tense, .listening: return .apexEmerald
        }
    }

    // MARK: 解锁完整版（首页与"更多"页同一文案，保持一致）

    @ViewBuilder private var unlockBanner: some View {
        if !purchase.isUnlocked {
            Button { showPaywall = true } label: {
                HStack(spacing: Spacing.md) {
                    Image(systemName: "crown.fill").font(.title3).foregroundColor(.apexGold)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("解锁完整版").font(AppFont.cardTitle)
                        Text("主线 7 关全开（阅读/应用文/读后续写/听力），一次买断")
                            .font(AppFont.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
                }
                .cardSurface(padding: Spacing.md)
            }.buttonStyle(.plain)
        }
    }

    // MARK: 今日提分计划（高考倒计时 + Streak + 三目标）

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

    // MARK: 估分仪表盘

    private var estimatorCard: some View {
        let total = store.totalEstimate
        let answered = store.abilityProfile.xp > 0
        return VStack(spacing: Spacing.md) {
            Text("英语能力 · 今日等级").font(AppFont.caption).foregroundColor(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(answered ? "\(store.abilityProfile.xp)" : "—")
                    .font(AppFont.bigStat(52)).foregroundColor(.apexStarBlue)
                Text(" XP").font(AppFont.body).foregroundColor(.secondary)
            }
            if answered {
                Text("能力等级 Lv.\(store.abilityProfile.level) · 连击 \(store.abilityProfile.combo)")
                    .font(AppFont.caption).foregroundColor(.secondary)
            } else {
                Text("完成挑战，能力雷达就会开始校准")
                    .font(AppFont.caption).foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .cardSurface()
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

    // MARK: 各模块估分条

    private var moduleBars: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "各模块估分", systemImage: "chart.bar.fill", accent: .apexStarBlue)
            ForEach(store.estimates) { est in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: est.module.icon).font(.caption).foregroundColor(.secondary)
                        Text(est.module.title).font(AppFont.body)
                        Spacer()
                        Text("\(fmt(est.estimatedScore))/\(fmt(est.fullScore))")
                            .font(AppFont.caption).foregroundColor(.secondary)
                        if est.confidence < 0.2 {
                            Text("待测").font(AppFont.chip).foregroundColor(.apexGold)
                        }
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.secondary.opacity(0.15))
                            Capsule().fill(Color.apexStarBlue)
                                .frame(width: geo.size.width * est.scoreRatio)
                        }
                    }.frame(height: 8)
                }
            }
        }
        .cardSurface()
    }

    private func fmt(_ v: Double) -> String {
        v == v.rounded() ? String(Int(v)) : String(format: "%.1f", v)
    }
}
