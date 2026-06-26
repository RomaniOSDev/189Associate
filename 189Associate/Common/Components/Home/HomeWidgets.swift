import SwiftUI

// MARK: - Hero Banner

struct HomeHeroBanner: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let greeting: String
    let activeTitle: String
    let titleIcon: String
    let onStart: () -> Void

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(HomeImageAsset.heroBanner)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()

            LinearGradient(
                colors: [
                    .clear,
                    Color.black.opacity(0.55),
                    Color.black.opacity(0.85)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 10) {
                Text(greeting)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.85))

                HStack(spacing: 8) {
                    Text(titleIcon)
                        .font(.title2)
                    Text(activeTitle)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }

                Button(action: onStart) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                        Text("Start Game")
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background {
                        PrimaryGradientFill(isEnabled: true)
                    }
                    .clipShape(Capsule())
                    .topInnerHighlight(cornerRadius: 20, opacity: 0.3)
                    .depthShadow(elevation: .raised, accentColor: themeManager.accentColor, accentGlow: true)
                }
                .buttonStyle(PressableCellStyle())
            }
            .padding(18)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous))
        .topInnerHighlight(cornerRadius: AppDesign.cornerRadius)
        .depthShadow(elevation: .floating, accentColor: themeManager.accentColor, accentGlow: true)
    }
}

// MARK: - Stat Widgets

struct HomeStatWidget: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let icon: String
    let value: String
    let label: String
    var accent: Color? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(icon)
                .font(.title3)

            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(label)
                .font(.caption2)
                .foregroundColor(.appTextSecondary)
        }
        .frame(width: 108, alignment: .leading)
        .padding(14)
        .glassCard(
            isSelected: accent != nil,
            accentGlow: accent != nil,
            cornerRadius: AppDesign.cornerRadiusSmall
        )
    }
}

struct HomeStatsRow: View {
    let streak: Int
    let gamesPlayed: Int
    let accuracy: Double
    let bestScore: Int
    let titlesEarned: Int

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppDesign.itemSpacing) {
                HomeStatWidget(
                    icon: "🔥",
                    value: streak > 0 ? "\(streak)" : "—",
                    label: "Day streak",
                    accent: streak > 0 ? .orange : nil
                )
                HomeStatWidget(
                    icon: "🎮",
                    value: "\(gamesPlayed)",
                    label: "Games played"
                )
                HomeStatWidget(
                    icon: "🎯",
                    value: gamesPlayed > 0 ? String(format: "%.0f%%", accuracy) : "—",
                    label: "Accuracy"
                )
                HomeStatWidget(
                    icon: "⭐",
                    value: bestScore > 0 ? "\(bestScore)" : "—",
                    label: "Best score",
                    accent: bestScore > 0 ? .yellow : nil
                )
                HomeStatWidget(
                    icon: "🏅",
                    value: "\(titlesEarned)",
                    label: "Titles earned"
                )
            }
            .padding(.horizontal, 1)
        }
    }
}

// MARK: - Quick Play

struct HomeQuickPlayCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let mode: GameMode
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                Image(HomeImageAsset.modeImage(mode))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 100)
                    .clipped()

                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.displayName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text(mode.subtitle)
                        .font(.caption2)
                        .foregroundColor(.appTextSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .padding(12)
                .frame(width: 140, alignment: .leading)
                .background {
                    DepthSurfaceBackground(
                        cornerRadius: 0,
                        isSelected: false,
                        accentGlow: false
                    )
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: AppDesign.cornerRadiusSmall, style: .continuous))
            .depthShadow(elevation: .raised, accentColor: themeManager.accentColor, accentGlow: false)
        }
        .buttonStyle(PressableCellStyle())
    }
}

struct HomeQuickPlaySection: View {
    let modes: [GameMode]
    let onSelect: (GameMode) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppDesign.itemSpacing) {
            SectionHeaderView(
                title: "Quick Play",
                subtitle: "Jump into a mode instantly"
            )

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppDesign.itemSpacing) {
                    ForEach(modes, id: \.self) { mode in
                        HomeQuickPlayCard(mode: mode) {
                            onSelect(mode)
                        }
                    }
                }
                .padding(.horizontal, 1)
            }
        }
    }
}

// MARK: - Daily Widget

struct HomeDailyWidget: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let isCompleted: Bool
    let categoryIcon: String
    let categoryName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                Image(HomeImageAsset.dailyChallenge)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 88)
                    .clipped()

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Daily Challenge")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Spacer()
                        if isCompleted {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.appCorrect)
                        }
                    }

                    Text(isCompleted ? "Completed today!" : "Today's theme")
                        .font(.caption2)
                        .foregroundColor(.appTextSecondary)

                    if !isCompleted {
                        HStack(spacing: 4) {
                            Text(categoryIcon)
                            Text(categoryName)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(themeManager.accentColor)
                        }
                    }

                    Text(isCompleted ? "Come back tomorrow" : "Tap to play →")
                        .font(.caption2)
                        .foregroundColor(isCompleted ? .appTextSecondary : themeManager.accentColor)
                }
                .padding(12)
            }
            .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
            .glassCard(
                isSelected: !isCompleted,
                accentGlow: !isCompleted,
                elevation: !isCompleted ? .floating : .raised
            )
        }
        .buttonStyle(PressableCellStyle())
    }
}

// MARK: - Progress Widget

struct HomeProgressWidget: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let strongestCategoryIcon: String?
    let strongestCategoryName: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                Image(HomeImageAsset.widgetProgress)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 72)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                Text("Your Progress")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                if let name = strongestCategoryName, let icon = strongestCategoryIcon {
                    HStack(spacing: 4) {
                        Text(icon)
                        Text("Strongest: \(name)")
                            .font(.caption)
                            .foregroundColor(themeManager.accentColor)
                            .lineLimit(1)
                    }
                } else {
                    Text("Play to unlock insights")
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                }

                Text("View stats →")
                    .font(.caption2)
                    .foregroundColor(.appTextSecondary)
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
            .glassCard(elevation: .raised)
        }
        .buttonStyle(PressableCellStyle())
    }
}

// MARK: - Explore Tile

struct HomeExploreTile: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let imageName: String?
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    if let imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 56)
                            .clipped()
                        LinearGradient(
                            colors: [.clear, Color.black.opacity(0.6)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 56)
                    } else {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(themeManager.accentColor.opacity(0.12))
                            .frame(height: 56)
                            .overlay {
                                Text(icon)
                                    .font(.title2)
                            }
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(.appTextSecondary)
                        .lineLimit(1)
                }
                .padding(12)
            }
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
            .background {
                DepthSurfaceBackground(
                    cornerRadius: AppDesign.cornerRadiusSmall,
                    isSelected: false,
                    accentGlow: false
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: AppDesign.cornerRadiusSmall, style: .continuous))
            .depthShadow(elevation: .raised)
        }
        .buttonStyle(PressableCellStyle())
    }
}

// MARK: - Tip Widget

struct HomeTipWidget: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let tip: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                IconOrb(content: "💡", size: 44, fontSize: .title3)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Tip of the Day")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text(tip)
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.appTextSecondary)
            }
            .padding(AppDesign.cellPadding)
            .glassCard()
        }
        .buttonStyle(PressableCellStyle())
    }
}
