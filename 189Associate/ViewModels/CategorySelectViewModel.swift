import SwiftUI
import Combine

@MainActor
final class CategorySelectViewModel: ObservableObject {
    @Published var selectedCategory: Category?
    @Published var selectedDeckID: UUID?
    @Published var selectedDifficulty: Difficulty = .easy
    @Published var showNoWordsAlert = false
    @Published var useCustomDeck = false

    let config: GameLaunchConfig
    private let gameEngine: GameEngine
    private let deckService: DeckService
    private let coordinator: AppCoordinator

    init(
        config: GameLaunchConfig,
        gameEngine: GameEngine,
        deckService: DeckService,
        coordinator: AppCoordinator
    ) {
        self.config = config
        self.gameEngine = gameEngine
        self.deckService = deckService
        self.coordinator = coordinator
    }

    var mode: GameMode { config.mode }
    var decks: [WordDeck] { deckService.getDecks() }

    func selectCategory(_ category: Category) {
        selectedCategory = category
        selectedDeckID = nil
        useCustomDeck = false
        startGame()
    }

    func selectDeck(_ deck: WordDeck) {
        selectedDeckID = deck.id
        selectedCategory = nil
        useCustomDeck = true
        startGame()
    }

    func startGame() {
        let word: Word?
        var launchConfig = config
        launchConfig.difficulty = selectedDifficulty

        if useCustomDeck, let deckID = selectedDeckID {
            launchConfig.deckID = deckID
            word = gameEngine.getRandomWord(difficulty: selectedDifficulty, deckID: deckID)
        } else if let category = selectedCategory {
            launchConfig.category = category
            word = gameEngine.getRandomWord(category: category, difficulty: selectedDifficulty)
        } else {
            return
        }

        guard let word else {
            showNoWordsAlert = true
            return
        }

        if config.mode == .duel {
            launchConfig.duelWordID = word.id
        }

        coordinator.navigateToGame(word: word, config: launchConfig)
    }

    func goBack() {
        coordinator.pop()
    }
}
