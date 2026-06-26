import SwiftUI

struct ThemesView: View {
    @StateObject private var viewModel: ThemesViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    init(viewModel: ThemesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppDesign.sectionSpacing) {
                    SectionHeaderView(
                        title: "App Themes",
                        subtitle: "Unlock by playing and earning titles"
                    )

                    VStack(spacing: AppDesign.itemSpacing) {
                        ForEach(AppTheme.allCases) { theme in
                            ThemePreviewCell(
                                theme: theme,
                                isUnlocked: viewModel.isUnlocked(theme),
                                isSelected: themeManager.currentTheme == theme
                            ) {
                                viewModel.select(theme)
                            }
                        }
                    }
                }
                .padding(AppDesign.horizontalPadding)
                .padding(.vertical, 8)
            }
        }
        .appNavigationBar(title: "Themes", onBack: viewModel.goBack)
        .onAppear { viewModel.reload() }
    }
}
