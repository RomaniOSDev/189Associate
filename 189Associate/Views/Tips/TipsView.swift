import SwiftUI

struct TipsView: View {
    let coordinator: AppCoordinator
    @EnvironmentObject private var themeManager: ThemeManager

    private let tips: [(icon: String, title: String, body: String)] = [
        ("🧠", "Free Association", "Say the first word that comes to mind. Speed beats perfection in timed modes."),
        ("🔗", "Chain Thinking", "Each new word should connect to your previous answer — not just the original word."),
        ("💡", "Be Original", "In Creative Mode, unique answers score higher. Avoid repeating yourself."),
        ("📖", "Practice First", "Use Practice mode to learn expected associations without pressure."),
        ("🎯", "Category Clues", "Think about where you'd see the word: nature, city life, emotions, or work."),
        ("⚡", "Combo Streaks", "Consecutive correct answers build combos. Stay focused to keep the streak alive."),
        ("📚", "Build Decks", "Create custom decks for study topics, team building, or party games."),
        ("📅", "Daily Habit", "The Daily Challenge uses the same word for everyone each day — great for streaks.")
    ]

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppDesign.sectionSpacing) {
                    SectionHeaderView(
                        title: "How to Play",
                        subtitle: "Master associations faster"
                    )

                    VStack(spacing: AppDesign.itemSpacing) {
                        ForEach(Array(tips.enumerated()), id: \.offset) { index, tip in
                            TipCardCell(icon: tip.icon, title: tip.title, bodyText: tip.body)
                        }
                    }
                }
                .padding(AppDesign.horizontalPadding)
                .padding(.vertical, 8)
            }
        }
        .appNavigationBar(title: "Tips", onBack: { coordinator.pop() })
    }
}
