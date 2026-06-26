import SwiftUI

struct CategorySelectView: View {
    @StateObject private var viewModel: CategorySelectViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    init(viewModel: CategorySelectViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppDesign.sectionSpacing) {
                    HStack(spacing: 10) {
                        Text(viewModel.mode.icon)
                            .font(.title)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(viewModel.mode.displayName)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(viewModel.mode.subtitle)
                                .font(.caption)
                                .foregroundColor(.appTextSecondary)
                        }
                    }
                    .padding(AppDesign.cellPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassCard(accentGlow: true)

                    if viewModel.mode != .daily {
                        VStack(alignment: .leading, spacing: AppDesign.itemSpacing) {
                            SectionHeaderView(title: "Difficulty")
                            HStack(spacing: AppDesign.itemSpacing) {
                                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                                    DifficultyCell(
                                        difficulty: difficulty,
                                        isSelected: viewModel.selectedDifficulty == difficulty
                                    ) {
                                        viewModel.selectedDifficulty = difficulty
                                    }
                                }
                            }
                        }
                    }

                    if !viewModel.decks.isEmpty {
                        VStack(alignment: .leading, spacing: AppDesign.itemSpacing) {
                            SectionHeaderView(
                                title: "My Decks",
                                trailing: "\(viewModel.decks.count)"
                            )
                            ForEach(viewModel.decks) { deck in
                                ActionCell(
                                    icon: deck.icon,
                                    title: deck.name,
                                    subtitle: "\(deck.words.count) words",
                                    showChevron: false,
                                    action: { viewModel.selectDeck(deck) }
                                )
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: AppDesign.itemSpacing) {
                        SectionHeaderView(
                            title: "Categories",
                            subtitle: "Tap to start instantly"
                        )
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: AppDesign.itemSpacing
                        ) {
                            ForEach(Category.playableCategories, id: \.self) { category in
                                CategoryGridCell(
                                    category: category,
                                    isSelected: viewModel.selectedCategory == category
                                ) {
                                    viewModel.selectCategory(category)
                                }
                            }
                        }
                    }
                }
                .padding(AppDesign.horizontalPadding)
                .padding(.vertical, 8)
            }
        }
        .appNavigationBar(title: "Category", onBack: viewModel.goBack)
        .alert("No Words Available", isPresented: $viewModel.showNoWordsAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Try another category, deck, or difficulty level.")
        }
    }
}
