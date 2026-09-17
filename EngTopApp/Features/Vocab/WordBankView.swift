import SwiftUI

/// 课标词汇库：小学+初中重点词汇精选 500 词，按首字母分节。
/// 点词条读单词，点例句旁喇叭读例句；发音走全局 SpeechPlayer，与听力/复习等模块互斥。
struct WordBankView: View {
    @State private var query = ""
    @State private var stage: Int?
    @State private var playingWord: String?
    @ObservedObject private var player = SpeechPlayer.shared

    private var filtered: [WordBankEntry] { WordBank.entries(stage: stage, query: query) }

    var body: some View {
        Group {
            if WordBank.all.isEmpty {
                ContentUnavailableViewCompat(
                    title: "词库未载入",
                    systemImage: "exclamationmark.triangle",
                    description: "WordBank.json 资源缺失。")
            } else {
                list
            }
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("重点词汇 500")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query, prompt: "搜索单词或释义")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("全部学段") { stage = nil }
                    ForEach(1...2, id: \.self) { s in
                        Button(["", "小学", "初中"][s]) { stage = s }
                    }
                } label: { Image(systemName: "line.3.horizontal.decrease.circle") }
            }
        }
        .onChange(of: player.isPlaying) { playing in
            if !playing { playingWord = nil }
        }
    }

    private var list: some View {
        List {
            ForEach(WordBank.letterIndex(filtered), id: \.letter) { group in
                Section(group.letter) {
                    ForEach(group.items) { entry in
                        row(entry)
                    }
                }
            }
            Section {
                WordPulsePromoCard()
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func row(_ entry: WordBankEntry) -> some View {
        let isPlaying = playingWord == entry.word && player.isPlaying
        return Button {
            playingWord = entry.word
            player.speak(entry.word)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(entry.word).font(AppFont.cardTitle).foregroundColor(.primary)
                    if !entry.phonetic.isEmpty {
                        Text("/\(entry.phonetic)/").font(AppFont.caption).foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    Spacer(minLength: 0)
                    TagChip(text: entry.stageTitle, color: stageColor(entry.stage))
                    Image(systemName: isPlaying ? "waveform" : "speaker.wave.fill")
                        .font(AppFont.subhead)
                        .foregroundColor(isPlaying ? .apexEmerald : .apexStarBlue)
                }
                Text(entry.meaning).font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
                if entry.hasExample {
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        VStack(alignment: .leading, spacing: 1) {
                            Text(entry.example).font(AppFont.caption).italic().foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(entry.exampleMeaning).font(AppFont.chip).foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer(minLength: 0)
                        PronounceButton(text: entry.example, fontSize: 13)
                    }
                    .padding(.top, 2)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("朗读：\(entry.word)")
    }

    private func stageColor(_ stage: Int) -> Color {
        stage == 1 ? .apexEmerald : .apexStarBlue
    }
}
