import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: AppDesign.sectionSpacing) {
                    HomeHeroBanner(
                        greeting: viewModel.greeting,
                        activeTitle: viewModel.activeTitle,
                        titleIcon: viewModel.activeTitleIcon,
                        onStart: viewModel.startGame
                    )

                    HomeStatsRow(
                        streak: viewModel.currentStreak,
                        gamesPlayed: viewModel.totalGamesPlayed,
                        accuracy: viewModel.accuracy,
                        bestScore: viewModel.bestScore,
                        titlesEarned: viewModel.titlesEarned
                    )

                    HomeQuickPlaySection(
                        modes: viewModel.quickPlayModes,
                        onSelect: viewModel.quickStart
                    )

                    HStack(alignment: .top, spacing: AppDesign.itemSpacing) {
                        HomeDailyWidget(
                            isCompleted: viewModel.dailyCompleted,
                            categoryIcon: viewModel.dailyCategoryIcon,
                            categoryName: viewModel.dailyCategoryName,
                            action: viewModel.startDailyChallenge
                        )

                        HomeProgressWidget(
                            strongestCategoryIcon: viewModel.strongestCategoryIcon,
                            strongestCategoryName: viewModel.strongestCategoryName,
                            action: viewModel.goToProgress
                        )
                    }

                    HomeTipWidget(
                        tip: viewModel.tipOfTheDay,
                        action: viewModel.goToTips
                    )

                    exploreSection
                }
                .padding(.horizontal, AppDesign.horizontalPadding)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
        }
        .appScreen()
        .onAppear { viewModel.loadData() }
    }

    private var exploreSection: some View {
        VStack(alignment: .leading, spacing: AppDesign.itemSpacing) {
            SectionHeaderView(title: "Explore", subtitle: "Decks, themes & more")

            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: AppDesign.itemSpacing
            ) {
                HomeExploreTile(
                    imageName: HomeImageAsset.widgetProgress,
                    icon: "📊",
                    title: "Progress",
                    subtitle: "Stats & streaks",
                    action: viewModel.goToProgress
                )
                HomeExploreTile(
                    imageName: nil,
                    icon: "📚",
                    title: "My Decks",
                    subtitle: "Custom words",
                    action: viewModel.goToMyDecks
                )
                HomeExploreTile(
                    imageName: HomeImageAsset.modeImage(.creative),
                    icon: "💡",
                    title: "Tips",
                    subtitle: "How to play",
                    action: viewModel.goToTips
                )
                HomeExploreTile(
                    imageName: nil,
                    icon: "🎨",
                    title: "Themes",
                    subtitle: "Unlock styles",
                    action: viewModel.goToThemes
                )
                HomeExploreTile(
                    imageName: HomeImageAsset.modeImage(.classic),
                    icon: "👑",
                    title: "Records",
                    subtitle: "Best scores",
                    action: viewModel.goToLeaderboard
                )
                HomeExploreTile(
                    imageName: nil,
                    icon: "⚙️",
                    title: "Settings",
                    subtitle: "Preferences",
                    action: viewModel.goToSettings
                )
            }
        }
    }
}
