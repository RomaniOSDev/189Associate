import SwiftUI
import Combine

@MainActor
final class ResultViewModel: ObservableObject {
    @Published var session: GameSession
    @Published var totalScore: Int
    @Published var maxScore: Int
    @Published var correctAssociations: Int
    @Published var percentage: Double
    @Published var newTitles: [PlayerTitle] = []

    private let gameEngine: GameEngine
    private let coordinator: AppCoordinator

    init(
        session: GameSession,
        gameEngine: GameEngine,
        achievementService: AchievementService,
        coordinator: AppCoordinator
    ) {
        self.session = session
        self.gameEngine = gameEngine
        self.coordinator = coordinator
        self.totalScore = session.totalScore
        self.maxScore = session.maxPossibleScore
        self.correctAssociations = session.userAssociations.filter { $0.isCorrect ?? false }.count
        self.percentage = session.maxPossibleScore > 0
            ? Double(session.totalScore) / Double(session.maxPossibleScore) * 100
            : 0
        self.newTitles = achievementService.evaluate(session: session)
    }

    var scoreEmoji: String {
        switch percentage {
        case 80...100: return "🏆"
        case 60..<80: return "🌟"
        case 40..<60: return "💪"
        default: return "📚"
        }
    }

    var scoreMessage: String {
        switch session.gameMode {
        case .creative:
            return "Original thinking! Creativity score saved."
        case .chain:
            return session.chainBreaks == 0
                ? "Perfect chain! Every link connected."
                : "Good effort! Try smoother chains next time."
        case .practice:
            return "Practice complete! Review the expected associations below."
        case .daily:
            return "Daily Challenge complete! Come back tomorrow."
        default:
            switch percentage {
            case 80...100: return "Brilliant! You're a master of associations!"
            case 60..<80: return "Great job! You think creatively!"
            case 40..<60: return "Not bad! Give it another try!"
            default: return "Practice makes perfect! Try again!"
            }
        }
    }

    var expectedAssociations: [(word: String, hint: String)] {
        zip(session.word.associations, session.word.associationHints).map { ($0, $1) }
    }

    func hint(for text: String) -> String {
        gameEngine.hint(for: text, word: session.word)
    }

    func playAgain() {
        coordinator.popToRoot()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.coordinator.navigateToModeSelect()
        }
    }

    func goHome() { coordinator.popToRoot() }
    func goToLeaderboard() {
        coordinator.popToRoot()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.coordinator.navigateToLeaderboard()
        }
    }
}
