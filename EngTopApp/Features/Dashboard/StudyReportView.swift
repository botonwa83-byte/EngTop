import SwiftUI

/// 学习报告：把原先堆在驾驶舱首页的展示型数据（估分、能力雷达、学习能力成长、各模块估分）
/// 收进独立一页。首页只留"今天该做什么"，报告页负责"我现在什么水平"。
struct StudyReportView: View {
    @EnvironmentObject var store: EngStore
    @ObservedObject private var learningProgress = LearningProgressStore.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                estimatorCard
                abilitySection
                learningAbilitySection
                moduleBars
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("学习报告")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: 估分仪表盘

    private var estimatorCard: some View {
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

    // MARK: 能力雷达

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

    // MARK: 学习能力成长

    private var learningAbilitySection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                SectionHeader(title: "学习能力成长", systemImage: "circle.hexagongrid.fill", accent: .apexMystery)
                NavigationLink { LearningGymView() } label: {
                    Image(systemName: "arrow.up.right").font(AppFont.caption).foregroundColor(.apexMystery)
                }
                .accessibilityLabel("打开能力训练营")
            }
            Text("能力训练不止是答对：理解、推理、迁移和反思都会留下成长记录。")
                .font(AppFont.caption).foregroundColor(.secondary)
            ForEach(LearningAbility.allCases) { ability in
                let score = learningProgress.score(for: ability)
                HStack(spacing: Spacing.sm) {
                    Image(systemName: ability.systemImage)
                        .foregroundColor(learningColor(for: ability)).frame(width: 22)
                    Text(ability.title).font(AppFont.body)
                    ProgressView(value: Double(score), total: 100).tint(learningColor(for: ability))
                    Text("\(score)").font(AppFont.caption).foregroundColor(.secondary).frame(width: 28, alignment: .trailing)
                }
            }
            Text("已完成 \(learningProgress.completedMissionCount)/\(LearningMissionCatalog.all.count) 项真实情境任务")
                .font(AppFont.chip).foregroundColor(.secondary)
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

    // MARK: 各模块估分

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
