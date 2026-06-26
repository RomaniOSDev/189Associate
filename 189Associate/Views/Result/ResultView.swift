import SwiftUI

struct ResultView: View {
    @StateObject private var viewModel: ResultViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var animationScale: CGFloat = 0.5

    init(viewModel: ResultViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: AppDesign.sectionSpacing) {
                    HeroScoreCard(
                        emoji: viewModel.scoreEmoji,
                        title: "Your Score",
                        score: "\(viewModel.totalScore)",
                        subtitle: "out of \(viewModel.maxScore) points",
                        detail: scoreDetail
                    )
                    .scaleEffect(animationScale)
                    .onAppear {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                            animationScale = 1.0
                        }
                    }

                    Text(viewModel.scoreMessage)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal)

                    if !viewModel.newTitles.isEmpty {
                        VStack(spacing: AppDesign.itemSpacing) {
                            SectionHeaderView(title: "New Titles")
                            ForEach(viewModel.newTitles) { title in
                                TitleBadgeCell(title: title, isNew: true)
                            }
                        }
                    }

                    MetricRowCard(metrics: [
                        ("✅", "\(viewModel.correctAssociations)", "correct", .appCorrect),
                        ("❌", "\(viewModel.session.userAssociations.count - viewModel.correctAssociations)", "wrong", .appIncorrect),
                        ("🔥", "\(viewModel.session.maxCombo)", "combo", themeManager.accentColor)
                    ])

                    expectedSection

                    VStack(spacing: AppDesign.itemSpacing) {
                        AnimatedButton(title: "Play Again", icon: "🔄", action: viewModel.playAgain)
                        SecondaryButton(title: "Home", icon: "🏠", action: viewModel.goHome)
                        SecondaryButton(title: "Records", icon: "🏆", style: .muted, action: viewModel.goToLeaderboard)
                    }
                }
                .padding(AppDesign.horizontalPadding)
                .padding(.vertical, 8)
            }
        }
        .appNavigationBar(title: "Results")
    }

    private var scoreDetail: String? {
        guard viewModel.session.gameMode != .creative else { return nil }
        return "\(Int(viewModel.percentage))% accuracy"
    }

    @ViewBuilder
    private var expectedSection: some View {
        if viewModel.session.gameMode != .creative {
            VStack(alignment: .leading, spacing: AppDesign.itemSpacing) {
                SectionHeaderView(
                    title: "Expected Associations",
                    subtitle: "Learn the connections"
                )
                ForEach(Array(viewModel.expectedAssociations.enumerated()), id: \.offset) { _, item in
                    let matched = viewModel.session.userAssociations.contains {
                        $0.text.lowercased() == item.word.lowercased() && ($0.isCorrect == true)
                    }
                    ExpectedAssociationCell(word: item.word, hint: item.hint, matched: matched)
                }
            }
        }
    }
}
