import Foundation

struct Word: Identifiable, Codable, Hashable {
    let id: UUID
    let text: String
    let category: Category
    let difficulty: Difficulty
    var associations: [String]
    var associationHints: [String]
    var deckID: UUID?
    var customCategoryName: String?

    init(
        id: UUID = UUID(),
        text: String,
        category: Category,
        difficulty: Difficulty,
        associations: [String],
        associationHints: [String] = [],
        deckID: UUID? = nil,
        customCategoryName: String? = nil
    ) {
        self.id = id
        self.text = text
        self.category = category
        self.difficulty = difficulty
        self.associations = associations
        self.associationHints = associationHints.isEmpty
            ? associations.map { "A common link to \"\(text)\" through \($0.lowercased())." }
            : associationHints
        self.deckID = deckID
        self.customCategoryName = customCategoryName
    }

    var categoryLabel: String {
        customCategoryName ?? category.displayName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let decodedText = try container.decode(String.self, forKey: .text)
        text = decodedText
        category = try container.decode(Category.self, forKey: .category)
        difficulty = try container.decode(Difficulty.self, forKey: .difficulty)
        let decodedAssociations = try container.decode([String].self, forKey: .associations)
        associations = decodedAssociations
        let decodedHints = try container.decodeIfPresent([String].self, forKey: .associationHints) ?? []
        associationHints = decodedHints.isEmpty
            ? decodedAssociations.map { "A common link to \"\(decodedText)\" through \($0.lowercased())." }
            : decodedHints
        deckID = try container.decodeIfPresent(UUID.self, forKey: .deckID)
        customCategoryName = try container.decodeIfPresent(String.self, forKey: .customCategoryName)
    }
}
