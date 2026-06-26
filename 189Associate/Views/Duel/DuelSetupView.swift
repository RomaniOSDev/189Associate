import SwiftUI

struct DuelSetupView: View {
    @StateObject private var viewModel: DuelSetupViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    init(viewModel: DuelSetupViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: AppDesign.sectionSpacing) {
                    VStack(spacing: 12) {
                        Text("⚔️")
                            .font(.system(size: 56))
                        Text("Pass & Play")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Two players compete on one device with the same word.")
                            .font(.subheadline)
                            .foregroundColor(.appTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 16)

                    VStack(alignment: .leading, spacing: AppDesign.itemSpacing) {
                        SectionHeaderView(title: "Players")
                        AppTextField(
                            placeholder: "Player 1 name",
                            text: $viewModel.player1Name,
                            icon: "person.fill"
                        )
                        AppTextField(
                            placeholder: "Player 2 name",
                            text: $viewModel.player2Name,
                            icon: "person.fill"
                        )
                    }

                    AnimatedButton(
                        title: "Choose Category",
                        icon: "🚀",
                        isEnabled: viewModel.canContinue,
                        action: viewModel.continueToCategory
                    )
                }
                .padding(AppDesign.horizontalPadding)
            }
        }
        .appNavigationBar(title: "Duel Setup", onBack: viewModel.goBack)
    }
}
