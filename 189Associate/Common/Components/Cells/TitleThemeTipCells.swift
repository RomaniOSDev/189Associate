import SwiftUI

struct TitleBadgeCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let title: PlayerTitle
    var isNew: Bool = false

    var body: some View {
        HStack(spacing: 14) {
            IconOrb(content: title.icon, size: 48, fontSize: .title2, isSelected: isNew)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(title.displayName)
                        .font(.headline)
                        .foregroundColor(.white)
                    if isNew {
                        Text("NEW")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.accentColor)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(themeManager.accentColor.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }
                Text(title.requirement)
                    .font(.caption)
                    .foregroundColor(.appTextSecondary)
            }
            Spacer()
        }
        .padding(AppDesign.cellPadding)
        .glassCard(isSelected: isNew, accentGlow: isNew, elevation: isNew ? .floating : .raised)
    }
}

struct ThemePreviewCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let theme: AppTheme
    let isUnlocked: Bool
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                HStack(spacing: 4) {
                    Circle().fill(Color(hex: theme.backgroundHex)).frame(width: 22, height: 22)
                    Circle().fill(Color(hex: theme.cardHex)).frame(width: 22, height: 22)
                    Circle().fill(Color(hex: theme.accentHex)).frame(width: 22, height: 22)
                }
                .padding(8)
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(theme.icon)
                        Text(theme.displayName)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    Text(isUnlocked ? theme.unlockRequirement : "🔒 \(theme.unlockRequirement)")
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(themeManager.accentColor)
                } else if !isUnlocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.appTextSecondary)
                }
            }
            .padding(AppDesign.cellPadding)
            .glassCard(isSelected: isSelected, elevation: isSelected ? .floating : .raised)
            .opacity(isUnlocked ? 1 : 0.55)
        }
        .buttonStyle(PressableCellStyle())
        .disabled(!isUnlocked)
    }
}

struct TipCardCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let icon: String
    let title: String
    let bodyText: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Text(icon)
                .font(.largeTitle)
                .frame(width: 44)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(bodyText)
                    .font(.subheadline)
                    .foregroundColor(.appTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(AppDesign.cellPadding)
        .glassCard()
    }
}

struct CreativeHighlightCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let text: String
    let word: String
    let score: Int

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "quote.opening")
                .foregroundColor(themeManager.accentColor)
                .font(.caption)
                .padding(.top, 4)

            VStack(alignment: .leading, spacing: 4) {
                Text("\"\(text)\"")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Text("\(word) • +\(score) pts")
                    .font(.caption)
                    .foregroundColor(.appTextSecondary)
            }
            Spacer()
        }
        .padding(AppDesign.cellPadding)
        .glassCard(cornerRadius: AppDesign.cornerRadiusSmall)
    }
}
