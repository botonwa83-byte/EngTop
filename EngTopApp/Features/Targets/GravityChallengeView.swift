import SwiftUI

struct GravityChallengeView: View {
    @EnvironmentObject var store: EngStore
    @Environment(\.dismiss) private var dismiss
    private let challenges = [["I", "play", "basketball", "after", "school"], ["She", "is", "reading", "a", "book"], ["We", "went", "to", "the", "park", "yesterday"]]
    @State private var round = 0
    @State private var tokens: [String]
    @State private var answer: [String] = []
    @State private var message = "点击词块，把句子排好"
    @State private var solved = false

    private var solution: [String] { challenges[round] }

    init() { _tokens = State(initialValue: ["I", "play", "basketball", "after", "school"].shuffled()) }

    var body: some View {
        VStack(spacing: Spacing.xl) {
            HStack {
                Label("句子重力场", systemImage: "arrow.up.and.down.and.arrow.left.and.right")
                    .font(AppFont.cardTitle).foregroundColor(.apexLava)
                Spacer()
                Text("语序训练").font(AppFont.caption).foregroundColor(.secondary)
            }
            .padding(.horizontal, Spacing.lg)
            HStack(spacing: 8) {
                ForEach(0..<challenges.count, id: \.self) { index in
                    Capsule().fill(index <= round && solved ? Color.apexLava : Color.apexCardSurface)
                        .frame(maxWidth: .infinity).frame(height: 8)
                }
                Text("连击 \(store.abilityProfile.combo)").font(AppFont.caption).foregroundColor(.apexGold)
            }
            .padding(.horizontal, Spacing.lg)
            VStack(alignment: .leading, spacing: Spacing.md) {
                Text("让词块回到正确轨道").font(AppFont.sectionTitle)
                Text("第 \(round + 1)/\(challenges.count) 句 · 先找主语，再找动作。").font(AppFont.body).foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.lg)
            HStack(spacing: 8) {
                ForEach(answer, id: \.self) { token in
                    Text(token).font(AppFont.body).padding(.horizontal, 12).padding(.vertical, 10)
                        .background(Color.apexStarBlue.opacity(0.16)).cornerRadius(Radius.inner)
                }
            }
            .frame(minHeight: 56).frame(maxWidth: .infinity)
            .cardSurface(padding: Spacing.md)
            VStack(spacing: Spacing.sm) {
                ForEach(tokens, id: \.self) { token in
                    Button {
                        guard !solved else { return }
                        answer.append(token); tokens.removeAll { $0 == token }
                        if answer.count == solution.count { check() }
                    } label: {
                        Text(token).font(AppFont.cardTitle).frame(maxWidth: .infinity).padding(Spacing.md)
                            .background(Color.apexCardSurface).cornerRadius(Radius.inner)
                    }.buttonStyle(.plain)
                }
            }.padding(.horizontal, Spacing.lg)
            Text(message).font(AppFont.body).foregroundColor(solved ? .apexEmerald : .secondary)
            if solved || message.hasPrefix("再观察") {
                Button(message.hasPrefix("再观察") ? "再试一次" : (round == challenges.count - 1 ? "重新挑战" : "下一句")) {
                    message.hasPrefix("再观察") ? retry() : reset()
                }
                    .font(AppFont.cardTitle).foregroundColor(.white)
                    .padding(.horizontal, Spacing.page).padding(.vertical, Spacing.md)
                    .background(Color.apexLava).cornerRadius(Radius.inner)
            }
            Spacer()
        }
        .padding(.top, Spacing.lg)
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("今日挑战")
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("完成") { dismiss() } } }
    }

    private func check() {
        solved = true
        if answer == solution {
            message = "句子能量已点亮！+12 XP"
            store.recordAbilityChallenge(.correct, ability: .wordOrder)
        } else {
            message = "再观察一下：谁在做什么？"
            store.recordAbilityChallenge(.wrong, ability: .wordOrder)
            solved = false
        }
    }

    private func retry() {
        answer = []; tokens = solution.shuffled(); message = "点击词块，把句子排好"
    }

    private func reset() {
        round = round == challenges.count - 1 ? 0 : round + 1
        answer = []; tokens = solution.shuffled(); solved = false; message = "点击词块，把句子排好"
    }
}
