import SwiftUI
import Combine

@MainActor
final class LeaderboardViewModel: ObservableObject {
    @Published var entries: [LeaderboardEntry] = []
    @Published var bestEntry: LeaderboardEntry?

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator

    init(storageService: StorageServiceProtocol, coordinator: AppCoordinator) {
        self.storageService = storageService
        self.coordinator = coordinator
        loadEntries()
    }

    func loadEntries() {
        let history: [GameSession] = storageService.load(forKey: StorageKeys.gameHistory)
        var entryMap: [String: LeaderboardEntry] = [:]

        for session in history {
            let key = "\(session.word.text)_\(session.startDate.timeIntervalSince1970)"
            if let existing = entryMap[key] {
                if session.totalScore > existing.score {
                    var updated = existing
                    updated.score = session.totalScore
                    updated.date = session.endDate ?? Date()
                    entryMap[key] = updated
                }
            } else {
                let entry = LeaderboardEntry(
                    id: UUID(),
                    playerName: "Player",
                    score: session.totalScore,
                    totalWords: 1,
                    maxCombo: session.userAssociations.filter { $0.isCorrect ?? false }.count,
                    date: session.endDate ?? Date()
                )
                entryMap[key] = entry
            }
        }

        entries = Array(entryMap.values).sorted { $0.score > $1.score }
        bestEntry = entries.first
    }

    func goBack() {
        coordinator.pop()
    }
}
