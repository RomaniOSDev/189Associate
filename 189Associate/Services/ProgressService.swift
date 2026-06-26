import Foundation

final class ProgressService {
    private let storageService: StorageServiceProtocol

    init(storageService: StorageServiceProtocol = UserDefaultsStorageService()) {
        self.storageService = storageService
    }

    func loadProgress() -> PlayerProgress {
        let items: [PlayerProgress] = storageService.load(forKey: StorageKeys.playerProgress)
        return items.first ?? .empty
    }

    func saveProgress(_ progress: PlayerProgress) {
        storageService.save([progress], forKey: StorageKeys.playerProgress)
    }

    func recordSession(_ session: GameSession) {
        var progress = loadProgress()
        progress.totalGamesPlayed += 1
        progress.totalAssociations += session.userAssociations.count
        progress.totalCorrectAssociations += session.userAssociations.filter { $0.isCorrect == true }.count
        updateStreak(&progress)
        updateCategoryStats(&progress, session: session)
        updateCreativeHighlights(&progress, session: session)
        saveProgress(progress)
    }

    func averageAccuracy() -> Double {
        let progress = loadProgress()
        guard progress.totalAssociations > 0 else { return 0 }
        return Double(progress.totalCorrectAssociations) / Double(progress.totalAssociations) * 100
    }

    func strongestCategory() -> CategoryStats? {
        loadProgress().categoryStats.max(by: { $0.averageScore < $1.averageScore })
    }

    func weakestCategory() -> CategoryStats? {
        let stats = loadProgress().categoryStats.filter { $0.totalGames > 0 }
        return stats.min(by: { $0.averageScore < $1.averageScore })
    }

    private func updateStreak(_ progress: inout PlayerProgress) {
        let today = Calendar.current.startOfDay(for: Date())
        if let last = progress.lastPlayDate {
            let lastDay = Calendar.current.startOfDay(for: last)
            let diff = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if diff == 0 {
                // same day
            } else if diff == 1 {
                progress.currentStreak += 1
            } else {
                progress.currentStreak = 1
            }
        } else {
            progress.currentStreak = 1
        }
        progress.lastPlayDate = Date()
        progress.longestStreak = max(progress.longestStreak, progress.currentStreak)
    }

    private func updateCategoryStats(_ progress: inout PlayerProgress, session: GameSession) {
        let category = session.word.category
        let correct = session.userAssociations.filter { $0.isCorrect == true }.count
        let score = session.totalScore

        if let index = progress.categoryStats.firstIndex(where: { $0.category == category }) {
            var stat = progress.categoryStats[index]
            stat.totalGames += 1
            stat.totalScore += score
            stat.bestScore = max(stat.bestScore, score)
            stat.averageScore = Double(stat.totalScore) / Double(stat.totalGames)
            progress.categoryStats[index] = stat
        } else {
            progress.categoryStats.append(CategoryStats(
                category: category,
                totalGames: 1,
                totalScore: score,
                bestScore: score,
                averageScore: Double(score)
            ))
        }

        _ = correct
    }

    private func updateCreativeHighlights(_ progress: inout PlayerProgress, session: GameSession) {
        guard session.gameMode == .creative else { return }
        let top = session.userAssociations
            .filter { $0.points >= 10 }
            .sorted { $0.points > $1.points }
            .prefix(2)
        for association in top {
            let highlight = CreativeHighlight(
                id: UUID(),
                text: association.text,
                word: session.word.text,
                mode: session.gameMode,
                score: association.points,
                date: Date()
            )
            progress.creativeHighlights.insert(highlight, at: 0)
        }
        if progress.creativeHighlights.count > 20 {
            progress.creativeHighlights = Array(progress.creativeHighlights.prefix(20))
        }
    }
}
