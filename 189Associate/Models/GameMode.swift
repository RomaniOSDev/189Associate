import Foundation

enum GameMode: String, Codable, CaseIterable, Hashable {
    case classic
    case chain
    case creative
    case practice
    case duel
    case daily

    var displayName: String {
        switch self {
        case .classic: return "Classic"
        case .chain: return "Chain Mode"
        case .creative: return "Creative Mode"
        case .practice: return "Practice"
        case .duel: return "Pass & Play"
        case .daily: return "Daily Challenge"
        }
    }

    var icon: String {
        switch self {
        case .classic: return "🎯"
        case .chain: return "🔗"
        case .creative: return "💡"
        case .practice: return "📖"
        case .duel: return "⚔️"
        case .daily: return "📅"
        }
    }

    var subtitle: String {
        switch self {
        case .classic: return "Match expected associations"
        case .chain: return "Link each answer to the previous one"
        case .creative: return "Score for originality, not accuracy"
        case .practice: return "No timer, learn at your pace"
        case .duel: return "Two players, one device"
        case .daily: return "One special word every day"
        }
    }

    var usesTimer: Bool {
        self != .practice
    }

    var needsCategorySelect: Bool {
        self != .daily
    }
}
