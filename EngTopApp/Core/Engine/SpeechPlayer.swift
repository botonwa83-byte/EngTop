import AVFoundation

/// 全局发音引擎：用系统离线语音合成（AVSpeechSynthesizer）发声，零音频资源、零 API。
/// 两条入口：play(_:) 朗读听力材料（按 "W:"/"M:" 说话人切句换声）；speak(_:) 即点即读单词/例句/句式。
/// 所有模块（听力、词汇、复习、高频狙击、图鉴）都汇聚到这个单例，互斥播放，逻辑自洽。
final class SpeechPlayer: NSObject, ObservableObject {
    static let shared = SpeechPlayer()

    @Published private(set) var isPlaying = false

    private let synthesizer = AVSpeechSynthesizer()
    private lazy var womanVoice = Self.voice(gender: .female)
    private lazy var manVoice = Self.voice(gender: .male)
    private var pendingCount = 0

    private override init() {
        super.init()
        synthesizer.delegate = self
        try? AVAudioSession.sharedInstance().setCategory(.playback)
    }

    /// 一句台词：speaker 为 "W"/"M"，独白材料无说话人标签时为 nil。
    private struct Line {
        let speaker: Character?
        let text: String
    }

    func play(_ script: String) {
        stop()
        let lines = Self.parseLines(script)
        guard !lines.isEmpty else { return }
        pendingCount = lines.count
        isPlaying = true
        for line in lines {
            let utterance = AVSpeechUtterance(string: line.text)
            utterance.voice = voice(for: line.speaker)
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.92
            synthesizer.speak(utterance)
        }
    }

    /// 单词 / 例句 / 句式的即点即读。与 play(_:) 共用同一合成器：开口前先停掉正在播的内容，
    /// 全局同一时间只有一路声音（听力、词汇、复习、高频狙击四处都汇聚到这一个出口）。
    /// - Parameters:
    ///   - text: 待朗读的英文文本
    ///   - rate: 语速；单词用默认语速更清晰，长句可传 0.92 倍默认语速
    func speak(_ text: String, rate: Float = AVSpeechUtteranceDefaultSpeechRate) {
        stop()
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        pendingCount = 1
        isPlaying = true
        let utterance = AVSpeechUtterance(string: trimmed)
        utterance.voice = womanVoice ?? AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = rate
        synthesizer.speak(utterance)
    }

    /// 带中文注释的英文文本只读英文部分：高频考点的例证常为"英文 → 中文解析"格式，
    /// 按 "→"（或全角"→"）截断，避免英文语音引擎读出中文。
    static func englishPrefix(of text: String) -> String {
        for marker in ["→", "->"] {
            if let range = text.range(of: marker) {
                return String(text[..<range.lowerBound])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return text
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        pendingCount = 0
        isPlaying = false
    }

    private func voice(for speaker: Character?) -> AVSpeechSynthesisVoice? {
        switch speaker {
        case "M": return manVoice ?? womanVoice
        default:  return womanVoice
        }
    }

    /// 按 "W: "/"M: " 切分台词；标签本身从待朗读文本里剥离，独白材料(无标签)整段作为一句。
    private static func parseLines(_ script: String) -> [Line] {
        guard let regex = try? NSRegularExpression(pattern: #"\b([WM]):\s*"#) else {
            return [Line(speaker: nil, text: script)]
        }
        let ns = script as NSString
        let matches = regex.matches(in: script, range: NSRange(location: 0, length: ns.length))
        guard !matches.isEmpty else { return [Line(speaker: nil, text: script)] }

        var lines: [Line] = []
        for (i, match) in matches.enumerated() {
            let speaker = Character(ns.substring(with: match.range(at: 1)))
            let textStart = match.range.location + match.range.length
            let textEnd = i + 1 < matches.count ? matches[i + 1].range.location : ns.length
            let text = ns.substring(with: NSRange(location: textStart, length: textEnd - textStart))
                .trimmingCharacters(in: .whitespacesAndNewlines)
            if !text.isEmpty { lines.append(Line(speaker: speaker, text: text)) }
        }
        return lines
    }

    private static func voice(gender: AVSpeechSynthesisVoiceGender) -> AVSpeechSynthesisVoice? {
        AVSpeechSynthesisVoice.speechVoices()
            .first { $0.language.hasPrefix("en") && $0.gender == gender }
            ?? AVSpeechSynthesisVoice(language: "en-US")
    }
}

extension SpeechPlayer: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        utteranceDidEnd()
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        utteranceDidEnd()
    }

    private func utteranceDidEnd() {
        pendingCount = max(0, pendingCount - 1)
        if pendingCount == 0 { isPlaying = false }
    }
}
