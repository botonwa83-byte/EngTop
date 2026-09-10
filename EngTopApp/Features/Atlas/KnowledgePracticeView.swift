import SwiftUI

struct KnowledgePracticeView: View {
    let point: JuniorKnowledgePoint
    @EnvironmentObject private var store: EngStore
    @State private var index = 0
    @State private var selected: Int?
    @State private var correctCount = 0
    @State private var batch = 0

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
                    Text(question.explanation).font(AppFont.body).foregroundColor(.secondary).cardSurface(padding: Spacing.md)
                    Button(index == questions.count - 1 ? (batch + 1) * batchSize < allQuestions.count ? "进入下一批" : "查看结果" : "下一题") {
                        if index == questions.count - 1 && (batch + 1) * batchSize < allQuestions.count { batch += 1; index = 0; correctCount = 0 } else { index += 1 }
                        selected = nil
                    }
                        .font(AppFont.cardTitle).foregroundColor(.white).frame(maxWidth: .infinity).padding(Spacing.md)
                        .background(Color.apexStarBlue).cornerRadius(Radius.inner)
                }
            } else {
                Spacer()
                VStack(spacing: Spacing.md) {
                    Image(systemName: correctCount == questions.count ? "checkmark.seal.fill" : "arrow.clockwise.circle.fill").font(.system(size: 52)).foregroundColor(.apexEmerald)
                    Text("完成 \(point.title)").font(AppFont.sectionTitle)
                    Text("答对 \(correctCount)/\(questions.count) 题").font(AppFont.body).foregroundColor(.secondary)
                    if correctCount == questions.count { Text("知识能量已点亮").font(AppFont.cardTitle).foregroundColor(.apexLava) }
                }.frame(maxWidth: .infinity)
                Spacer()
            }
        }.padding(Spacing.lg).background(Color.apexBackground.ignoresSafeArea()).navigationTitle(point.title).navigationBarTitleDisplayMode(.inline)
    }

    private func answer(_ option: Int, _ question: KnowledgePracticeQuestion) {
        selected = option
        let correct = option == question.answer
        if correct { correctCount += 1 }
        store.recordAbilityChallenge(correct ? .correct : .wrong, ability: point.ability)
    }

    private func optionColor(_ option: Int, _ question: KnowledgePracticeQuestion) -> Color {
        guard let selected else { return .apexCardSurface }
        if option == question.answer { return .apexEmerald.opacity(0.2) }
        if option == selected { return .apexDanger.opacity(0.2) }
        return .apexCardSurface
    }
}
