import Foundation

struct GameLaunchConfig: Identifiable, Hashable {
    let id: UUID
    var mode: GameMode
    var difficulty: Difficulty
    var category: Category?
    var deckID: UUID?
    var duelPlayer1Name: String?
    var duelPlayer2Name: String?
    var duelCurrentPlayer: Int
    var duelWordID: UUID?
    var duelSession1ID: UUID?

    init(
        id: UUID = UUID(),
        mode: GameMode,
        difficulty: Difficulty = .easy,
        category: Category? = nil,
        deckID: UUID? = nil,
        duelPlayer1Name: String? = nil,
        duelPlayer2Name: String? = nil,
        duelCurrentPlayer: Int = 1,
        duelWordID: UUID? = nil,
        duelSession1ID: UUID? = nil
    ) {
        self.id = id
        self.mode = mode
        self.difficulty = difficulty
        self.category = category
        self.deckID = deckID
        self.duelPlayer1Name = duelPlayer1Name
        self.duelPlayer2Name = duelPlayer2Name
        self.duelCurrentPlayer = duelCurrentPlayer
        self.duelWordID = duelWordID
        self.duelSession1ID = duelSession1ID
    }
}

struct DuelResult: Identifiable, Hashable {
    let id: UUID
    let player1Name: String
    let player2Name: String
    let session1ID: UUID
    let session2ID: UUID
    let word: Word
}
