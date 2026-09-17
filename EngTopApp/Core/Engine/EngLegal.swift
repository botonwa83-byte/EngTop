import SwiftUI

// MARK: - 上线合规入口（GitHub Pages 托管，付费墙与「更多」页共用同一组链接）

enum EngLegal {
    static let site = URL(string: "https://botonwa83-byte.github.io/EngTop/")!
    static let termsURL = URL(string: "https://botonwa83-byte.github.io/EngTop/terms.html")!
    static let privacyURL = URL(string: "https://botonwa83-byte.github.io/EngTop/privacy.html")!
    static let supportURL = URL(string: "https://botonwa83-byte.github.io/EngTop/support.html")!
}

/// 协议与隐私入口：付费墙底部 +「更多」页「关于与协议」共用。
struct EngLegalLinksView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Link("用户协议", destination: EngLegal.termsURL)
            Link("隐私政策", destination: EngLegal.privacyURL)
            Link("技术支持", destination: EngLegal.supportURL)
        }
        .font(AppFont.caption)
    }
}
