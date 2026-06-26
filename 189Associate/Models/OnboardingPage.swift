import Foundation

struct OnboardingPage: Identifiable, Equatable {
    let id: Int
    let imageName: String
    let icon: String
    let title: String
    let subtitle: String
    let highlights: [String]

    static let pages: [OnboardingPage] = [
        OnboardingPage(
            id: 0,
            imageName: HomeImageAsset.heroBanner,
            icon: "🧠",
            title: "Think in Connections",
            subtitle: "See a word — type the first associations that come to mind. Speed and creativity both matter.",
            highlights: ["Free association gameplay", "10 word categories", "Timed & relaxed modes"]
        ),
        OnboardingPage(
            id: 1,
            imageName: HomeImageAsset.modeImage(.classic),
            icon: "🎯",
            title: "Play Your Way",
            subtitle: "From classic scoring to chain links, creative originality, practice, and pass-and-play duels.",
            highlights: ["Classic, Chain & Creative", "Practice without a timer", "Two-player duels"]
        ),
        OnboardingPage(
            id: 2,
            imageName: HomeImageAsset.dailyChallenge,
            icon: "📅",
            title: "Grow Every Day",
            subtitle: "Build streaks, earn titles, unlock themes, and take on a new daily challenge every day.",
            highlights: ["Daily Challenge word", "Stats & leaderboards", "Custom word decks"]
        )
    ]
}
