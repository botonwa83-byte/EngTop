import SwiftUI

/// 即点即读按钮：单词 / 例句 / 句式卡通用。
/// 与听力播放共用 SpeechPlayer 单例——点下即读、再点即换，全局同一时间只有一路声音。
struct PronounceButton: View {
    let text: String
    /// true = 只读英文部分（自动截掉 "→" 之后的中文解析），用于带注释的高频例证。
    var englishOnly = false
    var fontSize: CGFloat = 15

    @ObservedObject private var player = SpeechPlayer.shared

    var body: some View {
        Button {
            let target = englishOnly ? SpeechPlayer.englishPrefix(of: text) : text
            player.speak(target)
        } label: {
            Image(systemName: player.isPlaying ? "waveform" : "speaker.wave.fill")
                .font(.system(size: fontSize, weight: .semibold))
                .foregroundColor(.apexStarBlue)
                .frame(minWidth: 24, minHeight: 24)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("朗读：\(englishOnly ? SpeechPlayer.englishPrefix(of: text) : text)")
    }
}

/// 词条发音行：单词大字 + 发音按钮，词汇详情与图鉴共用，保证"看到词就能听到音"。
struct HeadwordPronounceRow: View {
    let headword: String

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Text(headword).font(.title2.weight(.bold))
            PronounceButton(text: headword, fontSize: 18)
            Spacer()
        }
    }
}
