import SwiftUI

struct GlassCardModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager
    var isSelected: Bool = false
    var accentGlow: Bool = false
    var elevation: DepthElevation = AppDesign.defaultElevation
    var cornerRadius: CGFloat = AppDesign.cornerRadius

    func body(content: Content) -> some View {
        content
            .background {
                DepthSurfaceBackground(
                    cornerRadius: cornerRadius,
                    isSelected: isSelected,
                    accentGlow: accentGlow
                )
            }
            .depthShadow(
                elevation: elevation,
                accentColor: themeManager.accentColor,
                accentGlow: accentGlow || isSelected
            )
    }
}

extension View {
    func glassCard(
        isSelected: Bool = false,
        accentGlow: Bool = false,
        elevation: DepthElevation = AppDesign.defaultElevation,
        cornerRadius: CGFloat = AppDesign.cornerRadius
    ) -> some View {
        modifier(GlassCardModifier(
            isSelected: isSelected,
            accentGlow: accentGlow,
            elevation: elevation,
            cornerRadius: cornerRadius
        ))
    }
}
