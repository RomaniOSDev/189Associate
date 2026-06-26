import SwiftUI
import Combine

@MainActor
final class MyDecksViewModel: ObservableObject {
    @Published var decks: [WordDeck] = []
    @Published var showImportError = false
    @Published var exportURL: URL?

    private let deckService: DeckService
    private let coordinator: AppCoordinator

    init(deckService: DeckService, coordinator: AppCoordinator) {
        self.deckService = deckService
        self.coordinator = coordinator
        load()
    }

    func load() {
        decks = deckService.getDecks()
    }

    func createDeck() {
        coordinator.navigateToDeckEditor(deckID: nil)
    }

    func editDeck(_ deck: WordDeck) {
        coordinator.navigateToDeckEditor(deckID: deck.id)
    }

    func deleteDeck(_ deck: WordDeck) {
        deckService.deleteDeck(deck.id)
        load()
    }

    func exportDeck(_ deck: WordDeck) -> URL? {
        guard let data = deckService.exportDeck(deck) else { return nil }
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(deck.name.replacingOccurrences(of: " ", with: "_")).json")
        try? data.write(to: url)
        return url
    }

    func importDeck(from url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            importData(from: url)
            return
        }
        defer { url.stopAccessingSecurityScopedResource() }
        importData(from: url)
    }

    private func importData(from url: URL) {
        guard let data = try? Data(contentsOf: url),
              let deck = deckService.importDeck(from: data) else {
            showImportError = true
            return
        }
        deckService.saveDeck(deck)
        load()
    }

    func goBack() { coordinator.pop() }
}
