import Foundation

struct Association: Identifiable, Codable, Hashable {
    let id: UUID
    let text: String
    var isCorrect: Bool?
    var points: Int
    var position: Int
}
