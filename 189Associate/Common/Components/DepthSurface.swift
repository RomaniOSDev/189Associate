import SwiftUI

enum DepthElevation: Equatable {
    case flat
    case raised
    case floating

    var shadowRadius: CGFloat {
        switch self {
        case .flat: return 0
        case .raised: return 10
        case .floating: return 16
        }
    }

    var shadowYOffset: CGFloat {
        switch self {
        case .flat: return 0
        case .raised: return 5
        case .floating: return 8
        }
    }

    var shadowOpacity: Double {
        switch self {
        case .flat: return 0
        case .raised: return 0.28
        case .floating: return 0.34
        }
    }
}

struct DepthSurfaceBackground: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let cornerRadius: CGFloat
    let isSelected: Bool
    let accentGlow: Bool

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        shape
            .fill(
                LinearGradient(
                    colors: [
                        themeManager.cardColor.lightened(by: 0.1),
                        themeManager.cardColor,
                        themeManager.cardColor.darkened(by: 0.12)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                if isSelected || accentGlow {
                    shape.fill(
                        RadialGradient(
                            colors: [
                                themeManager.accentColor.opacity(0.18),
                                .clear
                            ],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: 180
                        )
                    )
                }
            }
            .overlay(alignment: .top) {
                shape
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.14),
                                Color.white.opacity(0.04),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: cornerRadius * 2.2)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .allowsHitTesting(false)
            }
            .overlay {
                shape.stroke(borderGradient, lineWidth: isSelected ? 1.5 : 1)
            }
    }

    private var borderGradient: LinearGradient {
        if isSelected || accentGlow {
            return LinearGradient(
                colors: [
                    themeManager.accentColor.opacity(0.95),
                    themeManager.accentColor.opacity(0.22),
                    themeManager.accentColor.opacity(0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        return LinearGradient(
            colors: [
                Color.white.opacity(0.16),
                Color.white.opacity(0.06),
                Color.white.opacity(0.02)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct IconOrb: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let content: String
    var size: CGFloat = 48
    var fontSize: Font = .title2
    var isSelected: Bool = false
    var useSystemImage: Bool = false

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            themeManager.accentColor.opacity(isSelected ? 0.42 : 0.28),
                            themeManager.accentColor.opacity(isSelected ? 0.14 : 0.06)
                        ],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: size * 0.9
                    )
                )
                .overlay {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.22),
                                    themeManager.accentColor.opacity(0.15)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
                .frame(width: size, height: size)

            if useSystemImage {
                Image(systemName: content)
                    .font(fontSize)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, themeManager.accentColor.opacity(0.85)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            } else {
                Text(content)
                    .font(fontSize)
            }
        }
        .compositingGroup()
        .shadow(color: themeManager.accentColor.opacity(isSelected ? 0.28 : 0.14), radius: 8, y: 4)
    }
}

struct AccentGradientCapsule: View {
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [
                        themeManager.accentColor,
                        themeManager.accentColor.opacity(0.55)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: 4, height: 22)
    }
}

struct PrimaryGradientFill: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let isEnabled: Bool

    var body: some View {
        Group {
            if isEnabled {
                LinearGradient(
                    colors: [
                        themeManager.accentColor.lightened(by: 0.08),
                        themeManager.accentColor,
                        themeManager.accentColor.darkened(by: 0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                LinearGradient(
                    colors: [
                        themeManager.cardColor.lightened(by: 0.04),
                        themeManager.cardColor.darkened(by: 0.06)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
}

extension View {
    func depthShadow(
        elevation: DepthElevation = .raised,
        accentColor: Color? = nil,
        accentGlow: Bool = false
    ) -> some View {
        compositingGroup()
            .shadow(
                color: .black.opacity(elevation.shadowOpacity),
                radius: elevation.shadowRadius,
                y: elevation.shadowYOffset
            )
            .shadow(
                color: (accentColor ?? .clear).opacity(accentGlow ? 0.24 : 0),
                radius: elevation == .floating ? 14 : 10,
                y: elevation.shadowYOffset
            )
    }

    func topInnerHighlight(
        cornerRadius: CGFloat = AppDesign.cornerRadius,
        opacity: Double = 0.18
    ) -> some View {
        overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(opacity),
                            Color.white.opacity(opacity * 0.25),
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
                .allowsHitTesting(false)
        }
    }

    func appScreenBackground() -> some View {
        background {
            GradientBackground()
        }
    }
}
