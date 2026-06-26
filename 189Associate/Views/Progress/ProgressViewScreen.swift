import SwiftUI

struct ProgressViewScreen: View {
    @StateObject private var viewModel: ProgressViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    init(viewModel: ProgressViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: AppDesign.sectionSpacing) {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: AppDesign.itemSpacing
                    ) {
                        InsightStatCell(
                            title: "Streak",
                            value: "🔥 \(viewModel.progress.currentStreak)",
                            detail: "Best: \(viewModel.progress.longestStreak) days",
                            accent: viewModel.progress.currentStreak >= 3
                        )
                        InsightStatCell(
                            title: "Accuracy",
                            value: "\(Int(viewModel.averageAccuracy))%",
                            detail: "Across all modes"
                        )
                        InsightStatCell(
                            title: "Games",
                            value: "\(viewModel.progress.totalGamesPlayed)",
                            detail: "Total sessions"
                        )
                        InsightStatCell(
                            title: "Associations",
                            value: "\(viewModel.progress.totalCorrectAssociations)/\(viewModel.progress.totalAssociations)",
                            detail: "Correct / total"
                        )
                    }

                    if let strongest = viewModel.strongest {
                        InsightStatCell(
                            title: "Strongest Category",
                            value: "\(strongest.category.icon) \(strongest.category.displayName)",
                            detail: "Avg score \(Int(strongest.averageScore))",
                            accent: true
                        )
                    }

                    if let weakest = viewModel.weakest {
                        InsightStatCell(
                            title: "Needs Practice",
                            value: "\(weakest.category.icon) \(weakest.category.displayName)",
                            detail: "Avg score \(Int(weakest.averageScore))"
                        )
                    }

                    VStack(alignment: .leading, spacing: AppDesign.itemSpacing) {
                        SectionHeaderView(title: "Earned Titles")
                        ForEach(viewModel.earnedTitles) { title in
                            TitleBadgeCell(title: title)
                        }
                    }

                    creativeSection
                }
                .padding(AppDesign.horizontalPadding)
                .padding(.vertical, 8)
            }
        }
        .appNavigationBar(title: "Progress", onBack: viewModel.goBack)
    }

    @ViewBuilder
    private var creativeSection: some View {
        if !viewModel.progress.creativeHighlights.isEmpty {
            VStack(alignment: .leading, spacing: AppDesign.itemSpacing) {
                SectionHeaderView(title: "Most Creative Answers")
                ForEach(viewModel.progress.creativeHighlights.prefix(5)) { highlight in
                    CreativeHighlightCell(
                        text: highlight.text,
                        word: highlight.word,
                        score: highlight.score
                    )
                }
            }
        }
    }
}
