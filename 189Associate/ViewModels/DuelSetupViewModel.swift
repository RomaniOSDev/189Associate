import SwiftUI
import Combine

@MainActor
final class DuelSetupViewModel: ObservableObject {
    @Published var player1Name = "Player 1"
    @Published var player2Name = "Player 2"

    var config: GameLaunchConfig
    private let coordinator: AppCoordinator

    init(config: GameLaunchConfig, coordinator: AppCoordinator) {
        self.config = config
        self.coordinator = coordinator
    }

    var canContinue: Bool {
        !player1Name.trimmingCharacters(in: .whitespaces).isEmpty
            && !player2Name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func continueToCategory() {
        var updated = config
        updated.duelPlayer1Name = player1Name.trimmingCharacters(in: .whitespaces)
        updated.duelPlayer2Name = player2Name.trimmingCharacters(in: .whitespaces)
        updated.duelCurrentPlayer = 1
        coordinator.updateConfig(updated)
        coordinator.navigateToCategorySelect(config: updated)
    }

    func goBack() {
        coordinator.pop()
    }
}
