import SwiftUI

// MARK: - Top King 同门软件推荐位（首页广告页与解锁页共用）
//
// 广告位目的：让用户知道这是一整套同厂出品的学习工具——
// 同一套「估分、诊断、给下一步」的引擎，攻克一科，另外两科直接上手。
// 链接先指向各自官网（App Store 上架后把 url 换成 itms-apps://apps.apple.com/cn/app/idXXXX 即可）。

enum EngFamilyApp: String, CaseIterable, Identifiable {
    case eng
    case math
    case chin

    var id: String { rawValue }

    var title: String {
        switch self {
        case .eng: return "英语登顶 EngTop"
        case .math: return "数学登顶 MathTop"
        case .chin: return "语文登顶 ChinTop"
        }
    }

    var pitch: String {
        switch self {
        case .eng: return "考点导航力：语法、完形、读后续写，先补最容易丢分的那块"
        case .math: return "建模推理力：把应用题拆成步骤，压轴题也敢下手"
        case .chin: return "证据表达力：阅读、文言、诗词、作文，写得出采分点"
        }
    }

    var icon: String {
        switch self {
        case .eng: return "character.book.closed.fill"
        case .math: return "function"
        case .chin: return "book.closed.fill"
        }
    }

    var tint: Color {
        switch self {
        case .eng: return .apexLava
        case .math: return .apexStarBlue
        case .chin: return .apexGold
        }
    }

    var url: URL {
        switch self {
        case .eng: return EngLegal.site
        case .math: return URL(string: "https://botonwa83-byte.github.io/MathTop/")!
        case .chin: return URL(string: "https://botonwa83-byte.github.io/ChinTop/")!
        }
    }
}

/// 同门三件套推荐位。`onDark` 用于首页广告页这类深色底场景。
struct EngFamilyAdSection: View {
    var current: EngFamilyApp = .eng
    var onDark: Bool = false
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: 6) {
                Image(systemName: "crown.fill")
                    .font(AppFont.caption)
                    .foregroundColor(.apexGold)
                Text("Top King 出品 · 同门三件套")
                    .font(AppFont.chip)
                    .foregroundColor(secondaryText)
            }
            ForEach(EngFamilyApp.allCases) { app in
                EngFamilyAdRow(app: app, isCurrent: app == current, onDark: onDark) { openURL(app.url) }
            }
            Text("同一套学习引擎：估分、诊断、给下一步。攻克一科，另外两科直接上手。")
                .font(AppFont.caption)
                .foregroundColor(tertiaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Spacing.lg)
        .background(cardBackground)
        .cornerRadius(Radius.card)
    }

    private var cardBackground: Color { onDark ? Color.white.opacity(0.08) : Color.apexCardSurface }
    private var secondaryText: Color { onDark ? Color.white.opacity(0.7) : Color.secondary }
    private var tertiaryText: Color { onDark ? Color.white.opacity(0.5) : Color.secondary.opacity(0.8) }
}

private struct EngFamilyAdRow: View {
    let app: EngFamilyApp
    let isCurrent: Bool
    let onDark: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: Radius.inner).fill(app.tint)
                    Image(systemName: app.icon).font(AppFont.subhead).foregroundColor(.white)
                }
                .frame(width: 34, height: 34)
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(app.title)
                            .font(AppFont.cardTitle)
                            .foregroundColor(onDark ? .white : .primary)
                        if isCurrent {
                            Text("使用中")
                                .font(AppFont.chip)
                                .foregroundColor(.apexEmerald)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(Color.apexEmerald.opacity(0.14)))
                        }
                    }
                    Text(app.pitch)
                        .font(AppFont.caption)
                        .foregroundColor(onDark ? Color.white.opacity(0.65) : .secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
                Image(systemName: "arrow.up.right")
                    .font(AppFont.caption)
                    .foregroundColor(onDark ? Color.white.opacity(0.45) : .secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("了解 \(app.title)")
    }
}

// MARK: - 一杯奶茶价说服卡

/// 价格锚点：把一次买断翻译成「一杯奶茶」，并给出「先逛逛再决定」的退路，降低决策压力。
struct EngMilkTeaPitchCard: View {
    var onDark: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: 6) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(AppFont.caption)
                    .foregroundColor(.apexGold)
                Text("一杯奶茶 vs 一次解锁")
                    .font(AppFont.chip)
                    .foregroundColor(secondaryText)
            }
            Text("一杯奶茶的钱，换考场上那句「我见过」")
                .font(AppFont.bodyBold)
                .foregroundColor(onDark ? .white : .primary)
                .fixedSize(horizontal: false, vertical: true)
            Text("语法、完形、七选五、读后续写、听力全开。奶茶喝完只剩空杯，这次解锁留下的是实打实的分。")
                .font(AppFont.footnote)
                .foregroundColor(secondaryText)
                .fixedSize(horizontal: false, vertical: true)
            VStack(alignment: .leading, spacing: Spacing.sm) {
                pitchRow("奶茶：一节课的快乐，下课就忘了", tint: .secondary)
                pitchRow("解锁：7 大模块全程导航，估分到考点级", tint: .apexEmerald)
                pitchRow("今天少喝一杯奶茶，考场多拿一道完形的分", tint: .apexLava)
            }
            Text("免费前三关随便练：觉得有用再回来，价格不变。")
                .font(AppFont.caption)
                .foregroundColor(tertiaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Spacing.lg)
        .background(cardBackground)
        .cornerRadius(Radius.card)
    }

    private func pitchRow(_ text: String, tint: Color) -> some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Circle().fill(tint).frame(width: 6, height: 6).padding(.top, 6)
            Text(text)
                .font(AppFont.footnote)
                .foregroundColor(onDark ? Color.white.opacity(0.85) : .primary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
    }

    private var cardBackground: Color { onDark ? Color.white.opacity(0.08) : Color.apexCardSurface }
    private var secondaryText: Color { onDark ? Color.white.opacity(0.7) : Color.secondary }
    private var tertiaryText: Color { onDark ? Color.white.opacity(0.5) : Color.secondary.opacity(0.8) }
}

// MARK: - 「要不要现在解锁」询问卡

/// 给一个明确的「是 / 否」：想买就买，不想买就先逛——免费内容不缩水，随时可以回来。
struct EngUnlockAskCard: View {
    let price: String
    var onDark: Bool = false
    let onUnlock: () -> Void
    let onBrowse: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("要不要用一杯奶茶的价格，解锁整个 EngTop？")
                .font(AppFont.bodyBold)
                .foregroundColor(onDark ? .white : .primary)
                .fixedSize(horizontal: false, vertical: true)
            Text("解锁后：五大模块全开 + 完整模考 + 写作教练 + 提分雷达，一次买断，永久使用。")
                .font(AppFont.footnote)
                .foregroundColor(secondaryText)
                .fixedSize(horizontal: false, vertical: true)
            Button(action: onUnlock) {
                HStack(spacing: 8) {
                    Image(systemName: "lock.open.fill")
                    Text("好，一杯奶茶换一整年底气  \(price)")
                }
                .font(AppFont.subhead)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.lg)
                .background(LinearGradient(colors: [.apexLava, .apexMystery], startPoint: .leading, endPoint: .trailing))
                .cornerRadius(Radius.tile)
            }
            .buttonStyle(.plain)
            Button(action: onBrowse) {
                Text("先逛逛，等会儿再决定")
                    .font(AppFont.footnote)
                    .foregroundColor(secondaryText)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            Text("先浏览也行：免费关卡不缩水，想好了随时回来解锁。")
                .font(AppFont.caption)
                .foregroundColor(tertiaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Spacing.lg)
        .background(cardBackground)
        .cornerRadius(Radius.card)
    }

    private var cardBackground: Color { onDark ? Color.white.opacity(0.08) : Color.apexCardSurface }
    private var secondaryText: Color { onDark ? Color.white.opacity(0.7) : Color.secondary }
    private var tertiaryText: Color { onDark ? Color.white.opacity(0.5) : Color.secondary.opacity(0.8) }
}
