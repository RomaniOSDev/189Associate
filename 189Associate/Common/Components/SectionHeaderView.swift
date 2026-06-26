import SwiftUI

struct SectionHeaderView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let title: String
    var subtitle: String? = nil
    var trailing: String? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            AccentGradientCapsule()

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.88)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                }
            }

            Spacer()

            if let trailing {
                Text(trailing)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.accentColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(themeManager.accentColor.opacity(0.12))
                            .overlay(
                                Capsule()
                                    .stroke(themeManager.accentColor.opacity(0.25), lineWidth: 1)
                            )
                    )
            }
        }
    }
}
