import SwiftUI

struct GradientBackground: View {
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    themeManager.backgroundColor.lightened(by: 0.03),
                    themeManager.backgroundColor,
                    themeManager.backgroundColor.darkened(by: 0.08)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            RadialGradient(
                colors: [
                    themeManager.accentColor.opacity(0.2),
                    themeManager.accentColor.opacity(0.05),
                    .clear
                ],
                center: .topTrailing,
                startRadius: 20,
                endRadius: 420
            )

            RadialGradient(
                colors: [
                    themeManager.accentColor.opacity(0.1),
                    .clear
                ],
                center: .bottomLeading,
                startRadius: 10,
                endRadius: 300
            )

            LinearGradient(
                colors: [
                    .clear,
                    Color.black.opacity(0.12)
                ],
                startPoint: .center,
                endPoint: .bottom
            )
        }
        .drawingGroup(opaque: false)
        .ignoresSafeArea()
    }
}
