import SwiftUI
import Combine

@MainActor
final class GameViewModel: ObservableObject {
    @Published var session: GameSession
    @Published var config: GameLaunchConfig
    @Published var currentInput = ""
    @Published var timeLeft: Int
    @Published var isGameOver = false
    @Published var submittedAssociations: [String] = []
    @Published var results: [(text: String, isCorrect: Bool, points: Int, feedback: String)] = []
    @Published var totalScore: Int = 0
    @Published var currentCombo: Int = 0
    @Published var maxCombo: Int = 0
    @Published var chainAnchor: String?

    private var timer: Timer?
    private let gameEngine: GameEngine
    private let storageService: StorageServiceProtocol
    private let progressService: ProgressService
    private let achievementService: AchievementService
    private let dailyChallengeService: DailyChallengeService
    private let coordinator: AppCoordinator
    private let maxAssociations = 5

    init(
        word: Word,
        config: GameLaunchConfig,
        gameEngine: GameEngine,
        storageService: StorageServiceProtocol,
        progressService: ProgressService,
        achievementService: AchievementService,
        dailyChallengeService: DailyChallengeService,
        coordinator: AppCoordinator
    ) {
        self.config = config
        self.session = gameEngine.startGame(
            with: word,
            difficulty: config.difficulty,
            mode: config.mode,
            playerName: config.mode == .duel
                ? (config.duelCurrentPlayer == 1 ? config.duelPlayer1Name : config.duelPlayer2Name)
                : nil,
            deckID: config.deckID,
            isDailyChallenge: config.mode == .daily
        )
        self.timeLeft = config.mode.usesTimer ? config.difficulty.timeLimit : 0
        self.gameEngine = gameEngine
        self.storageService = storageService
        self.progressService = progressService
        self.achievementService = achievementService
        self.dailyChallengeService = dailyChallengeService
        self.coordinator = coordinator

        if config.mode.usesTimer {
            startTimer()
        }
    }

    deinit {
        timer?.invalidate()
    }

    var mode: GameMode { config.mode }
    var difficulty: Difficulty { config.difficulty }
    var showsTimer: Bool { config.mode.usesTimer }

    var chainHint: String? {
        guard config.mode == .chain else { return nil }
        if let chainAnchor { return "Chain from: \(chainAnchor)" }
        return "First link connects to the word"
    }

    var playerBanner: String? {
        guard config.mode == .duel, let name = session.playerName else { return nil }
        return "\(name)'s turn"
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                if self.timeLeft > 0 {
                    self.timeLeft -= 1
                    self.session.timeLeft = self.timeLeft
                } else {
                    self.endGame()
                }
            }
        }
    }

    func submitAssociation() {
        guard !isGameOver else { return }
        guard !currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard submittedAssociations.count < maxAssociations else { return }

        let text = currentInput.trimmingCharacters(in: .whitespacesAndNewlines)
        let result = gameEngine.submitAssociation(text, session: session, previousAnswers: submittedAssociations)

        submittedAssociations.append(text)
        results.append((text: text, isCorrect: result.isCorrect, points: result.points, feedback: result.feedback))
        totalScore += result.points
        session.totalScore = totalScore
        currentInput = ""

        if result.isCorrect {
            currentCombo += 1
            maxCombo = max(maxCombo, currentCombo)
        } else {
            currentCombo = 0
        }
        session.comboCount = currentCombo
        session.maxCombo = maxCombo
        if result.isChainBreak { session.chainBreaks += 1 }

        let association = Association(
            id: UUID(),
            text: text,
            isCorrect: result.isCorrect,
            points: result.points,
            position: submittedAssociations.count
        )
        session.userAssociations.append(association)

        if config.mode == .chain {
            chainAnchor = text
        }

        if submittedAssociations.count >= maxAssociations {
            endGame()
        }
    }

    func endGame() {
        guard !isGameOver else { return }
        timer?.invalidate()
        timer = nil
        isGameOver = true
        session.isComplete = true
        session.endDate = Date()
        session.totalScore = totalScore
        session.maxCombo = maxCombo

        var history: [GameSession] = storageService.load(forKey: StorageKeys.gameHistory)
        history.append(session)
        storageService.save(history, forKey: StorageKeys.gameHistory)

        progressService.recordSession(session)
        if config.mode == .daily {
            dailyChallengeService.markCompleted()
        }

        var progress = progressService.loadProgress()
        coordinator.themeManager.unlockEligibleThemes(progress: &progress, latestScore: totalScore)
        progressService.saveProgress(progress)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            if self.config.mode == .duel, self.config.duelCurrentPlayer == 1 {
                self.coordinator.continueDuel(after: self.session, config: self.config)
            } else if self.config.mode == .duel, self.config.duelCurrentPlayer == 2 {
                self.coordinator.finishDuel(session1ID: self.config.duelSession1ID!, session2: self.session, config: self.config)
            } else {
                self.coordinator.navigateToResult(session: self.session)
            }
        }
    }

    func goBack() {
        timer?.invalidate()
        timer = nil
        coordinator.pop()
    }

    var progressText: String {
        "\(submittedAssociations.count)/\(maxAssociations)"
    }

    var isInputDisabled: Bool {
        isGameOver || submittedAssociations.count >= maxAssociations
    }
}
