import SwiftUI
import Combine

@MainActor
final class ThemesViewModel: ObservableObject {
    @Published var progress: PlayerProgress

    let themeManager: ThemeManager
    private let progressService: ProgressService
    private let coordinator: AppCoordinator

    init(
        themeManager: ThemeManager,
        progressService: ProgressService,
        coordinator: AppCoordinator
    ) {
        self.themeManager = themeManager
        self.progressService = progressService
        self.coordinator = coordinator
        self.progress = progressService.loadProgress()
    }

    func isUnlocked(_ theme: AppTheme) -> Bool {
        themeManager.isUnlocked(theme, progress: progress)
    }

    func select(_ theme: AppTheme) {
        guard isUnlocked(theme) else { return }
        themeManager.apply(theme)
    }

    func reload() {
        progress = progressService.loadProgress()
    }

    func goBack() { coordinator.pop() }
}
