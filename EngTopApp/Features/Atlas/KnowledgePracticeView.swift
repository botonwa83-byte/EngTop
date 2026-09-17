import SwiftUI

/// 知识点专项练习。
///
/// 与其他环节的打通点（这一版的重点）：
/// 1. 进入即看到该知识点的**学习方法**（方法名 + 第一步），先方法后做题；
/// 2. 答错的题自动进入 SM-2 复习队列（复习 id 前缀 `k:`），在「智能复习」里按遗忘曲线再出现；
/// 3. 方法题（kind 为方法 / 辨析 / 检查 / 迁移）的作答会写进方法掌握度，驱动「学习方法」库的进度；
/// 4. 首次作答即把该知识点标记为「练过」，在知识图谱里留下痕迹。
struct KnowledgePracticeView: View {
    let point: JuniorKnowledgePoint
    @EnvironmentObject private var store: EngStore
    @ObservedObject private var progress = KnowledgeProgressStore.shared
    @ObservedObject private var methodStore = StudyMethodStore.shared
    @State private var index = 0
    @State private var selected: Int?
    @State private var correctCount = 0
    @State private var batch = 0
    @State private var wrongCount = 0

    private var method: StudyMethod { StudyMethodCatalog.primary(for: point) }
    private var allQuestions: [KnowledgePracticeQuestion] { KnowledgePracticeFactory.questions(for: point) }
    private var batchSize: Int { KnowledgePracticeFactory.batchSize }
    private var questions: [KnowledgePracticeQuestion] { Array(allQuestions.dropFirst(batch * batchSize).prefix(batchSize)) }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            if allQuestions.isEmpty {
                Spacer()
                VStack(spacing: Spacing.md) {
                    Image(systemName: "books.vertical").font(.system(size: 48)).foregroundColor(.apexGold)
                    Text("该知识点暂无固定练习").font(AppFont.sectionTitle)
                    Text("题库正在整理，请先选择已有题目的知识点。").font(AppFont.body).foregroundColor(.secondary).multilineTextAlignment(.center)
                }.frame(maxWidth: .infinity)
                Spacer()
            } else if index < questions.count {
                let question = questions[index]
                methodHint
                ProgressView(value: Double(index), total: Double(questions.count)).tint(.apexStarBlue)
                HStack { Text("第 \(index + 1)/\(questions.count) 题 · 第 \(batch + 1) 批").font(AppFont.caption).foregroundColor(.secondary); Spacer(); TagChip(text: question.kind, color: .apexMystery) }
                Text(question.prompt).font(AppFont.sectionTitle)
                ForEach(Array(question.options.enumerated()), id: \.offset) { option, text in
                    Button { answer(option, question) } label: {
                        HStack {
                            Text(text).font(AppFont.body).multilineTextAlignment(.leading)
                            Spacer()
                            if selected == option { Image(systemName: option == question.answer ? "checkmark.circle.fill" : "xmark.circle.fill") }
                        }
                        .padding(Spacing.md).frame(maxWidth: .infinity, alignment: .leading)
                        .background(optionColor(option, question)).cornerRadius(Radius.inner)
                    }.buttonStyle(.plain).disabled(selected != nil)
                }
                if selected != nil {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(question.explanation).font(AppFont.body).foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        if selected != question.answer {
                            Label("已加入智能复习，之后会再考你一次", systemImage: "arrow.triangle.2.circlepath")
                                .font(AppFont.chip).foregroundColor(.apexLava)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardSurface(padding: Spacing.md)
                    Button(index == questions.count - 1 ? (batch + 1) * batchSize < allQuestions.count ? "进入下一批" : "查看结果" : "下一题") {
                        if index == questions.count - 1 && (batch + 1) * batchSize < allQuestions.count { batch += 1; index = 0; correctCount = 0 } else { index += 1 }
                        selected = nil
                    }
                        .font(AppFont.cardTitle).foregroundColor(.white).frame(maxWidth: .infinity).padding(Spacing.md)
                        .background(Color.apexStarBlue).cornerRadius(Radius.inner)
                }
            } else {
                resultView
            }
        }.padding(Spacing.lg).background(Color.apexBackground.ignoresSafeArea()).navigationTitle(point.title).navigationBarTitleDisplayMode(.inline)
    }

    // MARK: 方法提示（先方法、后题目）

    private var methodHint: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Image(systemName: method.icon).font(.caption).foregroundColor(method.accent)
            Text("\(method.title)：\(method.steps.first ?? method.oneLiner)")
                .font(AppFont.chip).foregroundColor(method.accent)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
            NavigationLink { StudyMethodDetailView(method: method) } label: {
                Text("看四步").font(AppFont.chip).foregroundColor(.apexStarBlue)
            }.buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.sm)
        .background(method.accent.opacity(0.10))
        .cornerRadius(Radius.chip)
    }

    // MARK: 结算（方法沉淀 + 复习去向）

    private var resultView: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.md) {
                Image(systemName: correctCount == questions.count ? "checkmark.seal.fill" : "arrow.clockwise.circle.fill")
                    .font(.system(size: 52)).foregroundColor(.apexEmerald)
                VStack(alignment: .leading, spacing: 3) {
                    Text("完成 \(point.title)").font(AppFont.sectionTitle)
                    Text("答对 \(correctCount)/\(questions.count) 题").font(AppFont.body).foregroundColor(.secondary)
                }
            }
            HStack(spacing: Spacing.sm) {
                TagChip(text: method.title, color: method.accent)
                TagChip(text: "方法掌握度 \(methodStore.score(for: method))", color: .apexStarBlue)
                if progress.isMastered(point.id) { TagChip(text: "已掌握", color: .apexEmerald) }
            }
            Text(wrongCount > 0
                 ? "错题已加入智能复习（共 \(wrongCount) 道），按遗忘曲线到期后会在「智能复习」里再考你一次；复习时答案区会再提醒你用「\(method.title)」核对。"
                 : "这一批全对。下一步：把「\(method.title)」用到另一个知识点上，确认方法真的可迁移。")
                .font(AppFont.body).foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            VStack(alignment: .leading, spacing: 6) {
                Label("自检：\(method.selfCheck)", systemImage: "checkmark.bubble.fill")
                    .font(AppFont.cardTitle).foregroundColor(.apexGold)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardSurface(padding: Spacing.md)

            HStack(spacing: Spacing.md) {
                NavigationLink { StudyMethodDetailView(method: method) } label: {
                    actionLabel("学这个方法的四步", "lightbulb.max.fill", .apexStarBlue)
                }.buttonStyle(.plain)
                NavigationLink { ReviewView() } label: {
                    actionLabel("去智能复习", "arrow.triangle.2.circlepath", .apexLava)
                }.buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func actionLabel(_ title: String, _ icon: String, _ color: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon).font(.caption)
            Text(title).font(AppFont.chip)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity).padding(.vertical, Spacing.md)
        .background(color).cornerRadius(Radius.chip)
    }

    // MARK: 作答

    private func answer(_ option: Int, _ question: KnowledgePracticeQuestion) {
        selected = option
        let correct = option == question.answer
        if correct { correctCount += 1 } else { wrongCount += 1 }
        store.recordAbilityChallenge(correct ? .correct : .wrong, ability: point.ability)
        progress.markPracticed(point.id)

        // 方法题：写进方法掌握度，驱动「学习方法」库的进度
        if StudyMethodCatalog.isMethodQuestion(question) {
            methodStore.record(method, correct: correct)
        }
        // 打通「练 → 复」：答错的知识点题进入 SM-2 复习队列
        if !correct { ReviewScheduler.shared.addIfAbsent("k:\(question.id)") }
    }

    private func optionColor(_ option: Int, _ question: KnowledgePracticeQuestion) -> Color {
        guard let selected else { return .apexCardSurface }
        if option == question.answer { return .apexEmerald.opacity(0.2) }
        if option == selected { return .apexDanger.opacity(0.2) }
        return .apexCardSurface
    }
}
