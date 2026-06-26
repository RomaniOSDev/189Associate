import Foundation

struct LeaderboardEntry: Identifiable, Codable {
    let id: UUID
    var playerName: String
    var score: Int
    var totalWords: Int
    var maxCombo: Int
    var date: Date
}
