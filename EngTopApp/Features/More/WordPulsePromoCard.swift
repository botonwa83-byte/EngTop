import SwiftUI

/// WordPulse 推荐卡：同厂姊妹 App（初高中词汇 · 词根词缀破译），点击跳 App Store。
/// 用于「更多」Tab 推荐位与重点词汇库页尾。
struct WordPulsePromoCard: View {
    static let appStoreURL = URL(string: "https://apps.apple.com/cn/app/6767762376")!

    @Environment(\.openURL) private var openURL

    var body: some View {
        Button {
            openURL(Self.appStoreURL)
        } label: {
            HStack(spacing: Spacing.md) {
                // 图标位
                ZStack {
                    RoundedRectangle(cornerRadius: Radius.inner)
                        .fill(LinearGradient(colors: [.apexStarBlue, .apexMystery],
                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                    Image(systemName: "bolt.pulse.fill")
                        .font(.system(size: 22, weight: .bold)).foregroundColor(.white)
                }
                .frame(width: 46, height: 46)

                VStack(alignment: .leading, spacing: 3) {
                    Text("WordPulse · 词根破译背单词").font(AppFont.cardTitle).foregroundColor(.primary)
                    Text("看到陌生长难词，拆开词根也能猜出意思。")
                        .font(AppFont.caption).foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("330+ 词根词缀 · 5800+ 核心词汇 · 离线学习")
                        .font(AppFont.chip).foregroundColor(.apexStarBlue)
                }
                Spacer(minLength: 0)
                Image(systemName: "arrow.up.right.square.fill")
                    .font(.system(size: 18)).foregroundColor(.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("了解 WordPulse")
    }
}
