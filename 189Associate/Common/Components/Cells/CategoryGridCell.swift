import SwiftUI

struct CategoryGridCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let category: Category
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                IconOrb(
                    content: category.icon,
                    size: 52,
                    fontSize: .title,
                    isSelected: isSelected
                )

                Text(category.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .glassCard(isSelected: isSelected, elevation: isSelected ? .floating : .raised)
        }
        .buttonStyle(PressableCellStyle())
    }
}

struct DifficultyCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let difficulty: Difficulty
    let isSelected: Bool
    let action: () -> Void

    private var emoji: String {
        switch difficulty {
        case .easy: return "🟢"
        case .medium: return "🟡"
        case .hard: return "🔴"
        }
    }

    private var timeLabel: String {
        difficulty.timeLimit > 0 ? "\(difficulty.timeLimit)s" : "∞"
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(emoji).font(.title2)
                Text(difficulty.displayName)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text(timeLabel)
                    .font(.caption2)
                    .foregroundColor(.appTextSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .glassCard(isSelected: isSelected, elevation: isSelected ? .floating : .raised)
        }
        .buttonStyle(PressableCellStyle())
    }
}
