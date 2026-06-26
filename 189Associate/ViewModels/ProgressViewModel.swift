import SwiftUI
import Combine

@MainActor
final class ProgressViewModel: ObservableObject {
    @Published var progress: PlayerProgress
    @Published var averageAccuracy: Double = 0

    private let progressService: ProgressService
    private let achievementService: AchievementService
    private let coordinator: AppCoordinator

    init(
        progressService: ProgressService,
        achievementService: AchievementService,
        coordinator: AppCoordinator
    ) {
        self.progressService = progressService
        self.achievementService = achievementService
        self.coordinator = coordinator
        self.progress = progressService.loadProgress()
        self.averageAccuracy = progressService.averageAccuracy()
    }

    var strongest: CategoryStats? { progressService.strongestCategory() }
    var weakest: CategoryStats? { progressService.weakestCategory() }

    var earnedTitles: [PlayerTitle] {
        progress.earnedTitleIDs.compactMap { PlayerTitle(rawValue: $0) }
    }

    func goBack() { coordinator.pop() }
}
