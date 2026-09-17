import SwiftUI

/// 智能复习：按 SM-2 调度，复习到期的错题与句式卡。
struct ReviewView: View {
    @ObservedObject private var scheduler = ReviewScheduler.shared
    @State private var queue: [String] = []
    @State private var revealed = false
    @State private var listeningPlayCount = 0

    var body: some View {
        Group {
            if queue.isEmpty {
                ContentUnavailableViewCompat(
                    title: "今日复习已清空",
                    systemImage: "checkmark.circle",
                    description: "答错的题与你加入的句式会按遗忘曲线在这里到期，明天再来。")
            } else if let id = queue.first, let ref = ReviewRef.resolve(id) {
                card(id: id, ref: ref)
            } else {
                Color.clear.onAppear { advance(removeFirst: true) }
            }
        }
        .navigationTitle("智能复习")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { if queue.isEmpty { queue = scheduler.dueIDs() } }
    }

    private func card(id: String, ref: ReviewRef) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                HStack {
                    TagChip(text: kindLabel(ref), color: .apexMystery)
                    Spacer()
                    Text("剩 \(queue.count)").font(AppFont.caption).foregroundColor(.secondary)
                }
                front(ref)
                if revealed {
                    Divider()
                    back(ref)
                    gradeButtons(id: id)
                } else {
                    Button { withAnimation { revealed = true } } label: {
                        Text("显示答案").font(AppFont.cardTitle).foregroundColor(.white)
                            .frame(maxWidth: .infinity).padding(Spacing.md)
                            .background(Color.apexStarBlue).cornerRadius(Radius.inner)
                    }
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
    }

    @ViewBuilder private func front(_ ref: ReviewRef) -> some View {
        switch ref {
        case .question(let q):
            if let script = q.listeningScript {
                ListeningPlayerCard(script: script, playCount: $listeningPlayCount, maxPlays: nil)
            }
            Text(q.stem).font(.body).fixedSize(horizontal: false, vertical: true)
        case .phrase(let p):
            HStack(alignment: .top, spacing: Spacing.sm) {
                Text(p.en).font(.title3.weight(.semibold)).fixedSize(horizontal: false, vertical: true)
                PronounceButton(text: p.en)
            }
        case .vocab(let w):
            Text(w.meaning).font(.title3.weight(.semibold)).fixedSize(horizontal: false, vertical: true)
            Text("根据释义回忆这个词怎么拼、怎么用。").font(AppFont.caption).foregroundColor(.secondary)
        case .knowledge(let q):
            TagChip(text: pointTitle(q.knowledgePointID), color: .apexMystery)
            Text(q.prompt).font(.body).fixedSize(horizontal: false, vertical: true)
            Text("先按题目要求作答，再翻面对答案与方法四步。")
                .font(AppFont.caption).foregroundColor(.secondary)
        case .method(let m):
            HStack(alignment: .top, spacing: Spacing.sm) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(m.title).font(.title3.weight(.semibold))
                    Text(m.oneLiner).font(AppFont.caption).foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
                Image(systemName: m.icon).foregroundColor(m.accent)
            }
            Text("先自己复述这个方法的第一步，再翻面核对四步动作。")
                .font(AppFont.caption).foregroundColor(.secondary)
        }
    }

    @ViewBuilder private func back(_ ref: ReviewRef) -> some View {
        switch ref {
        case .question(let q):
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Label("正确答案：\(q.options[q.answer])", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.apexEmerald).font(AppFont.cardTitle)
                    PronounceButton(text: q.options[q.answer])
                }
                ForEach(Array(q.strategy.enumerated()), id: \.offset) { i, s in
                    Text("\(i + 1). \(s)").font(AppFont.body).foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        case .phrase(let p):
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Text(p.zh).font(.body)
                    Spacer()
                    PronounceButton(text: p.en)
                }
                Text(p.usage).font(AppFont.caption).foregroundColor(.secondary)
            }
        case .vocab(let w):
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Label(w.headword, systemImage: "checkmark.circle.fill")
                        .foregroundColor(.apexEmerald).font(AppFont.cardTitle)
                    PronounceButton(text: w.headword)
                }
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Text(w.example).font(.body).italic().fixedSize(horizontal: false, vertical: true)
                    PronounceButton(text: w.example, englishOnly: true)
                }
                Text(w.exampleMeaning).font(AppFont.caption).foregroundColor(.secondary)
                if !w.collocations.isEmpty {
                    Text(w.collocations.joined(separator: " · ")).font(AppFont.chip).foregroundColor(.apexGold)
                }
            }
        case .knowledge(let q):
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Label("正确答案：\(q.options[q.answer])", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.apexEmerald).font(AppFont.cardTitle)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 0)
                    PronounceButton(text: q.options[q.answer], englishOnly: true)
                }
                Text(q.explanation).font(AppFont.body).foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                let method = StudyMethodCatalog.primary(
                    for: JuniorKnowledgeCatalog.all.first { $0.id == q.knowledgePointID } ?? fallbackPoint)
                HStack(spacing: 6) {
                    Image(systemName: method.icon).font(.caption).foregroundColor(method.accent)
                    Text("用「\(method.title)」重看一遍：\(method.selfCheck)")
                        .font(AppFont.chip).foregroundColor(method.accent)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        case .method(let m):
            VStack(alignment: .leading, spacing: Spacing.md) {
                ForEach(Array(m.steps.enumerated()), id: \.offset) { i, step in
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        Text("\(i + 1)").font(AppFont.bigStat(14)).foregroundColor(.white)
                            .frame(width: 20, height: 20).background(m.accent).clipShape(Circle())
                        Text(step).font(AppFont.body).foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 0)
                    }
                }
                Text("示范：\(m.exampleEn)").font(AppFont.caption).foregroundColor(.apexEmerald)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func pointTitle(_ id: String) -> String {
        JuniorKnowledgeCatalog.all.first { $0.id == id }?.title ?? id
    }

    /// 兜底知识点：题库中的知识点 id 必然存在，这里只为避免强制解包。
    private var fallbackPoint: JuniorKnowledgePoint {
        JuniorKnowledgeCatalog.all.first ?? JuniorKnowledgePoint(
            id: "", stage: .primary, ability: .reading, title: "", summary: "", examples: [])
    }

    private func gradeButtons(id: String) -> some View {
        HStack(spacing: Spacing.sm) {
            gradeBtn("重来", .apexDanger, id: id, q: 1)
            gradeBtn("困难", .apexGold, id: id, q: 3)
            gradeBtn("良好", .apexStarBlue, id: id, q: 4)
            gradeBtn("简单", .apexEmerald, id: id, q: 5)
        }
        .padding(.top, Spacing.sm)
    }

    private func gradeBtn(_ title: String, _ color: Color, id: String, q: Int) -> some View {
        Button {
            scheduler.grade(id, quality: q)
            advance(removeFirst: true)
        } label: {
            Text(title).font(AppFont.chip).foregroundColor(.white)
                .frame(maxWidth: .infinity).padding(.vertical, Spacing.md)
                .background(color).cornerRadius(Radius.chip)
        }
    }

    private func advance(removeFirst: Bool) {
        revealed = false; listeningPlayCount = 0
        if removeFirst, !queue.isEmpty { queue.removeFirst() }
    }

    private func kindLabel(_ ref: ReviewRef) -> String {
        switch ref {
        case .question: return "错题复习"
        case .phrase: return "句式复习"
        case .vocab: return "词汇复习"
        case .knowledge: return "知识点题复习"
        case .method: return "学习方法复习"
        }
    }
}
