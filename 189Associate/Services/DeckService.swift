import Foundation

final class DeckService {
    private let storageService: StorageServiceProtocol

    init(storageService: StorageServiceProtocol = UserDefaultsStorageService()) {
        self.storageService = storageService
    }

    func getDecks() -> [WordDeck] {
        storageService.load(forKey: StorageKeys.decks)
    }

    func saveDeck(_ deck: WordDeck) {
        var decks = getDecks()
        if let index = decks.firstIndex(where: { $0.id == deck.id }) {
            decks[index] = deck
        } else {
            decks.append(deck)
        }
        storageService.save(decks, forKey: StorageKeys.decks)
    }

    func deleteDeck(_ deckID: UUID) {
        var decks = getDecks()
        decks.removeAll { $0.id == deckID }
        storageService.save(decks, forKey: StorageKeys.decks)
    }

    func getDeck(_ id: UUID) -> WordDeck? {
        getDecks().first { $0.id == id }
    }

    func exportDeck(_ deck: WordDeck) -> Data? {
        let export = DeckExport(
            version: 1,
            name: deck.name,
            icon: deck.icon,
            words: deck.words.map {
                DeckWordExport(
                    text: $0.text,
                    associations: $0.associations,
                    hints: $0.associationHints,
                    difficulty: $0.difficulty
                )
            }
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try? encoder.encode(export)
    }

    func importDeck(from data: Data) -> WordDeck? {
        guard let export = try? JSONDecoder().decode(DeckExport.self, from: data) else {
            return nil
        }
        let deckID = UUID()
        let words = export.words.map { item in
            Word(
                text: item.text,
                category: .custom,
                difficulty: item.difficulty,
                associations: item.associations,
                associationHints: item.hints,
                deckID: deckID,
                customCategoryName: export.name
            )
        }
        return WordDeck(
            id: deckID,
            name: export.name,
            icon: export.icon.isEmpty ? "📚" : export.icon,
            words: words,
            createdAt: Date(),
            updatedAt: Date()
        )
    }

    func getWords(for deckID: UUID) -> [Word] {
        getDeck(deckID)?.words ?? []
    }
}
