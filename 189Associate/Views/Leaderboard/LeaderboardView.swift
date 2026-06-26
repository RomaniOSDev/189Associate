import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel: LeaderboardViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    init(viewModel: LeaderboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            if viewModel.entries.isEmpty {
                EmptyStateView(
                    icon: "🏆",
                    title: "No Records Yet",
                    message: "Play a game to see your scores here.",
                    buttonTitle: "Go Back",
                    action: viewModel.goBack
                )
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppDesign.sectionSpacing) {
                        if let best = viewModel.bestEntry {
                            HeroScoreCard(
                                emoji: "👑",
                                title: "Best Score",
                                score: "\(best.score)",
                                subtitle: "\(best.totalWords) words • \(best.maxCombo) correct",
                                detail: formattedDate(best.date)
                            )
                        }

                        VStack(alignment: .leading, spacing: AppDesign.itemSpacing) {
                            SectionHeaderView(
                                title: "All Results",
                                trailing: "\(viewModel.entries.count)"
                            )
                            ForEach(Array(viewModel.entries.enumerated()), id: \.element.id) { index, entry in
                                LeaderboardCell(
                                    rank: index + 1,
                                    name: entry.playerName,
                                    subtitle: "\(entry.totalWords) words played",
                                    score: entry.score,
                                    comboText: "\(entry.maxCombo) correct",
                                    isBest: index == 0
                                )
                            }
                        }
                    }
                    .padding(AppDesign.horizontalPadding)
                    .padding(.vertical, 8)
                }
            }
        }
        .appNavigationBar(title: "Records", onBack: viewModel.goBack)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
}
