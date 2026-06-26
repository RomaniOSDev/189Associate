import SwiftUI
import Combine

@MainActor
final class ModeSelectViewModel: ObservableObject {
    private let coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    let modes: [GameMode] = [.classic, .chain, .creative, .practice, .duel]

    func selectMode(_ mode: GameMode) {
        let config = GameLaunchConfig(mode: mode)
        if mode == .duel {
            coordinator.navigateToDuelSetup(config: config)
        } else {
            coordinator.navigateToCategorySelect(config: config)
        }
    }

    func goBack() {
        coordinator.pop()
    }
}
