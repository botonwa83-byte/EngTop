import SwiftUI

/// 单词详情：释义/例句/搭配 + 拼写练习 + 搭配·僻义小测。
/// 列表页统一在素材库的「词汇专项」子页（VocabLibraryView），这里只负责单个词条。
struct VocabDetailView: View {
    let word: VocabWord
    @ObservedObject private var store = VocabStore.shared

    @State private var spellingInput = ""
    @State private var spellingChecked: Bool?
    @State private var quizSelected: Int?
    @State private var quizRevealed = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header
                spellingSection
                quizSection
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle(word.headword)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                TagChip(text: word.category.title, color: word.category == .collocation ? .apexStarBlue : .apexMystery)
                Spacer()
                ReviewToggleButton(id: "v:\(word.id)")
            }
            HeadwordPronounceRow(headword: word.headword)
            Text(word.meaning).font(AppFont.body)
            HStack(alignment: .top, spacing: Spacing.sm) {
                Text(word.example).font(AppFont.body).italic().fixedSize(horizontal: false, vertical: true)
                PronounceButton(text: word.example, englishOnly: true)
            }
            Text(word.exampleMeaning).font(AppFont.caption).foregroundColor(.secondary)
            if !word.collocations.isEmpty {
                FlowLayout(spacing: 6) {
                    ForEach(word.collocations, id: \.self) { c in TagChip(text: c, color: .apexGold) }
                }
            }
            Button {
                store.toggleMastered(word.id)
            } label: {
                let mastered = store.isMastered(word.id)
                Label(mastered ? "已掌握" : "标记已掌握", systemImage: mastered ? "checkmark.seal.fill" : "seal")
                    .font(AppFont.chip).foregroundColor(mastered ? .apexEmerald : .secondary)
            }.buttonStyle(.plain)
        }
        .cardSurface()
    }

    private var spellingSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "拼写练习", systemImage: "pencil", accent: .apexStarBlue)
            Text("根据释义拼出单词：\(word.meaning)").font(AppFont.caption).foregroundColor(.secondary)
            TextField("拼写……", text: $spellingInput)
                .textFieldStyle(.roundedBorder).autocorrectionDisabled().textInputAutocapitalization(.never)
                .onSubmit { checkSpelling() }
            Button { checkSpelling() } label: {
                Text("检查拼写").font(AppFont.cardTitle).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding(Spacing.md)
                    .background(spellingInput.trimmingCharacters(in: .whitespaces).isEmpty ? Color.secondary : Color.apexStarBlue)
                    .cornerRadius(Radius.inner)
            }.disabled(spellingInput.trimmingCharacters(in: .whitespaces).isEmpty)
            if let ok = spellingChecked {
                HStack(spacing: Spacing.sm) {
                    Label(ok ? "拼写正确！" : "正确拼写是：\(word.headword)", systemImage: ok ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(ok ? .apexEmerald : .apexDanger).font(AppFont.body)
                    if !ok { PronounceButton(text: word.headword) }
                }
            }
        }
        .cardSurface()
    }

    private var quizSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: word.category == .collocation ? "搭配小测" : "僻义小测",
                          systemImage: "questionmark.circle", accent: .apexMystery)
            Text(word.quizStem).font(.body).fixedSize(horizontal: false, vertical: true)
            ForEach(Array(word.quizOptions.enumerated()), id: \.offset) { i, opt in
                quizOptionRow(i: i, text: opt)
            }
            if quizRevealed {
                Text(word.quizExplanation).font(AppFont.caption).foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true).padding(.top, 4)
            }
        }
        .cardSurface()
    }

    private func quizOptionRow(i: Int, text: String) -> some View {
        let isAnswer = i == word.quizAnswer
        let isPicked = quizSelected == i
        let bg: Color = {
            guard quizRevealed else { return isPicked ? Color.apexStarBlue.opacity(0.15) : Color.apexCardSurface }
            if isAnswer { return Color.apexEmerald.opacity(0.2) }
            if isPicked { return Color.apexDanger.opacity(0.2) }
            return Color.apexCardSurface
        }()
        return Button {
            guard !quizRevealed else { return }
            quizSelected = i; quizRevealed = true
            store.recordQuiz(word, correct: i == word.quizAnswer)
        } label: {
            HStack {
                Text(text).font(AppFont.body).multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                if quizRevealed && isAnswer { Image(systemName: "checkmark.circle.fill").foregroundColor(.apexEmerald) }
                if quizRevealed && isPicked && !isAnswer { Image(systemName: "xmark.circle.fill").foregroundColor(.apexDanger) }
            }
            .padding(Spacing.md).frame(maxWidth: .infinity, alignment: .leading)
            .background(bg).cornerRadius(Radius.inner)
        }.buttonStyle(.plain)
    }

    private func checkSpelling() {
        let ok = spellingInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == word.headword.lowercased()
        spellingChecked = ok
        store.recordSpelling(word, correct: ok)
    }
}
