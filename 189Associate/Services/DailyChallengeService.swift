import Foundation

final class DailyChallengeService {
    private let wordService: WordService
    private let storageService: StorageServiceProtocol

    init(
        wordService: WordService,
        storageService: StorageServiceProtocol = UserDefaultsStorageService()
    ) {
        self.wordService = wordService
        self.storageService = storageService
    }

    func todayWord() -> Word {
        let words = wordService.getWords()
        guard !words.isEmpty else {
            return wordService.getDefaultWords().first!
        }
        let seed = daySeed()
        var generator = SeededRandomNumberGenerator(seed: seed)
        return words.shuffled(using: &generator).first ?? words[0]
    }

    func isCompletedToday() -> Bool {
        let progress = loadProgressDirect() ?? .empty
        guard let date = progress.dailyChallengeLastCompleted else { return false }
        return date.isSameDay(as: Date())
    }

    func markCompleted() {
        var progress = loadProgressDirect() ?? .empty
        progress.dailyChallengeLastCompleted = Date()
        saveProgress(progress)
    }

    private func daySeed() -> UInt64 {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let y = UInt64(components.year ?? 2026)
        let m = UInt64(components.month ?? 1)
        let d = UInt64(components.day ?? 1)
        return y * 10_000 + m * 100 + d
    }

    private func loadProgressDirect() -> PlayerProgress? {
        let items: [PlayerProgress] = storageService.load(forKey: StorageKeys.playerProgress)
        return items.first
    }

    private func saveProgress(_ progress: PlayerProgress) {
        storageService.save([progress], forKey: StorageKeys.playerProgress)
    }
}

struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed
    }

    mutating func next() -> UInt64 {
        state = state &* 6_364_136_223_847_493_229 &+ 1
        return state
    }
}

private extension Date {
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
}
