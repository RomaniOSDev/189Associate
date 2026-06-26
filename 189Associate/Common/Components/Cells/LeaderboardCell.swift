import SwiftUI

struct LeaderboardCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let rank: Int
    let name: String
    let subtitle: String
    let score: Int
    let comboText: String
    let isBest: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                rankBackground,
                                rankBackground.opacity(0.7)
                            ],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: 30
                        )
                    )
                    .overlay {
                        Circle()
                            .stroke(Color.white.opacity(rank <= 3 ? 0.2 : 0.08), lineWidth: 1)
                    }
                    .frame(width: 44, height: 44)
                Text(rankDisplay)
                    .font(rank <= 3 ? .title3 : .subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(rank <= 3 ? .white : .appTextSecondary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.appTextSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(score)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(isBest ? themeManager.accentColor : .white)
                Text(comboText)
                    .font(.caption)
                    .foregroundColor(.appCorrect)
            }
        }
        .padding(AppDesign.cellPadding)
        .glassCard(isSelected: isBest, accentGlow: isBest, elevation: isBest ? .floating : .raised)
    }

    private var rankDisplay: String {
        switch rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "#\(rank)"
        }
    }

    private var rankBackground: Color {
        if isBest { return themeManager.accentColor.opacity(0.25) }
        if rank <= 3 { return themeManager.accentColor.opacity(0.12) }
        return Color.white.opacity(0.06)
    }
}

struct HeroScoreCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let emoji: String
    let title: String
    let score: String
    var subtitle: String? = nil
    var detail: String? = nil

    var body: some View {
        VStack(spacing: 12) {
            if !emoji.isEmpty {
                Text(emoji)
                    .font(.system(size: 44))
            }
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.appTextSecondary)
                .textCase(.uppercase)
                .tracking(0.8)
            Text(score)
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            themeManager.accentColor.lightened(by: 0.12),
                            themeManager.accentColor,
                            themeManager.accentColor.darkened(by: 0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
            if let detail {
                Text(detail)
                    .font(.caption)
                    .foregroundColor(.appTextSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .glassCard(accentGlow: true, elevation: .floating)
    }
}
