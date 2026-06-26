import SwiftUI

struct ModeSelectView: View {
    @StateObject private var viewModel: ModeSelectViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    init(viewModel: ModeSelectViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppDesign.sectionSpacing) {
                    SectionHeaderView(
                        title: "Pick a Mode",
                        subtitle: "Each mode has unique rules and scoring"
                    )

                    VStack(spacing: AppDesign.itemSpacing) {
                        ForEach(viewModel.modes, id: \.self) { mode in
                            ActionCell(
                                icon: mode.icon,
                                title: mode.displayName,
                                subtitle: mode.subtitle,
                                action: { viewModel.selectMode(mode) }
                            )
                        }
                    }
                }
                .padding(AppDesign.horizontalPadding)
                .padding(.vertical, 8)
            }
        }
        .appNavigationBar(title: "Game Mode", onBack: viewModel.goBack)
    }
}
