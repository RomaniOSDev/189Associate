import SwiftUI
import Combine

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []
    @Published var showsOnboarding: Bool

    let storageService: StorageServiceProtocol
    let wordService: WordService
    let deckService: DeckService
    let gameEngine: GameEngine
    let progressService: ProgressService
    let achievementService: AchievementService
    let dailyChallengeService: DailyChallengeService
    let themeManager: ThemeManager

    private var wordStore: [UUID: Word] = [:]
    private var sessionStore: [UUID: GameSession] = [:]
    private var configStore: [UUID: GameLaunchConfig] = [:]
    private var duelResultStore: [UUID: DuelResult] = [:]

    private(set) lazy var homeViewModel = HomeViewModel(coordinator: self)
    private(set) lazy var onboardingViewModel = OnboardingViewModel { [weak self] in
        self?.completeOnboarding()
    }

    init() {
        showsOnboarding = !UserDefaults.standard.bool(forKey: StorageKeys.onboardingCompleted)
        storageService = UserDefaultsStorageService()
        wordService = WordService(storageService: storageService)
        deckService = DeckService(storageService: storageService)
        gameEngine = GameEngine(wordService: wordService, deckService: deckService)
        progressService = ProgressService(storageService: storageService)
        achievementService = AchievementService(progressService: progressService)
        dailyChallengeService = DailyChallengeService(
            wordService: wordService,
            storageService: storageService
        )
        themeManager = ThemeManager(progressService: progressService)
    }

    // MARK: - Navigation

    func completeOnboarding() {
        showsOnboarding = false
    }

    func navigateToModeSelect() {
        path.append(.modeSelect)
    }

    func quickStart(mode: GameMode) {
        let config = GameLaunchConfig(mode: mode)
        if mode == .duel {
            navigateToDuelSetup(config: config)
        } else {
            navigateToCategorySelect(config: config)
        }
    }

    func navigateToCategorySelect(config: GameLaunchConfig) {
        configStore[config.id] = config
        path.append(.categorySelect(configID: config.id))
    }

    func navigateToDuelSetup(config: GameLaunchConfig) {
        configStore[config.id] = config
        path.append(.duelSetup(configID: config.id))
    }

    func startDailyChallenge() {
        let word = dailyChallengeService.todayWord()
        wordStore[word.id] = word
        let config = GameLaunchConfig(mode: .daily, difficulty: .medium)
        configStore[config.id] = config
        path.append(.game(configID: config.id, wordID: word.id))
    }

    func navigateToGame(word: Word, config: GameLaunchConfig) {
        wordStore[word.id] = word
        configStore[config.id] = config
        path.append(.game(configID: config.id, wordID: word.id))
    }

    func navigateToResult(session: GameSession) {
        sessionStore[session.id] = session
        path.append(.result(sessionID: session.id))
    }

    func navigateToDuelResult(_ result: DuelResult) {
        duelResultStore[result.id] = result
        sessionStore[result.session1ID] = sessionStore[result.session1ID]
        sessionStore[result.session2ID] = sessionStore[result.session2ID]
        path.append(.duelResult(resultID: result.id))
    }

    func navigateToLeaderboard() { path.append(.leaderboard) }
    func navigateToSettings() { path.append(.settings) }
    func navigateToProgress() { path.append(.progress) }
    func navigateToMyDecks() { path.append(.myDecks) }
    func navigateToDeckEditor(deckID: UUID?) { path.append(.deckEditor(deckID: deckID)) }
    func navigateToTips() { path.append(.tips) }
    func navigateToThemes() { path.append(.themes) }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func config(for id: UUID) -> GameLaunchConfig? {
        configStore[id]
    }

    func updateConfig(_ config: GameLaunchConfig) {
        configStore[config.id] = config
    }

    // MARK: - Duel

    func continueDuel(after session1: GameSession, config: GameLaunchConfig) {
        sessionStore[session1.id] = session1
        guard let wordID = config.duelWordID ?? Optional(session1.word.id),
              let word = wordStore[wordID] ?? Optional(session1.word) else { return }

        var nextConfig = config
        nextConfig.duelSession1ID = session1.id
        nextConfig.duelCurrentPlayer = 2
        nextConfig.duelWordID = word.id
        configStore[nextConfig.id] = nextConfig
        wordStore[word.id] = word
        path.append(.game(configID: nextConfig.id, wordID: word.id))
    }

    func finishDuel(session1ID: UUID, session2: GameSession, config: GameLaunchConfig) {
        sessionStore[session2.id] = session2
        guard let session1 = sessionStore[session1ID] else { return }

        let p1 = config.duelPlayer1Name ?? "Player 1"
        let p2 = config.duelPlayer2Name ?? "Player 2"
        let result = DuelResult(
            id: UUID(),
            player1Name: p1,
            player2Name: p2,
            session1ID: session1.id,
            session2ID: session2.id,
            word: session1.word
        )

        let winnerIsP1 = session1.totalScore > session2.totalScore
        let isTie = session1.totalScore == session2.totalScore
        if !isTie {
            _ = achievementService.evaluate(session: winnerIsP1 ? session1 : session2, duelWon: true)
        }

        navigateToDuelResult(result)
    }

    // MARK: - Views

    @ViewBuilder
    func view(for route: AppRoute) -> some View {
        switch route {
        case .modeSelect:
            ModeSelectView(viewModel: ModeSelectViewModel(coordinator: self))
        case let .categorySelect(configID):
            if let config = configStore[configID] {
                CategorySelectView(viewModel: CategorySelectViewModel(
                    config: config,
                    gameEngine: gameEngine,
                    deckService: deckService,
                    coordinator: self
                ))
            } else {
                NavigationErrorView(message: "Could not load setup.") { self.pop() }
            }
        case let .duelSetup(configID):
            if let config = configStore[configID] {
                DuelSetupView(viewModel: DuelSetupViewModel(config: config, coordinator: self))
            } else {
                NavigationErrorView(message: "Could not load duel setup.") { self.pop() }
            }
        case let .game(configID, wordID):
            if let config = configStore[configID], let word = wordStore[wordID] {
                GameView(viewModel: GameViewModel(
                    word: word,
                    config: config,
                    gameEngine: gameEngine,
                    storageService: storageService,
                    progressService: progressService,
                    achievementService: achievementService,
                    dailyChallengeService: dailyChallengeService,
                    coordinator: self
                ))
            } else {
                NavigationErrorView(message: "Could not load the game.") { self.pop() }
            }
        case let .result(sessionID):
            if let session = sessionStore[sessionID] {
                ResultView(viewModel: ResultViewModel(
                    session: session,
                    gameEngine: gameEngine,
                    achievementService: achievementService,
                    coordinator: self
                ))
            } else {
                NavigationErrorView(message: "Could not load results.") { self.popToRoot() }
            }
        case let .duelResult(resultID):
            if let result = duelResultStore[resultID],
               let s1 = sessionStore[result.session1ID],
               let s2 = sessionStore[result.session2ID] {
                DuelResultView(result: result, session1: s1, session2: s2, coordinator: self)
            } else {
                NavigationErrorView(message: "Could not load duel results.") { self.popToRoot() }
            }
        case .leaderboard:
            LeaderboardView(viewModel: LeaderboardViewModel(
                storageService: storageService,
                coordinator: self
            ))
        case .settings:
            SettingsView(viewModel: SettingsViewModel(
                storageService: storageService,
                coordinator: self
            ))
        case .progress:
            ProgressViewScreen(viewModel: ProgressViewModel(
                progressService: progressService,
                achievementService: achievementService,
                coordinator: self
            ))
        case .myDecks:
            MyDecksView(viewModel: MyDecksViewModel(deckService: deckService, coordinator: self))
        case let .deckEditor(deckID):
            DeckEditorView(viewModel: DeckEditorViewModel(
                deckID: deckID,
                deckService: deckService,
                coordinator: self
            ))
        case .tips:
            TipsView(coordinator: self)
        case .themes:
            ThemesView(viewModel: ThemesViewModel(
                themeManager: themeManager,
                progressService: progressService,
                coordinator: self
            ))
        }
    }
}

private struct NavigationErrorView: View {
    let message: String
    let action: () -> Void

    var body: some View {
        ZStack {
            GradientBackground()
            VStack(spacing: 16) {
                Text("⚠️")
                    .font(.system(size: 48))
                Text(message)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Button("Go Back", action: action)
                    .foregroundColor(.appAccent)
            }
            .padding()
        }
        .appNavigationBar(title: "Error", onBack: action)
    }
}
