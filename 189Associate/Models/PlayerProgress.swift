import Foundation

struct PlayerProgress: Codable {
    var currentStreak: Int
    var longestStreak: Int
    var lastPlayDate: Date?
    var categoryStats: [CategoryStats]
    var creativeHighlights: [CreativeHighlight]
    var unlockedThemeIDs: [String]
    var earnedTitleIDs: [String]
    var activeTitleID: String?
    var dailyChallengeLastCompleted: Date?
    var totalGamesPlayed: Int
    var totalCorrectAssociations: Int
    var totalAssociations: Int

    static var empty: PlayerProgress {
        PlayerProgress(
            currentStreak: 0,
            longestStreak: 0,
            lastPlayDate: nil,
            categoryStats: [],
            creativeHighlights: [],
            unlockedThemeIDs: [AppTheme.midnight.rawValue],
            earnedTitleIDs: [PlayerTitle.beginner.rawValue],
            activeTitleID: PlayerTitle.beginner.rawValue,
            dailyChallengeLastCompleted: nil,
            totalGamesPlayed: 0,
            totalCorrectAssociations: 0,
            totalAssociations: 0
        )
    }
}

struct CreativeHighlight: Identifiable, Codable, Hashable {
    let id: UUID
    let text: String
    let word: String
    let mode: GameMode
    let score: Int
    let date: Date
}

enum PlayerTitle: String, CaseIterable, Codable, Identifiable {
    case beginner
    case quickThinker
    case categoryMaster
    case chainLinker
    case creativeGenius
    case duelChampion
    case streakKeeper
    case dailyWarrior

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .beginner: return "Beginner"
        case .quickThinker: return "Quick Thinker"
        case .categoryMaster: return "Category Master"
        case .chainLinker: return "Chain Linker"
        case .creativeGenius: return "Creative Genius"
        case .duelChampion: return "Duel Champion"
        case .streakKeeper: return "Streak Keeper"
        case .dailyWarrior: return "Daily Warrior"
        }
    }

    var icon: String {
        switch self {
        case .beginner: return "🌱"
        case .quickThinker: return "⚡"
        case .categoryMaster: return "👑"
        case .chainLinker: return "🔗"
        case .creativeGenius: return "💡"
        case .duelChampion: return "⚔️"
        case .streakKeeper: return "🔥"
        case .dailyWarrior: return "📅"
        }
    }

    var requirement: String {
        switch self {
        case .beginner: return "Play your first game"
        case .quickThinker: return "Score 40+ in Classic under 20s"
        case .categoryMaster: return "Play all 10 categories"
        case .chainLinker: return "Complete 5 Chain Mode games"
        case .creativeGenius: return "Score 45+ in Creative Mode"
        case .duelChampion: return "Win 3 Pass & Play duels"
        case .streakKeeper: return "Reach a 7-day streak"
        case .dailyWarrior: return "Complete 5 Daily Challenges"
        }
    }
}

enum AppTheme: String, CaseIterable, Codable, Identifiable {
    case midnight
    case ocean
    case forest
    case sunset
    case neon

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .midnight: return "Midnight"
        case .ocean: return "Ocean"
        case .forest: return "Forest"
        case .sunset: return "Sunset"
        case .neon: return "Neon"
        }
    }

    var icon: String {
        switch self {
        case .midnight: return "🌙"
        case .ocean: return "🌊"
        case .forest: return "🌿"
        case .sunset: return "🌅"
        case .neon: return "✨"
        }
    }

    var unlockRequirement: String {
        switch self {
        case .midnight: return "Default theme"
        case .ocean: return "Play 5 games"
        case .forest: return "Reach a 3-day streak"
        case .sunset: return "Earn 3 titles"
        case .neon: return "Score 50 in any mode"
        }
    }

    var backgroundHex: String {
        switch self {
        case .midnight: return "090F1E"
        case .ocean: return "041E2E"
        case .forest: return "0A1F14"
        case .sunset: return "1F0F1E"
        case .neon: return "12001F"
        }
    }

    var cardHex: String {
        switch self {
        case .midnight: return "1A2339"
        case .ocean: return "0D3347"
        case .forest: return "1A3328"
        case .sunset: return "331A2E"
        case .neon: return "2A0D3D"
        }
    }

    var accentHex: String {
        switch self {
        case .midnight: return "01A2FF"
        case .ocean: return "00C2FF"
        case .forest: return "3DDC84"
        case .sunset: return "FF6B35"
        case .neon: return "FF00FF"
        }
    }
}
