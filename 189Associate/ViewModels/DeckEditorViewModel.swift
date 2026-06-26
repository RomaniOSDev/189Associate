import SwiftUI
import Combine

@MainActor
final class DeckEditorViewModel: ObservableObject {
    @Published var name = ""
    @Published var icon = "📚"
    @Published var words: [Word] = []
    @Published var newWordText = ""
    @Published var newAssociations = ""
    @Published var selectedDifficulty: Difficulty = .easy

    private let deckID: UUID?
    private let deckService: DeckService
    private let coordinator: AppCoordinator
    private var existingDeck: WordDeck?

    init(deckID: UUID?, deckService: DeckService, coordinator: AppCoordinator) {
        self.deckID = deckID
        self.deckService = deckService
        self.coordinator = coordinator
        if let deckID, let deck = deckService.getDeck(deckID) {
            existingDeck = deck
            name = deck.name
            icon = deck.icon
            words = deck.words
        }
    }

    var isEditing: Bool { deckID != nil }
    var canSave: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty && !words.isEmpty }

    func addWord() {
        let text = newWordText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        let associations = newAssociations
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        guard associations.count >= 3 else { return }

        let id = deckID ?? UUID()
        let word = Word(
            text: text,
            category: .custom,
            difficulty: selectedDifficulty,
            associations: associations,
            deckID: id,
            customCategoryName: name
        )
        words.append(word)
        newWordText = ""
        newAssociations = ""
    }

    func removeWord(at offsets: IndexSet) {
        words.remove(atOffsets: offsets)
    }

    func save() {
        let id = deckID ?? UUID()
        let deck = WordDeck(
            id: id,
            name: name.trimmingCharacters(in: .whitespaces),
            icon: icon.isEmpty ? "📚" : icon,
            words: words.map { word in
                var w = word
                return Word(
                    id: word.id,
                    text: word.text,
                    category: .custom,
                    difficulty: word.difficulty,
                    associations: word.associations,
                    associationHints: word.associationHints,
                    deckID: id,
                    customCategoryName: name
                )
            },
            createdAt: existingDeck?.createdAt ?? Date(),
            updatedAt: Date()
        )
        deckService.saveDeck(deck)
        coordinator.pop()
    }

    func goBack() { coordinator.pop() }
}
