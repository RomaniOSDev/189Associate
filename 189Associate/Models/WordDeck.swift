import Foundation

struct WordDeck: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var icon: String
    var words: [Word]
    var createdAt: Date
    var updatedAt: Date
}

struct DeckExport: Codable {
    let version: Int
    let name: String
    let icon: String
    let words: [DeckWordExport]
}

struct DeckWordExport: Codable {
    let text: String
    let associations: [String]
    let hints: [String]
    let difficulty: Difficulty
}
