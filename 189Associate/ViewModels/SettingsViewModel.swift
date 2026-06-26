import SwiftUI
import Combine
import StoreKit
import UIKit

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var showResetAlert = false
    @Published var soundEnabled = true
    @Published var hapticEnabled = true

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator

    init(storageService: StorageServiceProtocol, coordinator: AppCoordinator) {
        self.storageService = storageService
        self.coordinator = coordinator
        loadSettings()
    }

    func loadSettings() {
        soundEnabled = UserDefaults.standard.object(forKey: StorageKeys.soundEnabled) as? Bool ?? true
        hapticEnabled = UserDefaults.standard.object(forKey: StorageKeys.hapticEnabled) as? Bool ?? true
    }

    func saveSettings() {
        UserDefaults.standard.set(soundEnabled, forKey: StorageKeys.soundEnabled)
        UserDefaults.standard.set(hapticEnabled, forKey: StorageKeys.hapticEnabled)
    }

    func resetAllData() {
        storageService.delete(forKey: StorageKeys.gameHistory)
        storageService.delete(forKey: StorageKeys.words)
        storageService.delete(forKey: StorageKeys.decks)
        storageService.delete(forKey: StorageKeys.playerProgress)
        UserDefaults.standard.removeObject(forKey: StorageKeys.duelWins)
        UserDefaults.standard.removeObject(forKey: StorageKeys.chainGamesCompleted)
        UserDefaults.standard.removeObject(forKey: StorageKeys.dailyChallengesCompleted)
        coordinator.popToRoot()
    }

    func goBack() {
        coordinator.pop()
    }

    func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }

    func openLink(_ link: AppLink) {
        if let url = link.url {
            UIApplication.shared.open(url)
        }
    }
}
