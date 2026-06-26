import SwiftUI

struct WordHeroCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let word: String
    let categoryIcon: String
    let categoryLabel: String
    let modeLabel: String
    var playerBanner: String? = nil
    var chainHint: String? = nil

    var body: some View {
        VStack(spacing: 12) {
            if let playerBanner {
                Text(playerBanner)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.accentColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(themeManager.accentColor.opacity(0.12))
                    .clipShape(Capsule())
            }

            Text(word)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            HStack(spacing: 8) {
                Text(categoryIcon)
                Text(categoryLabel)
                Text("•")
                Text(modeLabel)
            }
            .font(.caption)
            .foregroundColor(.appTextSecondary)

            if let chainHint {
                Text(chainHint)
                    .font(.caption)
                    .foregroundColor(themeManager.accentColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(themeManager.accentColor.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .glassCard(accentGlow: true, elevation: .floating)
    }
}

struct DailyChallengeBanner: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let isCompleted: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    themeManager.accentColor.opacity(0.35),
                                    themeManager.accentColor.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)
                    Text("📅")
                        .font(.title2)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Challenge")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(isCompleted ? "Completed today — great job!" : "One special word • bonus streak")
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                }

                Spacer()

                if isCompleted {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.appCorrect)
                        .font(.title3)
                } else {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(themeManager.accentColor)
                        .font(.title3)
                }
            }
            .padding(AppDesign.cellPadding)
            .glassCard(accentGlow: !isCompleted)
        }
        .buttonStyle(PressableCellStyle())
    }
}

struct ProfileHeroCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let title: String
    let activeTitle: String
    let streak: Int
    let recentScore: Int

    var body: some View {
        VStack(spacing: 16) {
            IconOrb(content: "🧠", size: 88, fontSize: .system(size: 44))

            VStack(spacing: 4) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(activeTitle)
                    .font(.subheadline)
                    .foregroundColor(themeManager.accentColor)
            }

            HStack(spacing: 16) {
                if streak > 0 {
                    Label("\(streak) day streak", systemImage: "flame.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.orange.opacity(0.12))
                        .clipShape(Capsule())
                }
                if recentScore > 0 {
                    Label("Last \(recentScore) pts", systemImage: "star.fill")
                        .font(.caption)
                        .foregroundColor(themeManager.accentColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(themeManager.accentColor.opacity(0.12))
                        .clipShape(Capsule())
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .glassCard(accentGlow: true, elevation: .floating)
    }
}

struct SecondaryButton: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let title: String
    var icon: String? = nil
    var style: Style = .outline
    let action: () -> Void

    enum Style {
        case outline
        case muted
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon { Text(icon) }
                Text(title)
                    .font(.headline)
            }
            .foregroundColor(style == .outline ? themeManager.accentColor : .appTextSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .glassCard(
                isSelected: style == .outline,
                accentGlow: style == .outline,
                elevation: style == .outline ? .raised : .flat,
                cornerRadius: AppDesign.cornerRadius
            )
        }
        .buttonStyle(PressableCellStyle())
    }
}

struct SettingsRowCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let icon: String
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 14) {
            IconOrb(content: icon, size: 40, fontSize: .subheadline, useSystemImage: true)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(themeManager.accentColor)
        }
        .padding(AppDesign.cellPadding)
    }
}

struct DestructiveActionCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                Text(title)
                    .font(.headline)
            }
            .foregroundColor(.appIncorrect)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .glassCard(cornerRadius: AppDesign.cornerRadius)
        }
        .buttonStyle(PressableCellStyle())
    }
}
