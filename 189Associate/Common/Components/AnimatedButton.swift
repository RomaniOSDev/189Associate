import SwiftUI

struct AnimatedButton: View {
    let title: String
    let icon: String?
    let isEnabled: Bool
    let action: () -> Void

    @EnvironmentObject private var themeManager: ThemeManager

    init(
        title: String,
        icon: String? = nil,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let icon {
                    Text(icon)
                }
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .background {
                PrimaryGradientFill(isEnabled: isEnabled)
            }
            .clipShape(RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous))
            .topInnerHighlight(cornerRadius: AppDesign.cornerRadius, opacity: isEnabled ? 0.28 : 0.08)
            .depthShadow(
                elevation: isEnabled ? .floating : .flat,
                accentColor: themeManager.accentColor,
                accentGlow: isEnabled
            )
        }
        .disabled(!isEnabled)
        .buttonStyle(PressableCellStyle())
    }
}
