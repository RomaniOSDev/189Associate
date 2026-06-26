import SwiftUI

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @FocusState private var isInputFocused: Bool

    init(viewModel: GameViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 16) {
                WordHeroCard(
                    word: viewModel.session.word.text,
                    categoryIcon: viewModel.session.word.category.icon,
                    categoryLabel: viewModel.session.word.categoryLabel,
                    modeLabel: "\(viewModel.mode.displayName) • \(viewModel.difficulty.displayName)",
                    playerBanner: viewModel.playerBanner,
                    chainHint: viewModel.chainHint
                )

                gameMetricsBar

                AssociationInputView(
                    text: $viewModel.currentInput,
                    isDisabled: viewModel.isInputDisabled,
                    onSubmit: viewModel.submitAssociation,
                    isFocused: $isInputFocused
                )

                if viewModel.results.isEmpty {
                    Text("Type associations and tap Add")
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppDesign.itemSpacing) {
                        ForEach(Array(viewModel.results.enumerated()), id: \.offset) { index, result in
                            AssociationResultCell(
                                index: index + 1,
                                text: result.text,
                                isCorrect: result.isCorrect,
                                points: result.points,
                                feedback: result.feedback
                            )
                        }
                    }
                }
            }
            .padding(AppDesign.horizontalPadding)
            .padding(.vertical, 8)
        }
        .appNavigationBar(title: "Game", backTitle: "Exit", onBack: viewModel.goBack)
        .onAppear { isInputFocused = true }
    }

    private var gameMetricsBar: some View {
        HStack(spacing: 0) {
            if viewModel.showsTimer {
                TimerCountdownView(
                    timeLeft: viewModel.timeLeft,
                    maxTime: viewModel.difficulty.timeLimit
                )
                .frame(maxWidth: .infinity)
                metricDivider
            }

            MetricCell(
                icon: "📝",
                value: viewModel.progressText,
                label: "progress",
                valueColor: themeManager.accentColor,
                compact: true
            )
            metricDivider

            MetricCell(
                icon: "🔥",
                value: "\(viewModel.currentCombo)",
                label: "combo",
                valueColor: .appCorrect,
                compact: true
            )
            metricDivider

            MetricCell(
                icon: "⭐",
                value: "\(viewModel.totalScore)",
                label: "score",
                valueColor: .appCorrect,
                compact: true
            )
        }
        .padding(.vertical, 4)
        .glassCard(elevation: .floating)
    }

    private var metricDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.08))
            .frame(width: 1, height: 48)
    }
}
