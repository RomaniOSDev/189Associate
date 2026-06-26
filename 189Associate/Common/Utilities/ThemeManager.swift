import SwiftUI
import Combine

@MainActor
final class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme

    private let progressService: ProgressService

    init(progressService: ProgressService = ProgressService()) {
        self.progressService = progressService
        let saved = UserDefaults.standard.string(forKey: StorageKeys.activeTheme) ?? AppTheme.midnight.rawValue
        currentTheme = AppTheme(rawValue: saved) ?? .midnight
    }

    var backgroundColor: Color { Color(hex: currentTheme.backgroundHex) }
    var cardColor: Color { Color(hex: currentTheme.cardHex) }
    var accentColor: Color { Color(hex: currentTheme.accentHex) }

    func apply(_ theme: AppTheme) {
        currentTheme = theme
        UserDefaults.standard.set(theme.rawValue, forKey: StorageKeys.activeTheme)
    }

    func isUnlocked(_ theme: AppTheme, progress: PlayerProgress) -> Bool {
        progress.unlockedThemeIDs.contains(theme.rawValue)
    }

    func unlockEligibleThemes(progress: inout PlayerProgress, latestScore: Int = 0) {
        for theme in AppTheme.allCases where !progress.unlockedThemeIDs.contains(theme.rawValue) {
            if shouldUnlock(theme, progress: progress, latestScore: latestScore) {
                progress.unlockedThemeIDs.append(theme.rawValue)
            }
        }
    }

    private func shouldUnlock(_ theme: AppTheme, progress: PlayerProgress, latestScore: Int) -> Bool {
        switch theme {
        case .midnight: return true
        case .ocean: return progress.totalGamesPlayed >= 5
        case .forest: return progress.currentStreak >= 3
        case .sunset: return progress.earnedTitleIDs.count >= 3
        case .neon: return latestScore >= 50 || progress.categoryStats.contains { $0.bestScore >= 50 }
        }
    }
}

private struct ThemeManagerKey: EnvironmentKey {
    static let defaultValue = ThemeManager()
}

extension EnvironmentValues {
    var themeManager: ThemeManager {
        get { self[ThemeManagerKey.self] }
        set { self[ThemeManagerKey.self] = newValue }
    }
}
