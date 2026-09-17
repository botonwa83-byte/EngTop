import SwiftUI

/// 「关于」卡片：与 MathTop「我的 · 关于」保持同一套版式
/// —— 区块标题 + 内容统计行 + 分隔线 + 协议链接 + 版本署名。
struct EngAboutCard: View {
    /// 每个知识点配套题量下限（三轮注入后统一抬到 3 道）。
    static let minimumQuestionsPerPoint = 3

    private var knowledgePointCount: Int { JuniorKnowledgeCatalog.all.count }
    private var questionCount: Int { QuestionBank.all.count + CuratedKnowledgeQuestions.all.count }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "关于", systemImage: "info.circle", accent: .apexStarBlue)

            VStack(alignment: .leading, spacing: Spacing.sm) {
                aboutRow("知识点总数", "\(knowledgePointCount) 个")
                aboutRow("配套练习总数", "\(questionCount) 道")
                aboutRow("每个知识点配套题量", "不少于 \(Self.minimumQuestionsPerPoint) 道")
                aboutRow("学习活动库", "\(LearningMissionCatalog.all.count) 个能力任务")
            }

            Divider()

            VStack(alignment: .leading, spacing: Spacing.sm) {
                Link("用户协议", destination: EngLegal.termsURL)
                Link("隐私政策", destination: EngLegal.privacyURL)
                Link("技术支持", destination: EngLegal.supportURL)
            }
            .font(AppFont.caption)

            Text("EngTop · 英语登顶  v1.0.0\n© 2026 Top King. All rights reserved.")
                .font(AppFont.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .cardSurface(padding: Spacing.lg)
    }

    private func aboutRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title).font(AppFont.body).foregroundColor(.secondary)
            Spacer(minLength: Spacing.sm)
            Text(value).font(AppFont.body).bold().foregroundColor(.primary)
        }
    }
}
