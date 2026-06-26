import Foundation

struct AssociationResult {
    let isCorrect: Bool
    let points: Int
    let feedback: String
    let isRepeat: Bool
    let isChainBreak: Bool
}

final class GameEngine {
    private let wordService: WordService
    private let deckService: DeckService

    init(
        wordService: WordService = WordService(),
        deckService: DeckService = DeckService()
    ) {
        self.wordService = wordService
        self.deckService = deckService
    }

    func startGame(
        with word: Word,
        difficulty: Difficulty,
        mode: GameMode,
        playerName: String? = nil,
        deckID: UUID? = nil,
        isDailyChallenge: Bool = false
    ) -> GameSession {
        let timeLimit = mode.usesTimer ? difficulty.timeLimit : 0
        return GameSession(
            word: word,
            timeLeft: timeLimit,
            maxPossibleScore: difficulty.associationsRequired * 10,
            gameMode: mode,
            difficulty: difficulty,
            playerName: playerName,
            deckID: deckID,
            isDailyChallenge: isDailyChallenge
        )
    }

    func submitAssociation(
        _ text: String,
        session: GameSession,
        previousAnswers: [String]
    ) -> AssociationResult {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let lower = trimmed.lowercased()

        switch session.gameMode {
        case .classic, .practice, .daily:
            return classicResult(trimmed: trimmed, lower: lower, session: session, previousAnswers: previousAnswers)
        case .chain:
            return chainResult(trimmed: trimmed, lower: lower, session: session, previousAnswers: previousAnswers)
        case .creative:
            return creativeResult(trimmed: trimmed, lower: lower, previousAnswers: previousAnswers)
        case .duel:
            return classicResult(trimmed: trimmed, lower: lower, session: session, previousAnswers: previousAnswers)
        }
    }

    func getRandomWord(
        category: Category? = nil,
        difficulty: Difficulty? = nil,
        deckID: UUID? = nil
    ) -> Word? {
        if let deckID {
            let words = deckService.getWords(for: deckID)
            if let difficulty {
                let exact = words.filter { $0.difficulty == difficulty }
                if let word = exact.randomElement() { return word }
            }
            return words.randomElement()
        }

        guard let category else {
            return wordService.getWords(for: nil, difficulty: difficulty).randomElement()
        }

        if let difficulty {
            let exactMatches = wordService.getWords(for: category, difficulty: difficulty)
            if let word = exactMatches.randomElement() { return word }
        }

        return wordService.getWords(for: category).randomElement()
    }

    func hint(for association: String, word: Word) -> String {
        if let index = word.associations.firstIndex(where: { $0.lowercased() == association.lowercased() }),
           word.associationHints.indices.contains(index) {
            return word.associationHints[index]
        }
        return "Think about how \"\(association)\" connects to \"\(word.text)\"."
    }

    // MARK: - Private

    private func classicResult(
        trimmed: String,
        lower: String,
        session: GameSession,
        previousAnswers: [String]
    ) -> AssociationResult {
        let isRepeat = previousAnswers.contains { $0.lowercased() == lower }
        let isCorrect = session.word.associations.contains { $0.lowercased() == lower }
        let points = isCorrect ? 10 : 0
        let feedback = isCorrect ? "Correct match!" : "Not in the expected set."
        return AssociationResult(
            isCorrect: isCorrect,
            points: points,
            feedback: feedback,
            isRepeat: isRepeat,
            isChainBreak: false
        )
    }

    private func chainResult(
        trimmed: String,
        lower: String,
        session: GameSession,
        previousAnswers: [String]
    ) -> AssociationResult {
        if previousAnswers.isEmpty {
            return classicResult(trimmed: trimmed, lower: lower, session: session, previousAnswers: previousAnswers)
        }

        let previous = previousAnswers.last!.lowercased()
        let isRepeat = previousAnswers.contains { $0.lowercased() == lower }
        let isLinked = sharesLink(between: lower, and: previous)
            || session.word.associations.contains { $0.lowercased() == lower }
        let points = isLinked ? 10 : 0
        let feedback = isLinked
            ? "Strong chain link!"
            : "Must link to \"\(previousAnswers.last!)\"."
        return AssociationResult(
            isCorrect: isLinked,
            points: points,
            feedback: feedback,
            isRepeat: isRepeat,
            isChainBreak: !isLinked
        )
    }

    private func creativeResult(
        trimmed: String,
        lower: String,
        previousAnswers: [String]
    ) -> AssociationResult {
        let isRepeat = previousAnswers.contains { $0.lowercased() == lower }
        if isRepeat {
            return AssociationResult(
                isCorrect: false,
                points: 0,
                feedback: "Already used — try something new!",
                isRepeat: true,
                isChainBreak: false
            )
        }

        var points = 8
        if trimmed.count >= 5 { points += 2 }
        if trimmed.count >= 10 { points += 2 }
        if !previousAnswers.contains(where: { sharesLink(between: $0.lowercased(), and: lower) }) {
            points += 3
        }

        return AssociationResult(
            isCorrect: true,
            points: points,
            feedback: "Creative answer!",
            isRepeat: false,
            isChainBreak: false
        )
    }

    private func sharesLink(between a: String, and b: String) -> Bool {
        if a.isEmpty || b.isEmpty { return false }
        if a.contains(b) || b.contains(a) { return true }

        let wordsA = Set(a.split(separator: " ").map(String.init))
        let wordsB = Set(b.split(separator: " ").map(String.init))
        if !wordsA.isDisjoint(with: wordsB) { return true }

        let minLength = 3
        for i in 0..<(a.count - minLength + 1) {
            let start = a.index(a.startIndex, offsetBy: i)
            let end = a.index(start, offsetBy: minLength)
            let substring = String(a[start..<end])
            if b.contains(substring) { return true }
        }
        return false
    }
}
