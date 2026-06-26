import SwiftUI

struct ActionCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let icon: String
    let title: String
    var subtitle: String? = nil
    var trailing: String? = nil
    var badge: String? = nil
    var isSelected: Bool = false
    var showChevron: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                IconOrb(content: icon, size: 48, fontSize: .title2, isSelected: isSelected)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    if let subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.appTextSecondary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                }

                Spacer(minLength: 8)

                if let badge {
                    Text(badge)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.accentColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(themeManager.accentColor.opacity(0.15))
                        .clipShape(Capsule())
                }

                if let trailing {
                    Text(trailing)
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                }

                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(themeManager.accentColor.opacity(0.8))
                }
            }
            .padding(AppDesign.cellPadding)
            .glassCard(isSelected: isSelected)
        }
        .buttonStyle(PressableCellStyle())
    }
}

struct PressableCellStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .brightness(configuration.isPressed ? -0.03 : 0)
    }
}
