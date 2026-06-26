import Foundation

final class AchievementService {
    private let progressService: ProgressService

    init(progressService: ProgressService = ProgressService()) {
        self.progressService = progressService
    }

    func evaluate(session: GameSession, duelWon: Bool? = nil) -> [PlayerTitle] {
        var progress = progressService.loadProgress()
        var newlyEarned: [PlayerTitle] = []

        func earn(_ title: PlayerTitle) {
            guard !progress.earnedTitleIDs.contains(title.rawValue) else { return }
            progress.earnedTitleIDs.append(title.rawValue)
            newlyEarned.append(title)
        }

        if progress.totalGamesPlayed >= 1 { earn(.beginner) }

        if session.gameMode == .classic,
           session.totalScore >= 40,
           session.difficulty.timeLimit <= 20 {
            earn(.quickThinker)
        }

        let playedCategories = Set(progress.categoryStats.map(\.category))
        if playedCategories.count >= Category.playableCategories.count {
            earn(.categoryMaster)
        }

        if session.gameMode == .chain {
            let chainGames = UserDefaults.standard.integer(forKey: StorageKeys.chainGamesCompleted) + 1
            UserDefaults.standard.set(chainGames, forKey: StorageKeys.chainGamesCompleted)
            if chainGames >= 5 { earn(.chainLinker) }
        }

        if session.gameMode == .creative, session.totalScore >= 45 {
            earn(.creativeGenius)
        }

        if duelWon == true {
            let wins = UserDefaults.standard.integer(forKey: StorageKeys.duelWins) + 1
            UserDefaults.standard.set(wins, forKey: StorageKeys.duelWins)
            if wins >= 3 { earn(.duelChampion) }
        }

        if progress.currentStreak >= 7 { earn(.streakKeeper) }

        if session.isDailyChallenge {
            let daily = UserDefaults.standard.integer(forKey: StorageKeys.dailyChallengesCompleted) + 1
            UserDefaults.standard.set(daily, forKey: StorageKeys.dailyChallengesCompleted)
            if daily >= 5 { earn(.dailyWarrior) }
        }

        progressService.saveProgress(progress)
        return newlyEarned
    }

    func activeTitle() -> PlayerTitle {
        let progress = progressService.loadProgress()
        if let id = progress.activeTitleID, let title = PlayerTitle(rawValue: id) {
            return title
        }
        return .beginner
    }

    func setActiveTitle(_ title: PlayerTitle) {
        var progress = progressService.loadProgress()
        guard progress.earnedTitleIDs.contains(title.rawValue) else { return }
        progress.activeTitleID = title.rawValue
        progressService.saveProgress(progress)
    }
}
