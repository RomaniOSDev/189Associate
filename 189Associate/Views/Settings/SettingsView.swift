import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    init(viewModel: SettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: AppDesign.sectionSpacing) {
                    VStack(spacing: 0) {
                        SettingsRowCell(
                            icon: "speaker.wave.2.fill",
                            title: "Sound Effects",
                            isOn: $viewModel.soundEnabled
                        )
                        Divider().background(Color.white.opacity(0.08)).padding(.horizontal, 16)
                        SettingsRowCell(
                            icon: "iphone.radiowaves.left.and.right",
                            title: "Haptic Feedback",
                            isOn: $viewModel.hapticEnabled
                        )
                    }
                    .glassCard(elevation: .floating)

                    VStack(alignment: .leading, spacing: AppDesign.itemSpacing) {
                        SectionHeaderView(title: "About")
                        ActionCell(
                            icon: "⭐️",
                            title: "Rate Us",
                            subtitle: "Enjoying the game?",
                            action: viewModel.rateApp
                        )
                        ActionCell(
                            icon: AppLink.privacyPolicy.icon,
                            title: AppLink.privacyPolicy.title,
                            action: { viewModel.openLink(.privacyPolicy) }
                        )
                        ActionCell(
                            icon: AppLink.termsOfService.icon,
                            title: AppLink.termsOfService.title,
                            action: { viewModel.openLink(.termsOfService) }
                        )
                    }

                    VStack(alignment: .leading, spacing: AppDesign.itemSpacing) {
                        SectionHeaderView(title: "Data")
                        DestructiveActionCell(
                            icon: "trash.fill",
                            title: "Reset All Data",
                            action: { viewModel.showResetAlert = true }
                        )
                        Text("Deletes game history, decks, progress, and titles.")
                            .font(.caption)
                            .foregroundColor(.appTextSecondary)
                    }
                }
                .padding(AppDesign.horizontalPadding)
                .padding(.vertical, 8)
            }
        }
        .appNavigationBar(title: "Settings", onBack: viewModel.goBack)
        .onChange(of: viewModel.soundEnabled) { _, _ in viewModel.saveSettings() }
        .onChange(of: viewModel.hapticEnabled) { _, _ in viewModel.saveSettings() }
        .alert("Reset All Data?", isPresented: $viewModel.showResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) { viewModel.resetAllData() }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}
