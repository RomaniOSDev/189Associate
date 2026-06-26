import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var recentScore: Int = 0
    @Published var currentStreak: Int = 0
    @Published var activeTitle: String = PlayerTitle.beginner.displayName
    @Published var activeTitleIcon: String = PlayerTitle.beginner.icon
    @Published var dailyCompleted: Bool = false
    @Published var totalGamesPlayed: Int = 0
    @Published var accuracy: Double = 0
    @Published var bestScore: Int = 0
    @Published var titlesEarned: Int = 1
    @Published var dailyCategoryIcon: String = "🌿"
    @Published var dailyCategoryName: String = "Nature"
    @Published var strongestCategoryIcon: String?
    @Published var strongestCategoryName: String?

    let quickPlayModes: [GameMode] = [.classic, .chain, .creative, .practice, .duel]

    let coordinator: AppCoordinator
    private let storageService: StorageServiceProtocol
    private let progressService: ProgressService
    private let achievementService: AchievementService
    private let dailyChallengeService: DailyChallengeService

    private let dailyTips = [
        "Say the first word that comes to mind — speed beats perfection.",
        "In Chain Mode, link each answer to your previous word.",
        "Creative Mode rewards originality. Avoid repeating yourself.",
        "Build custom decks for study topics or party games.",
        "A daily streak keeps your brain sharp — play once a day.",
        "Think about context: where would you see this word?",
        "Practice mode has no timer — perfect for learning."
    ]

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Good night"
        }
    }

    var tipOfTheDay: String {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return dailyTips[day % dailyTips.count]
    }

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.storageService = coordinator.storageService
        self.progressService = coordinator.progressService
        self.achievementService = coordinator.achievementService
        self.dailyChallengeService = coordinator.dailyChallengeService
        loadData()
    }

    func loadData() {
        let history: [GameSession] = storageService.load(forKey: StorageKeys.gameHistory)
        recentScore = history.last?.totalScore ?? 0
        bestScore = history.map(\.totalScore).max() ?? 0

        let progress = progressService.loadProgress()
        currentStreak = progress.currentStreak
        totalGamesPlayed = progress.totalGamesPlayed
        titlesEarned = progress.earnedTitleIDs.count
        accuracy = progressService.averageAccuracy()

        let title = achievementService.activeTitle()
        activeTitle = title.displayName
        activeTitleIcon = title.icon

        dailyCompleted = dailyChallengeService.isCompletedToday()
        let dailyWord = dailyChallengeService.todayWord()
        dailyCategoryIcon = dailyWord.category.icon
        dailyCategoryName = dailyWord.categoryLabel

        if let strongest = progressService.strongestCategory() {
            strongestCategoryIcon = strongest.category.icon
            strongestCategoryName = strongest.category.displayName
        } else {
            strongestCategoryIcon = nil
            strongestCategoryName = nil
        }
    }

    func startGame() { coordinator.navigateToModeSelect() }
    func startDailyChallenge() { coordinator.startDailyChallenge() }
    func quickStart(_ mode: GameMode) { coordinator.quickStart(mode: mode) }
    func goToLeaderboard() { coordinator.navigateToLeaderboard() }
    func goToSettings() { coordinator.navigateToSettings() }
    func goToProgress() { coordinator.navigateToProgress() }
    func goToMyDecks() { coordinator.navigateToMyDecks() }
    func goToTips() { coordinator.navigateToTips() }
    func goToThemes() { coordinator.navigateToThemes() }
}
