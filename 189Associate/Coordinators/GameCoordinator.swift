import Foundation

final class GameCoordinator {
    private weak var appCoordinator: AppCoordinator?

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func finishGame(session: GameSession) {
        appCoordinator?.navigateToResult(session: session)
    }

    func exitGame() {
        appCoordinator?.pop()
    }
}
