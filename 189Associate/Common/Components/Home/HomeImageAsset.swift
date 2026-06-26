import SwiftUI

enum HomeImageAsset {
    static let heroBanner = "HomeHeroBanner"
    static let dailyChallenge = "HomeDailyChallenge"
    static let widgetProgress = "HomeWidgetProgress"

    static func modeImage(_ mode: GameMode) -> String {
        switch mode {
        case .classic: return "HomeModeClassic"
        case .chain: return "HomeModeChain"
        case .creative: return "HomeModeCreative"
        case .practice: return "HomeModePractice"
        case .duel: return "HomeModeDuel"
        case .daily: return dailyChallenge
        }
    }
}
