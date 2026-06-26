import SwiftUI

struct DuelResultView: View {
    let result: DuelResult
    let session1: GameSession
    let session2: GameSession
    let coordinator: AppCoordinator
    @EnvironmentObject private var themeManager: ThemeManager

    private var winner: String {
        if session1.totalScore > session2.totalScore { return result.player1Name }
        if session2.totalScore > session1.totalScore { return result.player2Name }
        return "Tie"
    }

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: AppDesign.sectionSpacing) {
                    VStack(spacing: 8) {
                        Text("⚔️").font(.system(size: 56))
                        Text("Duel Results")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Word: \(result.word.text)")
                            .font(.subheadline)
                            .foregroundColor(.appTextSecondary)
                    }

                    HStack(spacing: AppDesign.itemSpacing) {
                        DuelScoreCard(
                            name: result.player1Name,
                            score: session1.totalScore,
                            combo: session1.maxCombo,
                            isWinner: session1.totalScore > session2.totalScore
                        )
                        DuelScoreCard(
                            name: result.player2Name,
                            score: session2.totalScore,
                            combo: session2.maxCombo,
                            isWinner: session2.totalScore > session1.totalScore
                        )
                    }

                    Text(winner == "Tie" ? "🤝 It's a tie!" : "🏆 \(winner) wins!")
                        .font(.headline)
                        .foregroundColor(winner == "Tie" ? .yellow : themeManager.accentColor)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .glassCard(isSelected: winner != "Tie")

                    VStack(spacing: AppDesign.itemSpacing) {
                        AnimatedButton(title: "Play Again", icon: "🔄") {
                            coordinator.popToRoot()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                coordinator.navigateToModeSelect()
                            }
                        }
                        SecondaryButton(title: "Home", icon: "🏠") {
                            coordinator.popToRoot()
                        }
                    }
                }
                .padding(AppDesign.horizontalPadding)
                .padding(.vertical, 8)
            }
        }
        .appNavigationBar(title: "Duel Results")
    }
}

struct DuelScoreCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let name: String
    let score: Int
    let combo: Int
    let isWinner: Bool

    var body: some View {
        VStack(spacing: 10) {
            if isWinner {
                Text("👑")
                    .font(.caption)
            }
            Text(name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text("\(score)")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(isWinner ? themeManager.accentColor : .white)
            Label("\(combo) combo", systemImage: "flame.fill")
                .font(.caption2)
                .foregroundColor(.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .glassCard(isSelected: isWinner, accentGlow: isWinner)
    }
}
