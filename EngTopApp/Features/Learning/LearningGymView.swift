import SwiftUI

/// 能力训练营：把英语知识放进真实情境，练习理解、推理、迁移、表达、规划和反思。
struct LearningGymView: View {
    @ObservedObject private var progress = LearningProgressStore.shared
    @State private var stageFilter = "all"

    private var filteredMissions: [LearningMission] {
        guard stageFilter != "all", let stage = StudyStage(rawValue: stageFilter) else {
            return LearningMissionCatalog.all
        }
        return LearningMissionCatalog.all.filter { $0.stage == stage }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                introCard
                progressSummary
                abilityGrid
                recommendedCard
                missionList
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("能力训练营")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var introCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: Radius.inner)
                        .fill(Color.apexMystery.opacity(0.16))
                        .frame(width: 48, height: 48)
                    Image(systemName: "figure.mind.and.body")
                        .font(.title2)
                        .foregroundColor(.apexMystery)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("把英语用起来").font(AppFont.cardTitle)
                    Text("每个任务都来自学习和生活中的真实问题")
                        .font(AppFont.caption)
                        .foregroundColor(.secondary)
                }
            }
            Text("先理解情境，再作答、迁移和反思。你练到的是解决问题的能力，不只是记住一个答案。")
                .font(AppFont.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.md)
    }

    private var progressSummary: some View {
        HStack(spacing: Spacing.md) {
            stat("已完成任务", value: "\(progress.completedMissionCount)/\(LearningMissionCatalog.all.count)", color: .apexStarBlue)
            Divider().frame(height: 34)
            stat("累计尝试", value: "\(progress.totalAttempts)", color: .apexLava)
            Divider().frame(height: 34)
            stat("下一步", value: progress.recommendedMission.ability.title, color: .apexEmerald)
        }
        .frame(maxWidth: .infinity)
        .cardSurface(padding: Spacing.md)
    }

    private func stat(_ title: String, value: String, color: Color) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(AppFont.bigStat(20))
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(title)
                .font(AppFont.chip)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }

    private var abilityGrid: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "六项学习能力", systemImage: "circle.hexagongrid.fill", accent: .apexMystery)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.sm) {
                ForEach(LearningAbility.allCases) { ability in
                    abilityTile(ability)
                }
            }
        }
    }

    private func abilityTile(_ ability: LearningAbility) -> some View {
        let score = progress.score(for: ability)
        return VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: ability.systemImage)
                    .foregroundColor(color(for: ability))
                Text(ability.title)
                    .font(AppFont.cardTitle)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer(minLength: 0)
                Text("\(score)")
                    .font(AppFont.chip)
                    .foregroundColor(.secondary)
            }
            ProgressView(value: Double(score), total: 100)
                .tint(color(for: ability))
            Text(ability.subtitle)
                .font(AppFont.chip)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.md)
        .background(Color.apexCardSurface)
        .cornerRadius(Radius.inner)
    }

    private var recommendedCard: some View {
        let mission = progress.recommendedMission
        return NavigationLink {
            LearningMissionView(mission: mission)
        } label: {
            VStack(alignment: .leading, spacing: Spacing.md) {
                HStack {
                    Label("推荐下一步", systemImage: "scope")
                        .font(AppFont.cardTitle)
                        .foregroundColor(.apexLava)
                    Spacer()
                    TagChip(text: mission.stage.title, color: .apexStarBlue)
                }
                HStack(alignment: .top, spacing: Spacing.md) {
                    Image(systemName: mission.ability.systemImage)
                        .font(.title2)
                        .foregroundColor(color(for: mission.ability))
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(mission.title).font(AppFont.sectionTitle)
                        Text("\(mission.ability.title) · \(mission.subtitle)")
                            .font(AppFont.caption)
                            .foregroundColor(.secondary)
                        Text("完成答题、迁移和反思，形成一次完整学习闭环。")
                            .font(AppFont.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardSurface(padding: Spacing.md)
        }
        .buttonStyle(.plain)
    }

    private var missionList: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "真实情境任务", systemImage: "rectangle.3.group", accent: .apexStarBlue)
            Picker("学段", selection: $stageFilter) {
                Text("全部").tag("all")
                ForEach(StudyStage.allCases) { stage in
                    Text(stage.title).tag(stage.rawValue)
                }
            }
            .pickerStyle(.segmented)

            ForEach(filteredMissions) { mission in
                NavigationLink {
                    LearningMissionView(mission: mission)
                } label: {
                    missionRow(mission)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func missionRow(_ mission: LearningMission) -> some View {
        let stat = progress.stat(for: mission.id)
        let completed = stat.attempts > 0
        return HStack(alignment: .top, spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(color(for: mission.ability).opacity(0.15))
                    .frame(width: 42, height: 42)
                Image(systemName: mission.ability.systemImage)
                    .foregroundColor(color(for: mission.ability))
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(mission.title).font(AppFont.cardTitle)
                    TagChip(text: mission.kind.title, color: color(for: mission.ability))
                }
                Text("\(mission.stage.title) · \(mission.ability.title)")
                    .font(AppFont.chip)
                    .foregroundColor(.secondary)
                Text(mission.subtitle)
                    .font(AppFont.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
            if completed {
                VStack(alignment: .trailing, spacing: 3) {
                    Text("\(LearningProgressEngine.score(for: stat))")
                        .font(AppFont.cardTitle)
                        .foregroundColor(.apexEmerald)
                    Text("成长值").font(AppFont.chip).foregroundColor(.secondary)
                }
            } else {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.md)
    }

    private func color(for ability: LearningAbility) -> Color {
        switch ability {
        case .information: return .apexStarBlue
        case .reasoning: return .apexMystery
        case .transfer: return .apexEmerald
        case .expression: return .apexLava
        case .planning: return .apexGold
        case .reflection: return .apexDanger
        }
    }
}

struct LearningMissionView: View {
    let mission: LearningMission
    @EnvironmentObject private var store: EngStore
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var progress = LearningProgressStore.shared

    @State private var selected: Int?
    @State private var transferText = ""
    @State private var transferConfirmed = false
    @State private var reflectionChoice: String?
    @State private var finished = false
    @State private var recordedScore = 0

    private var isCorrect: Bool { selected == mission.answer }
    private var canFinish: Bool {
        selected != nil && transferConfirmed && reflectionChoice != nil
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                if finished {
                    completionView
                } else {
                    missionHeader
                    contextCard
                    questionBlock
                    if selected != nil {
                        explanationBlock
                        transferBlock
                        reflectionBlock
                        finishButton
                    }
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        // 长文本输入（迁移写作）后，滑动页面即可收起键盘
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("能力任务")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var missionHeader: some View {
        HStack(spacing: Spacing.sm) {
            TagChip(text: mission.stage.title, color: .apexStarBlue)
            TagChip(text: mission.ability.title, color: .apexMystery)
            TagChip(text: mission.kind.title, color: .apexEmerald)
            Spacer(minLength: 0)
        }
    }

    private var contextCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(mission.title).font(AppFont.sectionTitle)
            Text(mission.subtitle)
                .font(AppFont.caption)
                .foregroundColor(.secondary)
            Divider()
            Text(mission.context)
                .font(AppFont.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.md)
    }

    private var questionBlock: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text(mission.prompt)
                .font(AppFont.sectionTitle)
                .fixedSize(horizontal: false, vertical: true)
            ForEach(Array(mission.options.enumerated()), id: \.offset) { index, option in
                Button {
                    guard selected == nil else { return }
                    selected = index
                } label: {
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        Text(option)
                            .font(AppFont.body)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 0)
                        if let selected, selected == index {
                            Image(systemName: index == mission.answer ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(index == mission.answer ? .apexEmerald : .apexDanger)
                        }
                    }
                    .padding(Spacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(optionColor(index))
                    .cornerRadius(Radius.inner)
                }
                .buttonStyle(.plain)
                .disabled(selected != nil)
            }
        }
    }

    private var explanationBlock: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Label(isCorrect ? "判断正确" : "先记住这个思路", systemImage: isCorrect ? "checkmark.seal.fill" : "lightbulb.fill")
                .font(AppFont.cardTitle)
                .foregroundColor(isCorrect ? .apexEmerald : .apexGold)
            Text(mission.explanation)
                .font(AppFont.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.md)
    }

    private var transferBlock: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Label("迁移一步", systemImage: "arrow.triangle.2.circlepath")
                .font(AppFont.cardTitle)
                .foregroundColor(.apexEmerald)
            Text(mission.transferPrompt)
                .font(AppFont.body)
                .fixedSize(horizontal: false, vertical: true)
            TextEditor(text: $transferText)
                .frame(minHeight: 86)
                .padding(Spacing.sm)
                .background(Color.apexBackground)
                .cornerRadius(Radius.chip)
                .overlay(RoundedRectangle(cornerRadius: Radius.chip).stroke(Color.secondary.opacity(0.15)))
            Button {
                transferConfirmed = !transferText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            } label: {
                Label(transferConfirmed ? "已记录迁移尝试" : "我已经尝试迁移",
                      systemImage: transferConfirmed ? "checkmark.circle.fill" : "pencil.and.outline")
                    .font(AppFont.cardTitle)
                    .foregroundColor(transferConfirmed ? .apexEmerald : .apexStarBlue)
            }
            .buttonStyle(.plain)
            .disabled(transferText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.md)
    }

    private var reflectionBlock: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Label("反思一下", systemImage: "person.crop.circle.badge.questionmark")
                .font(AppFont.cardTitle)
                .foregroundColor(.apexMystery)
            Text(mission.reflectionPrompt)
                .font(AppFont.body)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: Spacing.sm) {
                reflectionButton("我能做到", value: "ready", color: .apexEmerald)
                reflectionButton("还需要再练", value: "practice", color: .apexLava)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.md)
    }

    private func reflectionButton(_ title: String, value: String, color: Color) -> some View {
        Button {
            reflectionChoice = value
        } label: {
            Text(title)
                .font(AppFont.cardTitle)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.sm)
                .background(reflectionChoice == value ? color.opacity(0.2) : Color.apexBackground)
                .foregroundColor(reflectionChoice == value ? color : .primary)
                .cornerRadius(Radius.chip)
        }
        .buttonStyle(.plain)
    }

    private var finishButton: some View {
        Button {
            finish()
        } label: {
            Text("完成这项能力任务")
                .font(AppFont.cardTitle)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(Spacing.md)
                .background(canFinish ? Color.apexStarBlue : Color.secondary)
                .cornerRadius(Radius.inner)
        }
        .buttonStyle(.plain)
        .disabled(!canFinish)
    }

    private var completionView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: isCorrect ? "checkmark.seal.fill" : "arrow.clockwise.circle.fill")
                .font(.system(size: 58))
                .foregroundColor(isCorrect ? .apexEmerald : .apexGold)
            Text("这次任务完成了").font(.title2.bold())
            Text(isCorrect ? "你完成了理解、迁移和反思，能力成长值已更新。" : "你找到了错误思路，也完成了迁移和反思。下一次会更稳。")
                .font(AppFont.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Text("本项成长值 \(recordedScore)")
                .font(AppFont.cardTitle)
                .foregroundColor(.apexStarBlue)
            Button("返回能力训练营") {
                dismiss()
            }
            .font(AppFont.cardTitle)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(Spacing.md)
            .background(Color.apexStarBlue)
            .cornerRadius(Radius.inner)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xxl)
    }

    private func optionColor(_ index: Int) -> Color {
        guard let selected else { return Color.apexCardSurface }
        if index == mission.answer { return Color.apexEmerald.opacity(0.2) }
        if index == selected { return Color.apexDanger.opacity(0.2) }
        return Color.apexCardSurface
    }

    private func finish() {
        guard !finished, let selected else { return }
        let correct = selected == mission.answer
        let reflectionCompleted = reflectionChoice != nil
        progress.record(
            mission,
            correct: correct,
            transferCompleted: transferConfirmed,
            reflectionCompleted: reflectionCompleted
        )
        store.recordAbilityChallenge(correct ? .correct : .wrong, ability: mission.ability.linkedLanguageAbility)
        recordedScore = progress.score(for: mission.ability)
        finished = true
    }
}
