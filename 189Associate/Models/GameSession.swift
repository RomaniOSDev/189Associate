import Foundation

struct GameSession: Identifiable, Codable, Hashable {
    let id: UUID
    var word: Word
    var userAssociations: [Association]
    var score: Int
    var timeLeft: Int
    var isComplete: Bool
    var startDate: Date
    var endDate: Date?
    var totalScore: Int
    var maxPossibleScore: Int
    var gameMode: GameMode
    var difficulty: Difficulty
    var playerName: String?
    var comboCount: Int
    var maxCombo: Int
    var chainBreaks: Int
    var deckID: UUID?
    var isDailyChallenge: Bool

    init(
        id: UUID = UUID(),
        word: Word,
        userAssociations: [Association] = [],
        score: Int = 0,
        timeLeft: Int = 30,
        isComplete: Bool = false,
        startDate: Date = Date(),
        endDate: Date? = nil,
        totalScore: Int = 0,
        maxPossibleScore: Int = 50,
        gameMode: GameMode = .classic,
        difficulty: Difficulty = .easy,
        playerName: String? = nil,
        comboCount: Int = 0,
        maxCombo: Int = 0,
        chainBreaks: Int = 0,
        deckID: UUID? = nil,
        isDailyChallenge: Bool = false
    ) {
        self.id = id
        self.word = word
        self.userAssociations = userAssociations
        self.score = score
        self.timeLeft = timeLeft
        self.isComplete = isComplete
        self.startDate = startDate
        self.endDate = endDate
        self.totalScore = totalScore
        self.maxPossibleScore = maxPossibleScore
        self.gameMode = gameMode
        self.difficulty = difficulty
        self.playerName = playerName
        self.comboCount = comboCount
        self.maxCombo = maxCombo
        self.chainBreaks = chainBreaks
        self.deckID = deckID
        self.isDailyChallenge = isDailyChallenge
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        word = try container.decode(Word.self, forKey: .word)
        userAssociations = try container.decode([Association].self, forKey: .userAssociations)
        score = try container.decode(Int.self, forKey: .score)
        timeLeft = try container.decode(Int.self, forKey: .timeLeft)
        isComplete = try container.decode(Bool.self, forKey: .isComplete)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decodeIfPresent(Date.self, forKey: .endDate)
        totalScore = try container.decode(Int.self, forKey: .totalScore)
        maxPossibleScore = try container.decode(Int.self, forKey: .maxPossibleScore)
        gameMode = try container.decodeIfPresent(GameMode.self, forKey: .gameMode) ?? .classic
        difficulty = try container.decodeIfPresent(Difficulty.self, forKey: .difficulty) ?? .easy
        playerName = try container.decodeIfPresent(String.self, forKey: .playerName)
        comboCount = try container.decodeIfPresent(Int.self, forKey: .comboCount) ?? 0
        maxCombo = try container.decodeIfPresent(Int.self, forKey: .maxCombo) ?? 0
        chainBreaks = try container.decodeIfPresent(Int.self, forKey: .chainBreaks) ?? 0
        deckID = try container.decodeIfPresent(UUID.self, forKey: .deckID)
        isDailyChallenge = try container.decodeIfPresent(Bool.self, forKey: .isDailyChallenge) ?? false
    }
}
