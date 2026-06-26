import Foundation

enum AppRoute: Hashable {
    case modeSelect
    case categorySelect(configID: UUID)
    case duelSetup(configID: UUID)
    case game(configID: UUID, wordID: UUID)
    case result(sessionID: UUID)
    case duelResult(resultID: UUID)
    case leaderboard
    case settings
    case progress
    case myDecks
    case deckEditor(deckID: UUID?)
    case tips
    case themes
}
