import Foundation

struct CategoryStats: Codable {
    var category: Category
    var totalGames: Int
    var totalScore: Int
    var bestScore: Int
    var averageScore: Double
}
