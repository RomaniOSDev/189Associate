import Foundation

enum Category: String, CaseIterable, Codable {
    case animals
    case food
    case cities
    case professions
    case feelings
    case colors
    case nature
    case technology
    case sport
    case art
    case custom

    var displayName: String {
        switch self {
        case .animals: return "Animals"
        case .food: return "Food"
        case .cities: return "Cities"
        case .professions: return "Professions"
        case .feelings: return "Feelings"
        case .colors: return "Colors"
        case .nature: return "Nature"
        case .technology: return "Technology"
        case .sport: return "Sport"
        case .art: return "Art"
        case .custom: return "Custom"
        }
    }

    var icon: String {
        switch self {
        case .animals: return "🐾"
        case .food: return "🍔"
        case .cities: return "🏙️"
        case .professions: return "💼"
        case .feelings: return "💭"
        case .colors: return "🎨"
        case .nature: return "🌿"
        case .technology: return "💻"
        case .sport: return "⚽"
        case .art: return "🎨"
        case .custom: return "📚"
        }
    }

    static var playableCategories: [Category] {
        allCases.filter { $0 != .custom }
    }
}

enum Difficulty: String, CaseIterable, Codable {
    case easy
    case medium
    case hard

    var displayName: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }

    var timeLimit: Int {
        switch self {
        case .easy: return 30
        case .medium: return 20
        case .hard: return 10
        }
    }

    var associationsRequired: Int {
        switch self {
        case .easy: return 5
        case .medium: return 5
        case .hard: return 5
        }
    }
}
