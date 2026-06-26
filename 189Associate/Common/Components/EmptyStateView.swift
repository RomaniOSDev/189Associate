import SwiftUI

struct EmptyStateView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let icon: String
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(themeManager.accentColor.opacity(0.1))
                    .frame(width: 100, height: 100)
                Text(icon)
                    .font(.system(size: 48))
            }

            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            AnimatedButton(title: buttonTitle, action: action)
                .padding(.horizontal, 40)
        }
        .padding()
    }
}
